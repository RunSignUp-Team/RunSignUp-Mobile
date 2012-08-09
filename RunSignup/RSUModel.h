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
    
    NSString *currentResultSetID;
    NSString *currentRaceID;
    NSString *currentEventID;
    
    NSString *lastFinishingTimeID;
    NSString *lastBibNumber;
    
    NSTimer *renewTimer;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *currentResultSetID;
@property (nonatomic, retain) NSString *currentRaceID;
@property (nonatomic, retain) NSString *currentEventID;

@property (nonatomic, retain) NSString *lastFinishingTimeID;
@property (nonatomic, retain) NSString *lastBibNumber;

@property (nonatomic, retain) NSTimer *renewTimer;

+ (id)sharedModel;

- (id)init;
- (int)renewCredentials;
- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(int))responseBlock;
- (void)logout;
- (void)attemptRetreiveRaceList:(void (^)(NSArray *))responseBlock;

- (void)beginTimingNewRace:(NSString *)raceID event:(NSString *)eventID response:(void (^)(int))responseBlock;
- (void)createNewResultSet:(void (^)(int))responseBlock;

- (void)addFinishingTime:(NSString *)finishingTime response:(void (^)(int))responseBlock;

@end
