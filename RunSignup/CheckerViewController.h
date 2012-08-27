//
//  CheckerViewController.h
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