//
//  ArchiveDetailViewController.h
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
