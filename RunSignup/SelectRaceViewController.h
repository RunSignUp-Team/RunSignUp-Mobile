//
//  SelectRaceViewController.h
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

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@class MainMenuViewController;

@interface SelectRaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    UITableView *table;    
    NSIndexPath *raceIndex;
    
    NSArray *raceList;
    
    MainMenuViewController *delegate;
    UIPopoverController *popoverController;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *raceList;
@property (nonatomic, retain) NSIndexPath *raceIndex;
@property (nonatomic, retain) MainMenuViewController *delegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (void)goBack;
@end
