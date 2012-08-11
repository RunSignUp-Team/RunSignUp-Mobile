//
//  RSUModel.m
//  RunSignup
//
//  Created by Billy Connolly on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RSUModel.h"
#import "RXMLElement.h"

static RSUModel *model = nil;

@implementation RSUModel
@synthesize key;
@synthesize secret;
@synthesize email;
@synthesize password;
@synthesize currentResultSetID;
@synthesize currentRaceID;
@synthesize currentEventID;
@synthesize lastFinishingTimeID;
@synthesize lastBibNumber;
@synthesize renewTimer;

- (id)init{
    self = [super init];
    if(self){
        self.renewTimer = nil;
    }
    return self;
}

- (void)attemptRetreiveRaceList:(void (^)(NSArray *))responseBlock{
    if([self renewCredentials] == Success){
        NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/races?tmp_key=%@&tmp_secret=%@&events=T", key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];

        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
            NSMutableArray *raceList = [[NSMutableArray alloc] init];
            
            //NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            //NSLog(string);
            
            if(urlData != nil){
                RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
                if([[rootXML tag] isEqualToString:@"races"]){
                    NSArray *races = [rootXML children:@"race"];
                    if(races != nil){
                        for(RXMLElement *race in races){
                            RXMLElement *raceName = [race child:@"name"];
                            RXMLElement *raceID = [race child:@"race_id"];
                            RXMLElement *raceNextDate = [race child:@"next_date"];
                            RXMLElement *raceLastDate = [race child:@"last_date"];
                            RXMLElement *raceEvents = [race child:@"events"];
                            
                            NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
                            NSDictionary *raceDict = nil;
                            if(raceEvents != nil){
                                NSArray *events = [raceEvents children:@"event"];
                                for(RXMLElement *event in events){
                                    RXMLElement *eventName = [event child:@"name"];
                                    RXMLElement *eventID = [event child:@"event_id"];
                                    RXMLElement *eventStartTime = [event child:@"start_time"];
                                    
                                    if(eventName != nil && eventID != nil){
                                        NSString *curtailedName = [eventName text];
                                        if([curtailedName length] > 34)
                                            curtailedName = [curtailedName substringToIndex: 33];
                                        [eventsArray addObject: [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"Name",[eventID text],@"EventID",[eventStartTime text],@"StartTime", nil]];
                                    }
                                }
                            }
                            
                            if(raceName != nil && raceID != nil && [eventsArray count] != 0){
                                NSString *curtailedName = [raceName text];
                                if([curtailedName length] > 34)
                                    curtailedName = [curtailedName substringToIndex: 33];
                                raceDict = [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"Name",[raceID text],@"RaceID",[raceNextDate text],@"NDate",[raceLastDate text],@"LDate",eventsArray,@"Events",nil];
                                [raceList addObject: raceDict];
                            }
                        }
                    }
                }
                
                if([raceList count] == 0)
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(raceList);});
            }else{
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
            }

        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
        
    }else{
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    }
}

