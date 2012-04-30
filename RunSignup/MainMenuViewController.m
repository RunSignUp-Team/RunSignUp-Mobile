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
#import "AppDelegate.h"

@implementation MainMenuViewController
@synthesize timerButton;
@synthesize signInButton;
@synthesize checkerButton;
@synthesize selectRaceButton;
@synthesize chuteButton;
@synthesize copyrightLabel;
@synthesize hintLabel;

@synthesize signOutButton;
@synthesize signedInAs;
@synthesize emailLabel;

@synthesize raceDirectorEmail;
@synthesize raceDirectorRaceID;

- (void)viewDidLoad{
    self.title = @"Menu";
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
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
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [copyrightLabel setText:[NSString stringWithFormat:@"© %@ RunSignup, LLC", [formatter stringFromDate: date]]];
    [formatter release];
        
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)timer:(id)sender{
    TimerViewController *timerViewController = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:timerViewController animated:YES];
    [timerViewController release];
}

- (IBAction)signIn:(id)sender{
    RaceDirectorSigninViewController *raceDirectorSignInViewController = [[RaceDirectorSigninViewController alloc] initWithNibName:@"RaceDirectorSigninViewController" bundle:nil];
    [raceDirectorSignInViewController setDelegate: self];
    [self presentModalViewController:raceDirectorSignInViewController animated:YES];
    [raceDirectorSignInViewController release];
}

- (IBAction)checker:(id)sender{
    CheckerViewController *checkerViewController = [[CheckerViewController alloc] initWithNibName:@"CheckerViewController" bundle:nil];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:checkerViewController animated:YES];
    [checkerViewController release];
}

- (IBAction)selectRace:(id)sender{
    if(raceDirectorEmail != nil){
        SelectRaceViewController *selectRaceViewController = [[SelectRaceViewController alloc] initWithNibName:@"SelectRaceViewController" bundle:nil];
        [selectRaceViewController setDelegate: self];
        [self presentModalViewController:selectRaceViewController animated:YES];
        [selectRaceViewController release];
    }
}

- (IBAction)chute:(id)sender{
    ChuteViewController *chuteViewController = [[ChuteViewController alloc] initWithNibName:@"ChuteViewController" bundle:nil];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:chuteViewController animated:YES];
    [chuteViewController release];
}

- (IBAction)showSettings:(id)sender{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self presentModalViewController:settingsViewController animated:YES];
}

- (IBAction)showInfo:(id)sender{
    
}

- (BOOL)didSignInEmail:(NSString *)email password:(NSString *)password{
    if([email isEqualToString:@"test"] && [password isEqualToString:@"test"]){
        raceDirectorEmail = @"emailaddress@emailvendor.com";
        [emailLabel setHidden: NO];
        [emailLabel setText:raceDirectorEmail];
        [signedInAs setHidden: NO];
        [signOutButton setHidden: NO];
        [hintLabel setText:@"Cool! Now select a race to time."];
        [timerButton setHidden: YES];
        [chuteButton setHidden: YES];
        [checkerButton setHidden: YES];
        [selectRaceButton setHidden: NO];
        [signInButton setHidden: YES];
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)didSelectRace:(NSString *)raceID{
    [timerButton setHidden: NO];
    [chuteButton setHidden: NO];
    [checkerButton setHidden: NO];
    [selectRaceButton setHidden: YES];
    [signInButton setHidden: YES];
    raceDirectorRaceID = raceID;
    [hintLabel setHidden: YES];
    return YES;
}

- (IBAction)didSignOut{
    [timerButton setHidden: YES];
    [chuteButton setHidden: YES];
    [checkerButton setHidden: YES];
    [selectRaceButton setHidden: YES];
    [signInButton setHidden: NO];
    [emailLabel setHidden: YES];
    [emailLabel setText:@""];
    [signedInAs setHidden: YES];
    [signOutButton setHidden: YES];
    raceDirectorEmail = @"";
    raceDirectorRaceID = @"";
    [hintLabel setText:@"Race Director? Sign in here."];
    [hintLabel setHidden: NO];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
