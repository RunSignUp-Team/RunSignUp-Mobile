//
//  ArchiveEditCellViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveEditCellViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    UITextField *bibField;
    UIPickerView *timePicker;
    
    UILabel *timeHintLabel;
    UILabel *timeLabel;
    UILabel *placeHintLabel;
    UILabel *placeLabel;
    
    UIButton *saveButton;
    
    NSTimeInterval time;
    NSString *place;
    NSString *bib;
    
    int type;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(int)t;

@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) IBOutlet UIPickerView *timePicker;
@property (nonatomic, retain) IBOutlet UILabel *timeHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *placeHintLabel;
@property (nonatomic, retain) IBOutlet UILabel *placeLabel;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;

@property NSTimeInterval time;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *bib;

- (IBAction)saveChanges:(id)sender;
- (void)setPickerGivenTime;

@end
