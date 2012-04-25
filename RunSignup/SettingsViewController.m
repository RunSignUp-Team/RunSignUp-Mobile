//
//  SettingsViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize bigRecordSwitch;
@synthesize timerHoursSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (IBAction)bigRecordChange:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:bigRecordSwitch.on forKey:@"BigRecordButton"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)timerHoursChange:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:timerHoursSwitch.on forKey:@"TimerHours"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad{
    [bigRecordSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"]];
    [timerHoursSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"TimerHours"]]; 
    [super viewDidLoad];
}

- (IBAction)done:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
