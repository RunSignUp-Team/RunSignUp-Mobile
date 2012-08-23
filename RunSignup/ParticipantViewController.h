//
//  ParticipantViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    
    NSString *raceName;
    NSString *eventName;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *eventName;

@end
