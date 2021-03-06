//
//  RaceDirectorSigninViewController.m
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

#import "RaceDirectorSigninViewController.h"
#import "MainMenuViewController.h"
#import "RSUModel.h"
#import "KeychainItemWrapper.h"

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
        keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"RSULogin" accessGroup:nil];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:140];

        [self.view addSubview: rli];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        for(UIView *subView in [self.view subviews]){
            CGRect frame = [subView frame];
            frame.origin.y += 20;
            [subView setFrame: frame];
        }
    }
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Set email field to have keyboard open on load
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberMe"] != nil){
        [emailField setText: [keychain objectForKey: kSecAttrAccount]];
        [passField setText: [keychain objectForKey: kSecValueData]];
        [rememberSwitch setOn:YES];
        [passField becomeFirstResponder];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"AutoSignIn"]){
            [self performSelector:@selector(signIn:) withObject:nil afterDelay:0.1f];
        }
    }else{
        [emailField becomeFirstResponder];
    }
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
            void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                if(didSucceed == RSUSuccess){
                    [rli fadeOut];
                    
                    if([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberMe"] == nil){
                        if([rememberSwitch isOn]){
                            [keychain setObject:[emailField text] forKey:kSecAttrAccount];
                            [keychain setObject:[passField text] forKey:kSecValueData];
                            [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"RememberMe"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }else{
                        if(![rememberSwitch isOn]){
                            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"RememberMe"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                    }
                    
                    [self dismissModalViewControllerAnimated:YES];
                }else if(didSucceed == RSUInvalidEmail){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No user exists with that email address. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }else if(didSucceed == RSUInvalidPassword){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The password is invalid. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [rli fadeOut];
                }
            };
            
            [delegate didSignInEmail:[emailField text] password:[passField text] response:response];
        }
    }
    
}

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSUInteger)supportedInterfaceOrientations{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else
        return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
