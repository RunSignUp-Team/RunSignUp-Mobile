//
//  ArchiveDetailViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ArchiveDetailViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    UILabel *nameLabel;
    UILabel *raceIDLabel;
    UILabel *eventIDLabel;
    UILabel *eventIDHintLabel;
    UILabel *dateLabel;
    UILabel *typeLabel;
        
    UIButton *shareButton;
    
    NSMutableArray *records;
    UITableView *table;
    
    NSString *file;
    NSMutableDictionary *fileDict;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *raceIDLabel;
@property (nonatomic, retain) IBOutlet UILabel *eventIDLabel;
@property (nonatomic, retain) IBOutlet UILabel *eventIDHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *records;

@property (nonatomic, retain) NSString *file;
@property (nonatomic, retain) NSMutableDictionary *fileDict;

- (void)toggleEdit;
- (void)saveToFile;
- (void)updateRecordNumbersAfterDeletion;
- (IBAction)share:(id)sender;

- (void)updateRow:(NSIndexPath *)indexPath withDict:(NSMutableDictionary *)updateDict;

@end
