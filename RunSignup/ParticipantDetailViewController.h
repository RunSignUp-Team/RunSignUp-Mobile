//
//  ParticipantDetailViewController.h
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
#import "RoundedLoadingIndicator.h"

@class ParticipantViewController;

@interface ParticipantDetailViewController : UIViewController <UITextFieldDelegate>{
    UITextField *firstNameField;
    UITextField *lastNameField;
    UITextField *bibField;
    UITextField *ageField;
    UITextField *cityField;
    UITextField *stateField;
    
    BOOL creating;
    
    RoundedLoadingIndicator *rli;
    
    UISegmentedControl *genderControl;
    
    ParticipantViewController *delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *firstNameField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameField;
@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) IBOutlet UITextField *ageField;
@property (nonatomic, retain) IBOutlet UITextField *cityField;
@property (nonatomic, retain) IBOutlet UITextField *stateField;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderControl;

@property (nonatomic, retain) ParticipantViewController *delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCreating:(BOOL)isCreating;

- (IBAction)submit:(id)sender;

@end
