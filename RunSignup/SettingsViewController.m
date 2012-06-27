//
//  SettingsViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize settings;
@synthesize bigRecordSwitch;
@synthesize timerHoursSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Settings";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell.textLabel setText: [[NSArray arrayWithObjects:@"Big Record Button:", @"Timer Shows Hours:", nil] objectAtIndex:indexPath.row]];
    
    switch(indexPath.row){
        case 0:
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                [bigRecordSwitch setFrame: CGRectMake(220, 9, 0, 0)];
            else
                [bigRecordSwitch setFrame: CGRectMake(220, 9, 0, 0)];
            [bigRecordSwitch setFrame: CGRectMake(220, 9, 0, 0)];
            [cell addSubview: bigRecordSwitch];
            break;
        case 1:
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                [timerHoursSwitch setFrame: CGRectMake(220, 9, 0, 0)];
            else
                [timerHoursSwitch setFrame: CGRectMake(892, 9, 0, 0)];
            [timerHoursSwitch setFrame: CGRectMake(220, 9, 0, 0)];
            [cell addSubview: timerHoursSwitch];
            break;
        default:
            break;
    }
    
    return cell;
}

// Change big record button setting
- (IBAction)bigRecordChange:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:bigRecordSwitch.on forKey:@"BigRecordButton"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Change timer shows hours setting
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
