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

enum{
    ClearResults = 4,
    ClearTimer,
    ClearChecker,
    ClearChute
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
    
    BOOL isOffline;
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

@property BOOL isOffline;

+ (id)sharedModel;

- (id)init;
- (int)renewCredentials;
- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(int))responseBlock;
- (void)logout;

- (void)attemptRetreiveRaceList:(void (^)(NSArray *))responseBlock;
- (void)attemptRetreiveResultSetList:(NSString *)raceID event:(NSString *)eventID response:(void (^)(NSMutableArray *))responseBlock;

- (void)createNewResultSet:(NSString *)name response:(void (^)(int))responseBlock;
- (void)deleteResultSet:(NSString *)resultSetID response:(void (^)(int))responseBlock;
- (void)deleteResults:(int)which response:(void (^)(int))responseBlock;

- (void)addFinishingTimes:(NSArray *)finishingTimes response:(void (^)(int))responseBlock;
- (void)addFinishingBibs:(NSArray *)finishingBibs response:(void (^)(int))responseBlock;

@end
