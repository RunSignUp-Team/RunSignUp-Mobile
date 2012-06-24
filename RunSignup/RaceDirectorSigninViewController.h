//
//  RaceDirectorSigninViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@class MainMenuViewController;

@interface RaceDirectorSigninViewController : UIViewController <UITextFieldDelegate>{
    UIButton *signInButton;
    UITextField *emailField;
    UITextField *passField;
    
    UILabel *raceDirectorSignInLabel;
    UILabel *emailLabel;
    UILabel *passLabel;
    
    UISwitch *rememberSwitch;
    
    MainMenuViewController *delegate;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) MainMenuViewController *delegate;

@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passField;
@property (nonatomic, retain) IBOutlet UILabel *raceDirectorSignInLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *passLabel;
@property (nonatomic, retain) IBOutlet UISwitch *rememberSwitch;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (IBAction)signIn:(id)sender;
- (IBAction)cancel:(id)sender;

@end
