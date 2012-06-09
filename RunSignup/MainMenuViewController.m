//
//  MainMenuViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "TimerViewController.h"
#import "ChuteViewController.h"
#import "CheckerViewController.h"
#import "SettingsViewController.h"
#import "RaceDirectorSigninViewController.h"
#import "SelectRaceViewController.h"
#import "ArchiveViewController.h"
#import "AppDelegate.h"
#import "RSUModel.h"

@implementation MainMenuViewController
@synthesize timerButton;
@synthesize signInButton;
@synthesize checkerButton;
@synthesize chuteButton;
@synthesize copyrightLabel;
@synthesize hintLabel;

@synthesize signOutButton;
@synthesize signedInAs;
@synthesize emailLabel;

@synthesize selectRaceButton;
@synthesize timingFor;
@synthesize raceLabel;

@synthesize raceDirectorEmail;
@synthesize raceDirectorRaceID;

- (void)viewDidLoad{
    self.title = @"Menu";
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    [timerButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [timerButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [checkerButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [checkerButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [selectRaceButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [selectRaceButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [chuteButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [chuteButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signOutButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signOutButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Date formatter set up to allow future-proof Copyright tag on bottom of main menu.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [copyrightLabel setText:[NSString stringWithFormat:@"© %@ RunSignup, LLC", [formatter stringFromDate: date]]];
    [formatter release];
        
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

// Push timer view onto UINavigationController's view stack
- (IBAction)timer:(id)sender{
    TimerViewController *timerViewController = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
    [timerViewController setRaceID:raceDirectorRaceID];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:timerViewController animated:YES];
    [timerViewController release];
}

// Push sign in view into modal view of MainMenuViewController
- (IBAction)signIn:(id)sender{
    RaceDirectorSigninViewController *raceDirectorSignInViewController = [[RaceDirectorSigninViewController alloc] initWithNibName:@"RaceDirectorSigninViewController" bundle:nil];
    [raceDirectorSignInViewController setDelegate: self];
    [self presentModalViewController:raceDirectorSignInViewController animated:YES];
    [raceDirectorSignInViewController release];
}

// // Push checker view onto UINavigationController's view stack
- (IBAction)checker:(id)sender{
    CheckerViewController *checkerViewController = [[CheckerViewController alloc] initWithNibName:@"CheckerViewController" bundle:nil];
    [checkerViewController setRaceID:raceDirectorRaceID];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:checkerViewController animated:YES];
    [checkerViewController release];
}

// Push select race view into modal view of MainMenuViewController
- (IBAction)selectRace:(id)sender{
    if(raceDirectorEmail != nil){
        SelectRaceViewController *selectRaceViewController = [[SelectRaceViewController alloc] initWithNibName:@"SelectRaceViewController" bundle:nil];
        [selectRaceViewController setDelegate: self];
        [self presentModalViewController:selectRaceViewController animated:YES];
        [selectRaceViewController release];
    }
}

// Push chute view onto UINavigationController's view stack
- (IBAction)chute:(id)sender{
    ChuteViewController *chuteViewController = [[ChuteViewController alloc] initWithNibName:@"ChuteViewController" bundle:nil];
    [chuteViewController setRaceID:raceDirectorRaceID];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:chuteViewController animated:YES];
    [chuteViewController release];
}

// Push settings view into modal view of MainMenuViewController
- (IBAction)showSettings:(id)sender{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self presentModalViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

- (IBAction)showInfo:(id)sender{
    ArchiveViewController *archiveViewController = [[ArchiveViewController alloc] initWithNibName:@"ArchiveViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:archiveViewController];
    [self presentModalViewController:navigationController animated:YES];
    [navigationController release];
    [archiveViewController release];
}

// Delegate style method for telling MainMenuViewController who to sign in and return BOOL if it was successful
- (int)didSignInEmail:(NSString *)email password:(NSString *)password{
    RSUModel *model = [RSUModel sharedModel];
    int attempt = [model attemptLoginWithEmail:email pass:password];
    
    if(attempt == Success){
        self.raceDirectorEmail = email;
        [emailLabel setHidden: NO];
        [emailLabel setText:raceDirectorEmail];
        [signedInAs setHidden: NO];
        [signOutButton setHidden: NO];
        [signOutButton setFrame: CGRectMake(22, 376, 278, 46)];
        [raceLabel setHidden: NO];
        [raceLabel setText:@"No Race Selected"];
        [timingFor setHidden: NO];
        [hintLabel setText:@"Cool! Now select a race to time for."];
        [timerButton setHidden: YES];
        [chuteButton setHidden: YES];
        [checkerButton setHidden: YES];
        [selectRaceButton setHidden: NO];
        [selectRaceButton setFrame: CGRectMake(50, 128, 220, 46)];
        [signInButton setHidden: YES];
        return Success;
    }else{
        return attempt;
    }
}

// Delegate style method for telling MainMenuViewController which race to time for and return if successful
- (BOOL)didSelectRace:(NSString *)raceID{
    self.raceDirectorRaceID = raceID;
    [timingFor setHidden: NO];
    [raceLabel setText: raceDirectorRaceID];
    [timerButton setHidden: NO];
    [chuteButton setHidden: NO];
    [checkerButton setHidden: NO];
    [selectRaceButton setHidden: NO];
    // Animate selectRaceButton from top of view to bottom right
    if(selectRaceButton.frame.origin.x == 50){ //50,128,220,46 to 166,376,138,46
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.75f];
        [signOutButton setFrame: CGRectMake(22, 376, 138, 46)];
        [selectRaceButton setFrame: CGRectMake(166, 376, 138, 46)];
        [UIView commitAnimations];
    }
    [signInButton setHidden: YES];
    [hintLabel setHidden: YES];
    return YES;
}

// Delegate style method for telling MainMenuViewController to sign out and update view
- (IBAction)didSignOut{
    [[RSUModel sharedModel] logout];
    [timerButton setHidden: YES];
    [chuteButton setHidden: YES];
    [checkerButton setHidden: YES];
    [signInButton setHidden: NO];
    [emailLabel setHidden: YES];
    [emailLabel setText:@""];
    [signedInAs setHidden: YES];
    [timingFor setHidden: YES];
    [raceLabel setHidden: YES];
    [signOutButton setHidden: YES];
    [selectRaceButton setHidden: YES];
    [selectRaceButton setFrame:CGRectMake(50, 128, 220, 46)];
    raceDirectorEmail = @"";
    raceDirectorRaceID = @"";
    [hintLabel setText:@"Race Director? Sign in here."];
    [hintLabel setHidden: NO];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
