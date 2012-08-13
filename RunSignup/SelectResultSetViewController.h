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
    NSIndexPath *resultSetIndex;
    
    NSMutableArray *resultSetList;
    
    MainMenuViewController *delegate;
    UIPopoverController *popoverController;
    
    NSString *raceName;
    NSString *raceID;
    NSString *eventName;
    NSString *eventID;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSIndexPath *resultSetIndex;
@property (nonatomic, retain) NSMutableArray *resultSetList;
@property (nonatomic, retain) MainMenuViewController *delegate;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *raceID;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventID;

- (void)retrieveResultSets;
- (void)goBack;
- (void)addResultSet;
- (void)toggleEdit;

@end
