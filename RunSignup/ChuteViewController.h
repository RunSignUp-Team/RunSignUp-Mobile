//
//  ChuteViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "NumpadView.h"

@interface ChuteViewController : UIViewController <ZBarReaderDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    UIButton *recordButton;
    UIButton *barcodeButton;
    
    UITableView *table;
    NSMutableArray *records;
    
    UITextField *bibField;
    
    NSString *raceID;
    NSString *raceName;
    NSString *eventID;
    NSString *eventName;
    NSString *fileToSave;
    
    ZBarReaderViewController *zbarReaderViewController;
    
    NumpadView *numpadView;
}

@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *barcodeButton;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) NSString *raceID;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *fileToSave;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) ZBarReaderViewController *zbarReaderViewController;
@property (nonatomic, retain) NumpadView *numpadView;


- (IBAction)record:(id)sender;
- (IBAction)stopRace:(id)sender;
- (IBAction)barcodeScanner:(id)sender;

- (void)toggleEditing;
- (void)updateRecordNumbersAfterDeletion;

- (void)saveToFile;

@end