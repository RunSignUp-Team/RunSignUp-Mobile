//
//  SelectRaceViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@class MainMenuViewController;

@interface SelectRaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    UITableView *table;    
    NSIndexPath *raceIndex;
    
    NSArray *raceList;
    
    MainMenuViewController *delegate;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *raceList;
@property (nonatomic, retain) NSIndexPath *raceIndex;
@property (nonatomic, retain) MainMenuViewController *delegate;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (IBAction)cancel:(id)sender;

@end
