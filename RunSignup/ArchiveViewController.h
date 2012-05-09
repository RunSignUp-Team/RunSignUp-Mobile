//
//  ArchiveViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    
    NSMutableArray *fileArray;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *fileArray;

- (void)cancel;
- (void)toggleEdit;

@end
