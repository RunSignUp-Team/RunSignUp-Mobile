//
//  RaceDirectorSigninViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RaceDirectorSigninViewController.h"
#import "MainMenuViewController.h"
#import "RSUModel.h"

@implementation RaceDirectorSigninViewController
@synthesize delegate;
@synthesize signInButton;
@synthesize emailField;
@synthesize passField;
@synthesize raceDirectorSignInLabel;
@synthesize emailLabel;
@synthesize passLabel;
@synthesize rememberSwitch;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];

        [self.view addSubview: rli];
    }
    return self;
}

- (void)viewDidLoad{
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Set email field to have keyboard open on load
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberEmail"] != nil){
        [emailField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"RememberEmail"]];
        [rememberSwitch setOn:YES];
        [passField becomeFirstResponder];
    }else{
        [emailField becomeFirstResponder];
    }
    
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
    if([delegate respondsToSelector:@selector(didSignInEmail:password:response:)]){
        if([[emailField text] length] > 0 && [[passField text] length] > 0){
            [rli fadeIn];
            void (^success)(int) = ^(int response){
                if(response == Success){
                    [rli fadeOut];
                    
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberEmail"] == nil){
                        if([rememberSwitch isOn]){
                            [[NSUserDefaults standardUserDefaults] setObject:[emailField text] forKey:@"RememberEmail"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }else{
                        if(![rememberSwitch isOn]){
                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RememberEmail"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }
                    
                    [self dismissModalViewControllerAnimated:YES];
                }else if(response == InvalidEmail){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No user exists with that email address. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }else if(response == InvalidPassword){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The password is invalid. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }
            };
            
            [delegate didSignInEmail:[emailField text] password:[passField text] response:success];
        }
    }
    
}

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
