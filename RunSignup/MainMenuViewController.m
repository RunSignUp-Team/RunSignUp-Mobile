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
#import "AppDelegate.h"

@implementation MainMenuViewController
@synthesize timerButton;
@synthesize checkerButton;
@synthesize chuteButton;
@synthesize copyrightLabel;

- (void)viewDidLoad{
    self.title = @"Menu";
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [timerButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [timerButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    [checkerButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [checkerButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    [chuteButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [chuteButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
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

- (IBAction)checker:(id)sender{
    CheckerViewController *checkerViewController = [[CheckerViewController alloc] initWithNibName:@"CheckerViewController" bundle:nil];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:checkerViewController animated:YES];
    [checkerViewController release];
}

- (IBAction)chute:(id)sender{
    ChuteViewController *chuteViewController = [[ChuteViewController alloc] initWithNibName:@"ChuteViewController" bundle:nil];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [[del navController] pushViewController:chuteViewController animated:YES];
    [chuteViewController release];
}

- (IBAction)showInfo:(id)sender{
    
}

- (IBAction)showSettings:(id)sender{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [settingsViewController setModalTransitionStyle: UIModalTransitionStylePartialCurl];
    [self presentModalViewController:settingsViewController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
