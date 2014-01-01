//
//  RSUModel.m
//  RunSignUp
//
// Copyright 2012 RunSignUp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "RSUModel.h"
#import "RXMLElement.h"
#import "JSON.h"

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
@synthesize downloadedRecords;
@synthesize isOffline;

- (id)init{
    self = [super init];
    if(self){
        self.renewTimer = nil;
    }
    return self;
}

/* Attempt to retrieve a list of races and subsequent events that
   the race director is currently in charge of. If no races are found
   then an empty array is returned. */
- (void)attemptRetrieveRaceList:(void (^)(NSArray *))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    }else{
        if([self renewCredentials] == RSUSuccess){
            NSString *url = [NSString stringWithFormat:@"%s/rest/races?tmp_key=%@&tmp_secret=%@&events=T", RSUDOMAIN, key, secret];
            
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
}

/* Attempt to retrieve a list of result sets that exist in the current
   event that has been chosen. Result sets are matchings of timing/chute
   data that exist independently of the actual data, and multiple result
   sets can exist at any given time */
- (void)attemptRetrieveResultSetList:(NSString *)raceID event:(NSString *)eventID response:(void (^)(NSMutableArray *))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=get-result-sets&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, raceID, eventID, key, secret];
        
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
                            //RXMLElement *resultsHeaders = [individualResult child: @"results_headers"];
                            
                            if(individualResultID != nil && individualResultName != nil){
                                /*NSMutableArray *headersArray = [[NSMutableArray alloc] init];
                                
                                if(resultsHeaders != nil){
                                    for(RXMLElement *field in [resultsHeaders children: @"field"]){
                                        RXMLElement *name = [field child: @"name"];
                                        
                                        if(name != nil && [name text] != nil)
                                            [headersArray addObject: [name text]];
                                    }
                                }
                                */
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
}

/* Attempt to retrieve the list of participants for a given event. */
- (void)attemptRetrieveParticipants:(void (^)(NSMutableArray *))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/participants?event_id=%@&page=1&sort=last_name,first_name&results_per_page=250&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){    
            NSMutableArray *participants = [[NSMutableArray alloc] init];
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
            if(urlData != nil){
                RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
                if([[rootXML tag] isEqualToString: @"events"]){
                    NSArray *events = [rootXML children: @"event"];
                    for(int x = 0; x < [events count]; x++){
                        RXMLElement *event = [events objectAtIndex: x];
                        RXMLElement *eventParticipants = [event child:@"participants"];
                        NSArray *participantsArray = [eventParticipants children: @"participant"];
                        for(int y = 0; y < [participantsArray count]; y++){
                            NSMutableDictionary *participantDict = [[NSMutableDictionary alloc] init];
                            RXMLElement *user = [[participantsArray objectAtIndex: y] child: @"user"];
                            RXMLElement *regID = [[participantsArray objectAtIndex: y] child: @"registration_id"];
                            RXMLElement *bib = [[participantsArray objectAtIndex: y] child: @"bib_num"];
                            RXMLElement *age = [[participantsArray objectAtIndex: y] child: @"age"];
                            
                            if(user){
                                RXMLElement *firstName = [user child: @"first_name"];
                                RXMLElement *lastName = [user child: @"last_name"];
                                RXMLElement *address = [user child: @"address"];
                                RXMLElement *gender = [user child: @"gender"];
                                
                                if(firstName && [firstName text]){
                                    [participantDict setObject:[firstName text] forKey:@"FirstName"];
                                }
                                if(lastName && [lastName text]){
                                    [participantDict setObject:[lastName text] forKey:@"LastName"];
                                }
                                if(address){
                                    RXMLElement *city = [address child: @"city"];
                                    RXMLElement *state = [address child: @"state"];
                                    
                                    if(city && [city text]){
                                        [participantDict setObject:[city text] forKey:@"City"];
                                    }
                                    if(state && [state text]){
                                        [participantDict setObject:[state text] forKey:@"State"];
                                    }
                                }
                                if(gender && [gender text]){
                                    [participantDict setObject:[gender text] forKey:@"Gender"];
                                }
                            }
                            if(regID && [regID text]){
                                [participantDict setObject:[regID text] forKey:@"RegistrationID"];
                            }
                            if(bib && [bib text]){
                                [participantDict setObject:[bib text] forKey:@"Bib"];
                            }
                            if(age && [age text]){
                                [participantDict setObject:[age text] forKey:@"Age"];
                            }
                            
                            [participants addObject: participantDict];
                        }
                    }
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(participants);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

- (void)attemptRetrieveResults:(void (^)(NSMutableArray *))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/results/get-results/?event_id=%@&page=1&sort=last_name,first_name&results_per_page=250&tmp_key=%@&tmp_secret=%@&format=csv", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){            
            NSString *csvString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            
            if(urlData != nil){
                NSMutableArray *results = [self parseCSV:csvString];
                if([results count] > 0){
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(results);});
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(nil);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

- (NSMutableArray *)parseCSV:(NSString *)csv{
    resultsArray = [[NSMutableArray alloc] init];
    keyArray = [[NSMutableArray alloc] init];
    currentEntry = nil;
    readingKeys = NO;
    
    csvParser = [[CHCSVParser alloc] initWithCSVString: csv];
    [csvParser setDelegate: self];
    [csvParser parse];
    [csvParser release];
    
    return resultsArray;
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber{
    if(recordNumber == 1){
        readingKeys = YES;
    }else{
        readingKeys = NO;
        currentEntry = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex{
    if(readingKeys){
        [keyArray addObject: field];
    }else{
        if([field length] > 0 && ![field isEqualToString:@"null"])
            [currentEntry setObject:field forKey:[keyArray objectAtIndex: fieldIndex]]; // utilize keyArray as the key lookup
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber{
    if(!readingKeys){
        if([[currentEntry allKeys] count] > 0){
            [resultsArray addObject: currentEntry];
            [currentEntry release];
            currentEntry = nil;
        }
    }
}

/* Attempt to log in with the given email and password. Multiple responses
   can be returned: no connection, invalid email, invalid pass, success. If
   successful, then the secret and key are stored inside the RSUModel object. */
- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        self.email = em;
        self.password = pa;
        
        NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", em, pa];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s/rest/login", RSUDOMAIN]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
            if(!urlData){
                NSLog(@"URLData is nil");
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
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
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                    return;
                }else{
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                    return;
                }
            }else if([[rootXML tag] isEqualToString:@"error"]){
                RXMLElement *error_code = [rootXML child:@"error_code"];
                
                if([error_code textAsInt] == 101){
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidEmail);});
                    return;
                }else if([error_code textAsInt] == 102){
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUInvalidPassword);});
                    return;
                }
            }
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Add the array of finishing times to the end of the existing timing
   data on the results server. If the results are recieved out of order,
   then save the last_finishing_time_id and retry uploading. */
