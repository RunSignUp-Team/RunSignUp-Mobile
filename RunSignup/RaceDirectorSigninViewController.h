//
//  RaceDirectorSigninViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainMenuViewController;

@interface RaceDirectorSigninViewController : UIViewController <UITextFieldDelegate>{
    UIButton *signInButton;
    UITextField *emailField;
    UITextField *passField;
    
    UILabel *raceDirectorSignInLabel;
    UILabel *emailLabel;
    UILabel *passLabel;
    
    MainMenuViewController *delegate;
    
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) MainMenuViewController *delegate;

@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passField;
@property (nonatomic, retain) IBOutlet UILabel *raceDirectorSignInLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *passLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)signIn:(id)sender;
- (IBAction)cancel:(id)sender;

@end
