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
    
    NSMutableArray *participants;
    
    NSString *raceName;
    NSString *eventName;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *participants;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *eventName;

- (IBAction)goBack:(id)sender;
- (IBAction)toggleEdit:(id)sender;
- (IBAction)addParticipant:(id)sender;

- (void)createParticipantWithDictionary:(NSDictionary *)dict;

@end
