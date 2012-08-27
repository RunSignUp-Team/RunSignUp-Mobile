//
//  ParticipantDetailViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParticipantViewController;

@interface ParticipantDetailViewController : UIViewController <UITextFieldDelegate>{
    UITextField *firstNameField;
    UITextField *lastNameField;
    UITextField *bibField;
    UITextField *ageField;
    UITextField *cityField;
    UITextField *stateField;
    
    UISegmentedControl *genderControl;
    
    ParticipantViewController *delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *firstNameField;
@property (nonatomic, retain) IBOutlet UITextField *lastNameField;
@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) IBOutlet UITextField *ageField;
@property (nonatomic, retain) IBOutlet UITextField *cityField;
@property (nonatomic, retain) IBOutlet UITextField *stateField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderControl;

@property (nonatomic, retain) ParticipantViewController *delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCreating:(BOOL)isCreating;

- (IBAction)submit:(id)sender;

@end
