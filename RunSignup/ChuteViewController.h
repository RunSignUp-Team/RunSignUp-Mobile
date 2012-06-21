//
//  ChuteViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChuteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UIButton *recordButton;
    
    UITableView *table;
    NSMutableArray *records;
    
    UITextField *bibField;
    
    NSString *raceID;
    NSString *raceName;
    NSString *fileToSave;
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) NSString *raceID;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *fileToSave;
@property (nonatomic, retain) NSMutableArray *records;

- (IBAction)record:(id)sender;

- (void)toggleEditing;
- (void)updateRecordNumbersAfterDeletion;

- (void)saveToFile;

@end