- (void)addFinishingTimes:(NSArray *)finishingTimes response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=finishing-times&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSString *jsonRequest = [NSString stringWithFormat: @"{\"last_finishing_time_id\": %@,\"finishing_times\": %@}", lastFinishingTimeID, [finishingTimes JSONRepresentation]];
        
        NSString *post = [NSString stringWithFormat:@"request_format=json&individual_result_set_id=%@&request=%@", currentResultSetID, jsonRequest];
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
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
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                    return;
                }
            }else if([[rootXML tag] isEqualToString: @"error"]){
                RXMLElement *errorCode = [rootXML child: @"error_code"];
                RXMLElement *errorDetails = [rootXML child: @"error_details"];
                
                if(errorCode != nil && [[errorCode text] isEqualToString:@"12"]){
                    if(errorDetails != nil){
                        RXMLElement *errorMessage = [errorDetails child: @"error_msg"];
                        if(errorMessage != nil && [[[errorMessage text] substringToIndex:27] isEqualToString:@"Last finishing time id was "]){
                            NSString *timeIDString = [[errorMessage text] substringFromIndex: 27];
                            timeIDString = [timeIDString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            self.lastFinishingTimeID = timeIDString;
                            
                            [self addFinishingTimes:finishingTimes response:responseBlock];
                            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                            return;
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Add finishing bib numbers to the end of the existing chute data on the
   results server. If they are recieved out of order, save the last_finishing_place
   and retry uploading. */
- (void)addFinishingBibs:(NSArray *)finishingBibs response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=bib-order&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSString *jsonRequest = [NSString stringWithFormat: @"{\"last_finishing_place\": %@,\"bib_nums\": %@}", lastBibNumber, [finishingBibs JSONRepresentation]];
        
        NSString *post = [NSString stringWithFormat:@"request_format=json&individual_result_set_id=%@&request=%@", currentResultSetID, jsonRequest];
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
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
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                    return;
                }
            }else if([[rootXML tag] isEqualToString: @"error"]){
                RXMLElement *errorCode = [rootXML child: @"error_code"];
                RXMLElement *errorDetails = [rootXML child: @"error_details"];
                
                if(errorCode != nil && [[errorCode text] isEqualToString:@"12"]){
                    if(errorDetails != nil){
                        RXMLElement *errorMessage = [errorDetails child: @"error_msg"];
                        if(errorMessage != nil && [[[errorMessage text] substringToIndex:34] isEqualToString:@"Last received finishing place was "]){
                            NSString *chuteNumberString = [[errorMessage text] substringFromIndex: 34];
                            chuteNumberString = [chuteNumberString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                            self.lastBibNumber = chuteNumberString;
                            
                            [self addFinishingBibs:finishingBibs response:responseBlock];
                            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                            return;
                        }
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Add a participant into the listings for a given event. Data expected in participant
   dictionary is: FirstName, LastName, Gender, Bib, Age, City, State */
- (void)editParticipants:(NSArray *)participants response:(void (^)(RSUConnectionResponse, NSString *))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
    }else{
        NSMutableArray *actualParticipants = [[NSMutableArray alloc] init];
        for(int x = 0; x < [participants count]; x++){
            NSMutableDictionary *actualParticipant = [[NSMutableDictionary alloc] init];
            NSDictionary *addressDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[participants objectAtIndex: x] objectForKey:@"State"], @"state", [[participants objectAtIndex: x] objectForKey:@"City"], @"city", nil];
            NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[participants objectAtIndex: x] objectForKey:@"FirstName"], @"first_name", [[participants objectAtIndex: x] objectForKey:@"LastName"], @"last_name", addressDict, @"address", nil];
            
            [actualParticipant setObject:userDict forKey:@"user"];
            [actualParticipant setObject:[[participants objectAtIndex: x] objectForKey:@"Age"] forKey:@"age"];
            [actualParticipant setObject:[[participants objectAtIndex: x] objectForKey:@"Gender"] forKey:@"gender"];
            [actualParticipant setObject:[[participants objectAtIndex: x] objectForKey:@"Bib"] forKey:@"bib_num"];
            if([[participants objectAtIndex: x] objectForKey: @"RegistrationID"] != nil)
                [actualParticipant setObject:[[participants objectAtIndex: x] objectForKey:@"RegistrationID"] forKey:@"registration_id"];
            [actualParticipants addObject: actualParticipant];
        }
        
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/participants?event_id=%@&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSString *jsonRequest = [NSString stringWithFormat: @"{\"participants\": %@}", [actualParticipants JSONRepresentation]];
        
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString: @"participant"]){
                RXMLElement *regID = [rootXML child: @"registration_id"];
                if(regID && [regID text]){
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, [regID text]);});
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Detect differences between data on the device and data on the server. If changes
   are detected, allow the user to download, upload or delete all data. */
