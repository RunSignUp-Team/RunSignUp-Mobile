//
//  RSUModel.h
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

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"

#define RSUDOMAIN "https://test.runsignup.com"

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
    RSUDifferencesNoConnection = 8,
    RSUDifferencesNone,
    RSUDifferencesServerEmpty,
    RSUDifferencesClientEmpty,
    RSUDifferencesBothDifferent
} RSUDifferences;

@interface RSUModel : NSObject <CHCSVParserDelegate>{
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
    
    NSMutableArray *downloadedRecords;
    
    CHCSVParser *csvParser;
    NSMutableDictionary *currentEntry;
    NSMutableArray *resultsArray;
    NSMutableArray *keyArray;
    
    BOOL readingKeys;
    
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

@property (nonatomic, retain) NSMutableArray *downloadedRecords;

@property BOOL isOffline;

+ (id)sharedModel;

- (id)init;
- (int)renewCredentials;
- (void)attemptLoginWithEmail:(NSString *)em pass:(NSString *)pa response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)logout;

- (void)attemptRetrieveRaceList:(void (^)(NSArray *))responseBlock;
- (void)attemptRetrieveResultSetList:(NSString *)raceID event:(NSString *)eventID response:(void (^)(NSMutableArray *))responseBlock;
- (void)attemptRetrieveParticipants:(void (^)(NSMutableArray *))responseBlock;
- (void)attemptRetrieveResults:(void (^)(NSMutableArray *))responseBlock;

- (NSMutableArray *)parseCSV:(NSString *)csv;

- (void)createNewResultSet:(NSString *)name response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)deleteResultSet:(NSString *)resultSetID response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)deleteResults:(RSUClearCategory)category response:(void (^)(RSUConnectionResponse))responseBlock;

- (void)detectDifferencesBetweenLocalAndOnline:(NSArray *)records type:(int)type response:(void (^)(RSUDifferences))responseBlock;

- (void)recordStartDateOfTimer:(NSString *)startDate response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)retrieveStartDateOfTimer:(void (^)(RSUConnectionResponse, NSString *))responseBlock;

- (void)addFinishingTimes:(NSArray *)finishingTimes response:(void (^)(RSUConnectionResponse))responseBlock;
- (void)addFinishingBibs:(NSArray *)finishingBibs response:(void (^)(RSUConnectionResponse))responseBlock;

- (void)editParticipants:(NSArray *)participants response:(void (^)(RSUConnectionResponse, NSString *))responseBlock;

@end
