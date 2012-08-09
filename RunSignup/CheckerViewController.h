//
//  CheckerViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerLabel.h"
#import "NumpadView.h"
#import "EditBibViewController.h"

@interface CheckerViewController : UIViewController <EditBibDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UIButton *startButton;
    UIButton *recordButton;
    UIButton *closeNumpadButton;
    TimerLabel *timerLabel;
    
    UITableView *table;
    NSMutableArray *records;
    
    UITextField *bibField;
    
    NSString *raceName;
    NSString *raceID;
    NSString *eventName;
    NSString *eventID;
    NSString *fileToSave;
    
    BOOL started;
    BOOL editingBib;
    
    NumpadView *numpadView;
}

@property (nonatomic, retain) IBOutlet UIButton *startButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *closeNumpadButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) NSString *raceID;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *fileToSave;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) TimerLabel *timerLabel;
@property (nonatomic, retain) NumpadView *numpadView;

- (IBAction)record:(id)sender;
- (IBAction)start:(id)sender;

- (void)toggleEditing;
- (IBAction)showCloseNumpadButton:(id)sender;
- (IBAction)hideCloseNumpadButton:(id)sender;

- (void)saveToFile;

@end