- (void)attemptRetreiveResultSetList:(NSString *)raceID event:(NSString *)eventID response:(void (^)(NSArray *))responseBlock{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/Race/%@/Results?event_id=%@&request_type=get-result-sets&tmp_key=%@&tmp_secret=%@&format=xml", raceID, eventID, key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){    
        NSMutableArray *resultSetList = [[NSMutableArray alloc] init];
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        
        if(urlData != nil){
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString:@"event_individual_results"]){
                NSArray *individualResultSets = [rootXML children:@"individual_results_set"];
                if(individualResultSets != nil){
                    for(int x = 0; x < [individualResultSets count]; x++){
                        RXMLElement *individualResult = [[rootXML children:@"individual_results_set"] objectAtIndex: x];
                        RXMLElement *individualResultName = [individualResult child: @"individual_result_set_name"];
                        RXMLElement *individualResultID = [individualResult child: @"individual_result_set_id"];
                        
                        if(individualResultID != nil && individualResultName != nil){
                            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[individualResultName text], @"ResultSetName", [individualResultID text], @"ResultSetID", nil];
                            [resultSetList addObject: dict];
                        }
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(resultSetList);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)beginTimingNewRace:(NSString *)raceID event:(NSString *)eventID response:(void (^)(int))responseBlock{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/Race/%@/Results?event_id=%@&request_type=get-result-sets&tmp_key=%@&tmp_secret=%@&format=xml", raceID, eventID, key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        
        if(urlData != nil){
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString:@"event_individual_results"]){
                if([[rootXML children:@"individual_results_set"] count] > 0){
                    // Individual result set exists
                    if([[rootXML children:@"individual_results_set"] count] == 1){
                        RXMLElement *individualResult = [[rootXML children:@"individual_results_set"] objectAtIndex: 0];
                        RXMLElement *individualResultId = [individualResult child: @"individual_result_set_id"];
                        if(individualResultId != nil){
                            self.currentResultSetID = [individualResultId text];
                            self.currentRaceID = raceID;
                            self.currentEventID = eventID;
                            self.lastFinishingTimeID = @"0";
                            self.lastBibNumber = @"0";
                            // All future calls to addFinishingTime and its related methods will use this info
                            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                            return;
                        }
                    }else{
                        // More than one individual result set exists (pick one?) fake no connection for now
                        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
                        return;
                    }
                }else{
                    // Create new individual result set
                    void (^response)(int) = ^(int didSucceed){
                        if(didSucceed){
                            self.currentRaceID = raceID;
                            self.currentEventID = eventID;
                            self.lastFinishingTimeID = @"0";
                            self.lastBibNumber = @"0";
                            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                        }else{
                            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
                        }
                    };
                    
                    [self createNewResultSet:response];
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
        }
        
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(int))responseBlock{
    self.email = em;
    self.password = pa;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", em, pa];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"https://test.runsignup.com/rest/login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
            return;
        }
        
        if(self.renewTimer == nil)
            self.renewTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(renewCredentials) userInfo:nil repeats:NO];
        else{
            [renewTimer invalidate];
            self.renewTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(renewCredentials) userInfo:nil repeats:NO];
        }
        
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        
        if([[rootXML tag] isEqualToString:@"login"]){
            RXMLElement *tmp_key = [rootXML child:@"tmp_key"];
            RXMLElement *tmp_secret = [rootXML child:@"tmp_secret"];
            
            if(tmp_key != nil && tmp_secret != nil){
                self.key = [tmp_key text];
                self.secret = [tmp_secret text];
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                return;
            }else{
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
                return;
            }
        }else if([[rootXML tag] isEqualToString:@"error"]){
            RXMLElement *error_code = [rootXML child:@"error_code"];
            
            if([error_code textAsInt] == 101){
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(InvalidEmail);});
                return;
            }else if([error_code textAsInt] == 102){
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(InvalidPassword);});
                return;
            }
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)addFinishingTime:(NSString *)finishingTime response:(void (^)(int))responseBlock{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/Race/%@/Results?event_id=%@&request_type=finishing-times&tmp_key=%@&tmp_secret=%@&format=xml", currentRaceID, currentEventID, key, secret];
    
    NSString *jsonRequest = [NSString stringWithFormat: @"{\"last_finishing_time_id\": %@,\"finishing_times\": [\"%@\"]}", lastFinishingTimeID, finishingTime];
    
    NSString *post = [NSString stringWithFormat:@"request_format=json&request=%@", jsonRequest];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
            return;
        }
                
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString: @"event_individual_results_upload"]){
            RXMLElement *finishingTimes = [rootXML child:@"finishing_times"];
            NSArray *finishingTimeArray = [finishingTimes children:@"finishing_time"];
            if(finishingTimeArray != nil && [finishingTimeArray count] > 0){
                RXMLElement *finishingTimeID = [[finishingTimeArray objectAtIndex: [finishingTimeArray count] - 1] child:@"finishing_time_id"];
                self.lastFinishingTimeID = [finishingTimeID text];
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)addFinishingBib:(NSString *)finishingBib response:(void (^)(int))responseBlock{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/Race/%@/Results?event_id=%@&request_type=bib-order&tmp_key=%@&tmp_secret=%@&format=xml", currentRaceID, currentEventID, key, secret];
    
    NSString *jsonRequest = [NSString stringWithFormat: @"{\"last_finishing_place\": %@,\"bib_nums\": [\"%@\"]}", lastBibNumber, finishingBib];
    
    NSString *post = [NSString stringWithFormat:@"request_format=json&request=%@", jsonRequest];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString: @"event_individual_results_upload"]){
            RXMLElement *finishingOrder = [rootXML child:@"bib_finishing_order"];
            NSArray *finishingArray = [finishingOrder children:@"bib_finish"];
            if(finishingArray != nil && [finishingArray count] > 0){
                RXMLElement *finishingPlace = [[finishingArray objectAtIndex: [finishingArray count] - 1] child:@"finishing_place"];
                self.lastBibNumber = [finishingPlace text];
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (int)renewCredentials{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/user?tmp_key=%@&tmp_secret=%@", key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(self.renewTimer == nil)
        self.renewTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(renewCredentials) userInfo:nil repeats:NO];
    else{
        [renewTimer invalidate];
        self.renewTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(renewCredentials) userInfo:nil repeats:NO];
    }
        
    if(urlData){
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if(![[rootXML tag] isEqualToString:@"user"]){
            //int attempt = [self attemptLoginWithEmail:email pass:password];
            return NoConnection;
        }
    }else{
        return NoConnection;
    }
    
    return Success;
}

