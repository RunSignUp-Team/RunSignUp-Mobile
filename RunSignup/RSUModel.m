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
        NSString *url = [NSString stringWithFormat:@"https://runsignup.com/rest/races?tmp_key=%@&tmp_secret=%@", key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];

        void (^completion)(NSURLResponse *,NSData *,NSError *) = ^(NSURLResponse *response,NSData *urlData,NSError *error){
            NSMutableArray *raceList = [[NSMutableArray alloc] init];
            
            NSString *string = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(string);
            
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
                            if(raceName != nil && raceID != nil){
                                NSString *curtailedName = [raceName text];
                                if([curtailedName length] > 34)
                                    curtailedName = [curtailedName substringToIndex: 33];
                                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"Name",[raceID text],@"RaceID",[raceNextDate text],@"NDate",[raceLastDate text],@"LDate",nil];
                                [raceList addObject: dict];
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

- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(int))responseBlock{
    self.email = em;
    self.password = pa;
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", em, pa];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"https://runsignup.com/rest/login"]];
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

- (int)renewCredentials{
    NSString *url = [NSString stringWithFormat:@"https://runsignup.com/rest/user?tmp_key=%@&tmp_secret=%@", key, secret];
    
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

- (void)logout{
    NSString *url = [NSString stringWithFormat:@"https://runsignup.com/rest/logout?tmp_key=%@&tmp_secret=%@", key, secret];
    
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