- (void)detectDifferencesBetweenLocalAndOnline:(NSArray *)records type:(int)type response:(void (^)(RSUDifferences))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUDifferencesNone);});
    }else{
        NSString *url;
        if(type == 0)
            url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=get-timing-data&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        else if(type == 1)
            url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=get-checker-data&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        else
            url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=get-chute-data&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];

        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){    
            self.downloadedRecords = [[NSMutableArray alloc] init];
            
            if(!urlData){
                NSLog(@"URLData is nil");
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if(type == 0){
                if([[rootXML tag] isEqualToString: @"finishing_times"]){
                    NSArray *dataTotal = [rootXML children:@"finishing_time"];
                    if(dataTotal && [dataTotal count] > 0){
                        for(int x = 0; x < [dataTotal count]; x++){
                            RXMLElement *data = [[dataTotal objectAtIndex:x] child:@"time"];
                            if([data text] != nil){
                                [downloadedRecords addObject: [data text]];
                            }
                        }
                    }
                }
            }else if(type == 1){
                // checker
            }else if(type == 2){
                if([[rootXML tag] isEqualToString: @"bib_finishing_order"]){
                    NSArray *dataTotal = [rootXML children:@"bib_finish"];
                    if(dataTotal && [dataTotal count] > 0){
                        for(int x = 0; x < [dataTotal count]; x++){
                            RXMLElement *data = [[dataTotal objectAtIndex:x] child:@"bib_num"];
                            if([data text] != nil){
                                [downloadedRecords addObject: [data text]];
                            }
                        }
                    }
                }
            }
            
            
            if([downloadedRecords count] == [records count])
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUDifferencesNone);});
            else{
                if([downloadedRecords count] == 0)
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUDifferencesServerEmpty);});
                else if([records count] == 0)
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUDifferencesClientEmpty);});
                else
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUDifferencesBothDifferent);});
            }
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