- (void)createNewResultSet:(void (^)(int))responseBlock{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/Race/%@/Results?event_id=%@&request_type=new-result-set&tmp_key=%@&tmp_secret=%@&format=xml", currentRaceID, currentEventID, key, secret];
    
    NSString *jsonRequest = @"{\"individual_result_set_name\": \"RSUMT Test\"}";
    
    NSString *post = [NSString stringWithFormat:@"request_format=json&request=%@", jsonRequest];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString: @"response"]){
            RXMLElement *individualResultID = [rootXML child:@"individual_result_set_id"];
            if(individualResultID != nil){
                self.currentResultSetID = [individualResultID text];
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                return;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)deleteResults:(int)which response:(void (^)(int))responseBlock{
    
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/Race/%@/Results?event_id=%@&tmp_key=%@&tmp_secret=%@&format=xml", currentRaceID, currentEventID, key, secret];

    NSString *post;
    if(which == ClearAll)
        post = [NSString stringWithFormat:@"request_type=clear-results&individual_result_set_id=%@", currentResultSetID];
    else if(which == ClearTimer)
        post = @"request_type=delete-timing-data";
    else if(which == ClearChecker)
        post = @"request_type=delete-checker-data"; 
    else if(which == ClearChute)
        post = @"request_type=delete-chute-data";
    else{
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
        return;
    }
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
        if(!urlData){
            NSLog(@"URLData is nil");
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(string);
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString: @"response"]){
            if([rootXML child:@"success"] != nil){
                if([[[rootXML child:@"success"] text] isEqualToString:@"T"]){
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(Success);});
                    return;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(NoConnection);});
    };
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
}

- (void)logout{
    NSString *url = [NSString stringWithFormat:@"https://test.runsignup.com/rest/logout?tmp_key=%@&tmp_secret=%@", key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    urlData = nil;
    self.key = nil;
    self.secret = nil;
    self.email = nil;
    self.password = nil;
    
    [self.renewTimer invalidate];
    self.renewTimer = nil;
}

+ (id)sharedModel{
    @synchronized(self){
        if(model == nil)
            model = [[self alloc] init];
    }
    return model;
}

@end
