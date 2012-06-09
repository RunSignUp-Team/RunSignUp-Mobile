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

- (id)init{
    self = [super init];
    if(self){

    }
    return self;
}

- (NSArray *)attemptRetreiveRaceList{
    if([self renewCredentials] == Success){
        NSString *url = [NSString stringWithFormat:@"https://runsignup.com/rest/races?tmp_key=%@&tmp_secret=%@", key, secret];
        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        
        NSError *error;
        NSURLResponse *response;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSMutableArray *raceList = [[NSMutableArray alloc] init];
        
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if([[rootXML tag] isEqualToString:@"races"]){
            NSArray *races = [rootXML children:@"race"];
            if(races != nil){
                for(RXMLElement *race in races){
                    RXMLElement *raceName = [race child:@"name"];
                    RXMLElement *raceID = [race child:@"race_id"];
                    if(raceName != nil && raceID != nil){
                        NSString *curtailedName = [raceName text];
                        if([curtailedName length] > 32)
                            curtailedName = [curtailedName substringToIndex: 31];
                        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:curtailedName,@"Name",[raceID text],@"RaceID",nil];
                        [raceList addObject: dict];
                    }
                }
            }
        }
        if([raceList count] == 0)
            return nil;
        return raceList;
    }else{
        return nil;
    }
}

- (int)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa{
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
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(!urlData){
        NSLog(@"URLData is nil");
        return NoConnection;
    }
    
    RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
    
    if([[rootXML tag] isEqualToString:@"login"]){
        RXMLElement *tmp_key = [rootXML child:@"tmp_key"];
        RXMLElement *tmp_secret = [rootXML child:@"tmp_secret"];
        
        if(tmp_key != nil && tmp_secret != nil){
            self.key = [tmp_key text];
            self.secret = [tmp_secret text];
            return Success;
        }else{
            return NoConnection;
        }
    }else if([[rootXML tag] isEqualToString:@"error"]){
        RXMLElement *error_code = [rootXML child:@"error_code"];

        if([error_code textAsInt] == 101){
            return InvalidEmail;
        }else if([error_code textAsInt] == 102){
            return InvalidPassword;
        }
    }
    return NoConnection;
}

- (int)renewCredentials{
    NSString *url = [NSString stringWithFormat:@"https://runsignup.com/rest/user?tmp_key=%@&tmp_secret=%@", key, secret];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(urlData){
        RXMLElement *rootXML = [[RXMLElement alloc] initFromXMLData:urlData];
        if(![[rootXML tag] isEqualToString:@"user"]){
            int attempt = [self attemptLoginWithEmail:email pass:password];
            return attempt;
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
}

+ (id)sharedModel{
    @synchronized(self){
        if(model == nil)
            model = [[self alloc] init];
    }
    return model;
}

@end
