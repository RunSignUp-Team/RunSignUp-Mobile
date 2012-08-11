//
//  SelectResultSetViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"

@class MainMenuViewController;

@interface SelectResultSetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    UITableView *table;    
    
    NSArray *resultSetList;
    
    MainMenuViewController *delegate;
    UIPopoverController *popoverController;
    
    NSString *raceName;
    NSString *raceID;
    NSString *eventName;
    NSString *eventID;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *resultSetList;
@property (nonatomic, retain) MainMenuViewController *delegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *raceID;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventID;

- (void)goBack;
- (void)addResultSet;

@end
