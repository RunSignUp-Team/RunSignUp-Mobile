//
//  SelectRaceViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainMenuViewController;

@interface SelectRaceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    UITableView *table;    
    NSIndexPath *raceIndex;
    
    MainMenuViewController *delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSIndexPath *raceIndex;
@property (nonatomic, retain) MainMenuViewController *delegate;

- (IBAction)cancel:(id)sender;

@end
