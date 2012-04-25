//
//  TimerViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerLabel.h"

@interface TimerViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    UIButton *startButton;
    UIButton *recordButton;
    TimerLabel *timerLabel;
    
    UITableView *table;
    NSMutableArray *records;
    
    BOOL started;
}

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) TimerLabel *timerLabel;

- (IBAction)record:(id)sender;
- (IBAction)start:(id)sender;

- (void)toggleEditing;
- (void)updateRecordNumbersAfterDeletion;

@end
