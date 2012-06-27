//
//  ArchiveDetailViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveDetailViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    UILabel *nameLabel;
    UILabel *idLabel;
    UILabel *dateLabel;
    UILabel *typeLabel;
    
    NSMutableArray *records;
    UITableView *table;
    
    NSString *file;
    NSMutableDictionary *fileDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *idLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *records;

@property (nonatomic, retain) NSString *file;
@property (nonatomic, retain) NSMutableDictionary *fileDict;

- (void)toggleEdit;
- (void)saveToFile;
- (void)updateRecordNumbersAfterDeletion;

- (void)updateRow:(NSIndexPath *)indexPath withDict:(NSMutableDictionary *)updateDict;

@end
