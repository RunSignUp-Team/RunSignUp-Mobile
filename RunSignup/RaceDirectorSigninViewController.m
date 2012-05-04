//
//  RaceDirectorSigninViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceDirectorSigninViewController.h"
#import "MainMenuViewController.h"

@implementation RaceDirectorSigninViewController
@synthesize delegate;
@synthesize signInButton;
@synthesize emailField;
@synthesize passField;
@synthesize raceDirectorSignInLabel;
@synthesize emailLabel;
@synthesize passLabel;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Set email field to have keyboard open on load
    [emailField becomeFirstResponder];
    
    [super viewDidLoad];
}

// When return is pressed on email -> go to password field. When return is pressed on password -> sign in.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == emailField){
        [emailField resignFirstResponder];
        [passField becomeFirstResponder];
        return NO;
    }else{
        [self signIn: nil];
        return NO;
    }
}

// Sign in, query if email and password are valid
- (IBAction)signIn:(id)sender{
    if([delegate respondsToSelector:@selector(didSignInEmail:password:)]){
        [activityIndicator startAnimating];
        if([delegate didSignInEmail:[emailField text] password:[passField text]]){
            [activityIndicator stopAnimating];
            [self dismissModalViewControllerAnimated: YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The email or password is incorrect." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [activityIndicator stopAnimating];
        }
    }
    
}

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
