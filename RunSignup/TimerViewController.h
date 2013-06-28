//
//  TimerViewController.h
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

#import <UIKit/UIKit.h>
#import "TimerLabel.h"
#import "NumpadView.h"
#import "RSUModel.h"

@interface TimerViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    UIButton *startButton;
    UIButton *recordButton;
    TimerLabel *timerLabel;
    
    UITableView *table;
    NSMutableArray *records;
    
    UIAlertView *downloadResultsAlert;
    UIAlertView *deleteResultsAlert;
    
    RSUDifferences currentDifferences;
    
    BOOL started;
    NSString *raceID;
    NSString *raceName;
    NSString *eventID;
    NSString *eventName;
    NSString *fileToSave;
}

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) TimerLabel *timerLabel;
@property (nonatomic, retain) NSString *raceID;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *fileToSave;

- (IBAction)record:(id)sender;
- (IBAction)start:(id)sender;

- (void)saveStartDate;

- (void)toggleEditing;
- (void)updateRecordNumbersAfterDeletion;

- (void)saveToFile;
- (void)findDestinationFile;

- (void)showDownloadResultsAlert;
- (void)reuploadResults;
- (void)downloadResults;

@end
