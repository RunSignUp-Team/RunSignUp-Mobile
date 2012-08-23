//
//  RSUModel.h
//  RunSignup
//
//  Created by Billy Connolly on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    RSUNoConnection = 0,
    RSUInvalidEmail,
    RSUInvalidPassword,
    RSUSuccess
} RSUConnectionResponse;

typedef enum{
    RSUClearResults = 4,
    RSUClearTimer,
    RSUClearChecker,
    RSUClearChute
} RSUClearCategory;

typedef enum{
    RSUNoDifferencesExist = 8,
    RSUDifferencesExist
} RSUDifferences;

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
- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)logout;

- (void)attemptRetreiveRaceList:(void (^)(NSArray *))responseBlock;
- (void)attemptRetreiveResultSetList:(NSString *)raceID event:(NSString *)eventID response:(void (^)(NSMutableArray *))responseBlock;

- (void)createNewResultSet:(NSString *)name response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)deleteResultSet:(NSString *)resultSetID response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)deleteResults:(RSUClearCategory)category response:(void (^)(RSUConnectionResponse))responseBlock;

- (void)detectDifferencesBetweenLocalAndOnline:(NSArray *)records type:(int)type response:(void (^)(RSUDifferences))responseBlock;

- (void)addFinishingTimes:(NSArray *)finishingTimes response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)addFinishingBibs:(NSArray *)finishingBibs response:(void (^)(RSUConnectionResponse))responseBlock;

@end
