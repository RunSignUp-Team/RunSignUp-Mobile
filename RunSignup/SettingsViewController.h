//
//  SettingsViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{
}

@property (nonatomic, retain) IBOutlet UISwitch *bigRecordSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *timerHoursSwitch;

- (IBAction)bigRecordChange:(id)sender;
- (IBAction)timerHoursChange:(id)sender;
- (IBAction)done:(id)sender;

@end
