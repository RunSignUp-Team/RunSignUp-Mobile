//
//  TimerViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

- (void)toggleEditing;
- (void)updateRecordNumbersAfterDeletion;

- (void)saveToFile;
- (void)reuploadResults;

@end
