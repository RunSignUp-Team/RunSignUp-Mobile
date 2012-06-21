//
//  RSUModel.h
//  RunSignup
//
//  Created by Billy Connolly on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    NoConnection = 0,
    InvalidEmail,
    InvalidPassword,
    Success
};

@interface RSUModel : NSObject{
    NSString *key;
    NSString *secret;
    
    NSString *email;
    NSString *password;
    
    NSTimer *renewTimer;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSTimer *renewTimer;

+ (id)sharedModel;

- (id)init;
- (int)renewCredentials;
- (int)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa;
- (void)logout;
- (NSArray *)attemptRetreiveRaceList;

@end
