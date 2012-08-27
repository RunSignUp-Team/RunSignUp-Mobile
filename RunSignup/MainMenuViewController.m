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
#import "OfflineRaceViewController.h"
#import "ParticipantViewController.h"
#import "AppDelegate.h"
#import "RSUModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainMenuViewController
@synthesize timerButton;
@synthesize signInButton;
@synthesize offlineButton;
@synthesize checkerButton;
@synthesize chuteButton;
@synthesize otherButton;

@synthesize copyrightLabel;
@synthesize hintLabel;
@synthesize hintLabel2;

@synthesize signOutButton;
@synthesize archiveButton;
@synthesize settingsButton;
@synthesize signedInAs;
@synthesize emailLabel;

@synthesize selectRaceButton;
@synthesize timingFor;
@synthesize raceLabel;

@synthesize raceDirectorEmail;
@synthesize raceDirectorRaceName;
@synthesize raceDirectorRaceID;
@synthesize raceDirectorEventName;
@synthesize raceDirectorEventID;

- (void)viewDidLoad{
    self.title = @"Menu";
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    [timerButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [timerButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signInButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signInButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [offlineButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [offlineButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [checkerButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [checkerButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [selectRaceButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [selectRaceButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [chuteButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [chuteButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [otherButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [otherButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [signOutButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [signOutButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [archiveButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [archiveButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [settingsButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [settingsButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    // Date formatter set up to allow future-proof Copyright tag on bottom of main menu.
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    [copyrightLabel setText:[NSString stringWithFormat:@"© %@ RunSignup, LLC", [formatter stringFromDate: date]]];
    [formatter release];
    
    raceLabel.layer.borderColor = [UIColor blackColor].CGColor;
    raceLabel.layer.borderWidth = 1.0f;
    emailLabel.layer.borderColor = [UIColor blackColor].CGColor;
    emailLabel.layer.borderWidth = 1.0f;
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 400);
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

// Push timer view onto UINavigationController's view stack
- (IBAction)timer:(id)sender{
    TimerViewController *timerViewController = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
    [timerViewController setRaceID:raceDirectorRaceID];
    [timerViewController setRaceName:raceDirectorRaceName];
    [timerViewController setEventID:raceDirectorEventID];
    [timerViewController setEventName:raceDirectorEventName];
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

- (IBAction)offline:(id)sender{
    OfflineRaceViewController *offlineRaceViewController = [[OfflineRaceViewController alloc] initWithNibName:@"OfflineRaceViewController" bundle:nil];
    [offlineRaceViewController setDelegate: self];
    [self presentModalViewController:offlineRaceViewController animated:YES];
    [offlineRaceViewController release];
}

// // Push checker view onto UINavigationController's view stack
- (IBAction)checker:(id)sender{
    CheckerViewController *checkerViewController = [[CheckerViewController alloc] initWithNibName:@"CheckerViewController" bundle:nil];
    [checkerViewController setRaceID:raceDirectorRaceID];
    [checkerViewController setRaceName:raceDirectorRaceName];
    [checkerViewController setEventID:raceDirectorEventID];
    [checkerViewController setEventName:raceDirectorEventName];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:checkerViewController animated:YES];
    [checkerViewController release];
}

// Push select race view into modal view of MainMenuViewController
- (IBAction)selectRace:(id)sender{
    if(raceDirectorEmail != nil){
        SelectRaceViewController *selectRaceViewController = [[SelectRaceViewController alloc] initWithNibName:@"SelectRaceViewController" bundle:nil];
        [selectRaceViewController setDelegate: self];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: selectRaceViewController];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            [self presentModalViewController:navController animated:YES];
        else{
            UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:navController];
            [selectRaceViewController setPopoverController: popoverController];
            [popoverController presentPopoverFromRect:[selectRaceButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
        [selectRaceViewController release];
    }
}

// Push chute view onto UINavigationController's view stack
- (IBAction)chute:(id)sender{
    ChuteViewController *chuteViewController = [[ChuteViewController alloc] initWithNibName:@"ChuteViewController" bundle:nil];
    [chuteViewController setRaceID:raceDirectorRaceID];
    [chuteViewController setRaceName:raceDirectorRaceName];
    [chuteViewController setEventID:raceDirectorEventID];
    [chuteViewController setEventName:raceDirectorEventName];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:chuteViewController animated:YES];
    [chuteViewController release];
}

- (IBAction)other:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Other" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View Results Online", @"Manage Participants", @"Delete All Data and Results", nil];
    [actionSheet showInView: self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"https://runsignup.com/beta/nofrills"]];
    }else if(buttonIndex == 1){
        ParticipantViewController *participantViewController = [[ParticipantViewController alloc] initWithNibName:@"ParticipantViewController" bundle:nil];
        [participantViewController setRaceName: @"Cooper River Annual Race"];
        [participantViewController setEventName: @"10K Run"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: participantViewController];
        [self presentModalViewController:navController animated:YES];
        
        [participantViewController release];
    }else if(buttonIndex == 2){
        void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
            if(didSucceed == RSUNoConnection){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        };
        
        [[RSUModel sharedModel] deleteResults:RSUClearTimer response:response];
        //[[RSUModel sharedModel] deleteResults:RSUClearChecker response:response];
        [[RSUModel sharedModel] deleteResults:RSUClearChute response:response];
        [[RSUModel sharedModel] deleteResults:RSUClearResults response:response];
        
        /*[[NSUserDefaults standardUserDefaults] removeObjectForKey: @"TimerStartDate"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"CurrentTimerFile"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"CurrentChuteFile"];
        [[NSUserDefaults standardUserDefaults] synchronize];*/
    }
}

// Push settings view into modal view of MainMenuViewController
- (IBAction)showSettings:(id)sender{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentModalViewController:settingsViewController animated:YES];
    }else{
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController: settingsViewController];
        [popoverController presentPopoverFromRect:[settingsButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    [settingsViewController release];
    
}

- (IBAction)showArchive:(id)sender{
    ArchiveViewController *archiveViewController = [[ArchiveViewController alloc] initWithNibName:@"ArchiveViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:archiveViewController];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentModalViewController:navigationController animated:YES];
    }else{
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController: navigationController];
        [popoverController presentPopoverFromRect:[archiveButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    [navigationController release];
    [archiveViewController release];
}

// Delegate style method for telling MainMenuViewController who to sign in and return BOOL if it was RSUSuccessful
- (void)didSignInEmail:(NSString *)email password:(NSString *)password response:(void (^)(RSUConnectionResponse))responseBlock{
    RSUModel *model = [RSUModel sharedModel];
    [model setIsOffline: NO];
    
    void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
        if(didSucceed == RSUSuccess){
            self.raceDirectorEmail = email;
            [emailLabel setHidden: NO];
            [emailLabel setText:raceDirectorEmail];
            [signedInAs setHidden: NO];
            [signOutButton setHidden: NO];
            [signOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                [signOutButton setFrame: CGRectMake(22, 360, 278, 46)];
                [selectRaceButton setFrame: CGRectMake(50, 107, 220, 46)];
            }else{
                [signOutButton setFrame: CGRectMake(374, 644, 278, 46)];
                [selectRaceButton setFrame: CGRectMake(402, 230, 220, 46)];
            }
            [raceLabel setHidden: NO];
            [raceLabel setText:@"No Event Selected"];
            [timingFor setHidden: NO];
            [hintLabel setText:@"To proceed, choose today's event."];
            [hintLabel2 setHidden:YES];
            [timerButton setHidden: YES];
            [chuteButton setHidden: YES];
            [otherButton setHidden: YES];
            [checkerButton setHidden: YES];
            [selectRaceButton setHidden: NO];
            [signInButton setHidden: YES];
            [offlineButton setHidden: YES];
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(didSucceed);}); 
    };

    [model attemptLoginWithEmail:email pass:password response:response];
}

- (void)didCreateOfflineRace:(NSString *)name{
    self.raceDirectorEmail = @"Offline Race";
    self.raceDirectorRaceName = name;
    self.raceDirectorRaceID = @"0000";
    self.raceDirectorEventName = @"No Event";
    self.raceDirectorEventID = @"0000";
    
    [[RSUModel sharedModel] setIsOffline: YES];
    
    [emailLabel setHidden: NO];
    [emailLabel setText:raceDirectorEmail];
    [signedInAs setHidden: NO];
    [raceLabel setHidden: NO];
    [raceLabel setText:name];
    [timingFor setHidden: NO];
    [hintLabel setHidden: YES];
    [hintLabel2 setHidden: YES];
    [timerButton setHidden: NO];
    [chuteButton setHidden: NO];
    [otherButton setHidden: NO];
    //[chuteButton setFrame: CGRectMake([chuteButton frame].origin.x, [chuteButton frame].origin.y, 284, [chuteButton frame].size.height)];
    [checkerButton setHidden: NO];
    [selectRaceButton setHidden: YES];
    [signOutButton setTitle:@"Back to Start Menu" forState:UIControlStateNormal];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [signOutButton setFrame: CGRectMake(22, 360, 278, 46)];
    [signOutButton setHidden: NO];
    [signInButton setHidden: YES];
    [offlineButton setHidden: YES];
}

// Delegate style method for telling MainMenuViewController which race to time for and return if RSUSuccessful
- (void)didSelectRace:(NSString *)raceName withID:(NSString *)raceID withEventName:(NSString *)eventName withEventID:(NSString *)eventID{
    self.raceDirectorRaceName = raceName;
    self.raceDirectorRaceID = raceID;
    self.raceDirectorEventName = eventName;
    self.raceDirectorEventID = eventID;
    
    [timingFor setHidden: NO];
    [raceLabel setText: [NSString stringWithFormat:@"%@ - %@", raceDirectorRaceName, raceDirectorEventName]];
    [timerButton setHidden: NO];
    [chuteButton setHidden: NO];
    [chuteButton setFrame: CGRectMake([chuteButton frame].origin.x, [chuteButton frame].origin.y, 134, [chuteButton frame].size.height)];
    [otherButton setHidden: NO];
    [checkerButton setHidden: NO];
    [selectRaceButton setHidden: NO];
    [signOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    // Animate selectRaceButton from top of view to bottom right
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if(selectRaceButton.frame.origin.x == 50){ //50,128,220,46 to 166,376,138,46
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration: 0.75f];
            [signOutButton setFrame: CGRectMake(22, 360, 138, 46)];
            [selectRaceButton setFrame: CGRectMake(166, 360, 138, 46)];
            [UIView commitAnimations];
        }
    }else{
        if(selectRaceButton.frame.origin.y == 230){ //50,128,220,46 to 166,376,138,46
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration: 0.75f];
            [selectRaceButton setFrame: CGRectMake(402, 500, 220, 46)];
            [UIView commitAnimations];
        }
    }
    [signInButton setHidden: YES];
    [offlineButton setHidden: YES];
    [hintLabel setHidden: YES];
    [hintLabel2 setHidden: YES];
}

// Delegate style method for telling MainMenuViewController to sign out and update view
- (IBAction)didSignOut{
    [[RSUModel sharedModel] logout];
    [timerButton setHidden: YES];
    [chuteButton setHidden: YES];
    [otherButton setHidden: YES];
    [checkerButton setHidden: YES];
    [signInButton setHidden: NO];
    [offlineButton setHidden: NO];
    [emailLabel setHidden: YES];
    [emailLabel setText:@""];
    [signedInAs setHidden: YES];
    [timingFor setHidden: YES];
    [raceLabel setHidden: YES];
    [signOutButton setHidden: YES];
    [signOutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    [selectRaceButton setHidden: YES];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [selectRaceButton setFrame:CGRectMake(50, 107, 220, 46)];
    else
        [selectRaceButton setFrame:CGRectMake(402, 230, 220, 46)];
    raceDirectorEmail = @"";
    raceDirectorRaceID = @"";
    raceDirectorEventName = @"";
    raceDirectorEventID = @"";
    [hintLabel setText:@"Race Director? Sign in here."];
    [hintLabel setHidden: NO];
    [hintLabel2 setHidden: NO];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