- (void)recordStartDateOfTimer:(NSString *)startDate response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=start-time&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSString *jsonRequest = [NSString stringWithFormat: @"{\"start_time\": \"%@\"}", startDate];
        
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString: @"response"]){
                if([rootXML child:@"success"] != nil){
                    if([[[rootXML child:@"success"] text] isEqualToString:@"T"]){
                        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                        return;
                    }
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

- (void)retrieveStartDateOfTimer:(void (^)(RSUConnectionResponse, NSString *))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=start-time&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
            if(!urlData){
                NSLog(@"URLData is nil");
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString: @"event_start"]){
                RXMLElement *startTime = [rootXML child: @"start_time"];
                if(startTime && [startTime text]){
                    NSString *startDateString = [startTime text];
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess, startDateString);});
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection, nil);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Renew credentials every X amount of time so the user does not get logged out due to
   inactivity. */
- (int)renewCredentials{
    if(isOffline){
        return RSUNoConnection;
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/user?tmp_key=%@&tmp_secret=%@", RSUDOMAIN, key, secret];
        
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
                return RSUNoConnection;
            }
        }else{
            return RSUNoConnection;
        }
        
        return RSUSuccess;
    }
}

/* Create a new result set with a given name. Result set will automatically
   be set as the current result set and will be empty. */
- (void)createNewResultSet:(NSString *)name response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=new-result-set&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"individual_result_set_name\": \"%@\"}", name];
        
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString: @"response"]){
                RXMLElement *individualResultID = [rootXML child:@"individual_result_set_id"];
                if(individualResultID != nil){
                    self.currentResultSetID = [individualResultID text];
                    self.lastFinishingTimeID = @"0";
                    self.lastBibNumber = @"0";
                    dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                    return;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Delete a given result set with a resultSetId. */
- (void)deleteResultSet:(NSString *)resultSetID response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&request_type=delete-result-set&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];
        
        NSString *post = [NSString stringWithFormat: @"individual_result_set_id=%@", resultSetID];
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString: @"response"]){
                if([rootXML child:@"success"] != nil){
                    if([[[rootXML child:@"success"] text] isEqualToString:@"T"]){
                        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                        return;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Delete data from the results server given a category. 
   RSUClearResults will call clear-results and delete all the matchings for a result set id.
   RSUClearTimer will call delete-timing-data and delete timing but leave result sets alone.
   RSUClearCheck and RSUClearChute do the same as RSUClearTimer but for respective data. */
- (void)deleteResults:(RSUClearCategory)category response:(void (^)(RSUConnectionResponse))responseBlock{
    if(isOffline){
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
    }else{
        NSString *url = [NSString stringWithFormat:@"%s/rest/Race/%@/Results?event_id=%@&tmp_key=%@&tmp_secret=%@&format=xml", RSUDOMAIN, currentRaceID, currentEventID, key, secret];

        NSString *post;
        if(category == RSUClearResults)
            post = [NSString stringWithFormat:@"request_type=clear-results&individual_result_set_id=%@", currentResultSetID];
        else if(category == RSUClearTimer){
            post = @"request_type=delete-timing-data";
            self.lastFinishingTimeID = @"0";
        }else if(category == RSUClearChecker)
            post = @"request_type=delete-checker-data"; 
        else if(category == RSUClearChute){
            post = @"request_type=delete-chute-data";
            self.lastBibNumber = @"0";
        }else{
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
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
                dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
                return;
            }
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
            RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
            if([[rootXML tag] isEqualToString: @"response"]){
                if([rootXML child:@"success"] != nil){
                    if([[[rootXML child:@"success"] text] isEqualToString:@"T"]){
                        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUSuccess);});
                        return;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),^(){responseBlock(RSUNoConnection);});
        };
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:completion];
    }
}

/* Log out the current user in a synchronous manner to tie up any loose ends. Not completely
   necessary but good practice all the same */
- (void)logout{
    if(!isOffline){
        NSString *url = [NSString stringWithFormat:@"%s/rest/logout?tmp_key=%@&tmp_secret=%@", RSUDOMAIN, key, secret];
        
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
}

+ (id)sharedModel{
    @synchronized(self){
        if(model == nil)
            model = [[self alloc] init];
    }
    return model;
}

@end
