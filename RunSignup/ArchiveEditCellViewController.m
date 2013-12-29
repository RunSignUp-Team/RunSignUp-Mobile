//
//  ArchiveEditCellViewController.m
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

#import "ArchiveEditCellViewController.h"
#import "ArchiveDetailViewController.h"

@implementation ArchiveEditCellViewController
@synthesize bibField;
@synthesize timePicker;
@synthesize timeHintLabel;
@synthesize timeLabel;
@synthesize placeHintLabel;
@synthesize placeLabel;
@synthesize saveButton;
@synthesize time;
@synthesize place;
@synthesize bib;
@synthesize delegate;
@synthesize index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(int)t{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        type = t;
        self.title = @"Edit Data";
        didChangeTime = NO;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];

    UIImage *redButtonImage = [UIImage imageNamed:@"RedButton.png"];
    UIImage *stretchedRedButton = [redButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *redButtonTapImage = [UIImage imageNamed:@"RedButtonTap.png"];
    UIImage *stretchedRedButtonTap = [redButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *grayButtonImage = [UIImage imageNamed:@"GrayButton.png"];
    UIImage *stretchedGrayButton = [grayButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [saveButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [saveButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [saveButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    
    if(type == 0){ //Place + Time
        [bibField setHidden:YES];
        
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        [formatter setDateFormat:@"HH:mm:ss.SS"];
        NSString *timeString = [formatter stringFromDate:timerDate];
        [timeLabel setText:timeString];
        [placeLabel setText:place];
        
        [self setPickerGivenTime];
    }else if(type == 1){ // Bib + Time
        [placeLabel setHidden:YES];
        [placeHintLabel setHidden:YES];
        
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        [formatter setDateFormat:@"HH:mm:ss.SS"];
        NSString *timeString = [formatter stringFromDate:timerDate];
        [timeLabel setText:timeString];
        [bibField setText:bib];
        
        [self setPickerGivenTime];
    }else{ // Place + Bib
        [timeLabel setHidden:YES];
        [timeHintLabel setHidden: YES];
        [timePicker setHidden:YES];
        
        [bibField setText: bib];
        [placeLabel setText:place];
        [bibField becomeFirstResponder];

    }
}

- (void)setPickerGivenTime{
    int hours = (int)time / 3600;
    int minutes = (int)time / 60;
    int seconds = (int)time % 60;
    int centiseconds = round((double)(time - (int)time) * 100.0);
        
    [timePicker selectRow:hours inComponent:0 animated:NO];
    [timePicker selectRow:minutes inComponent:1 animated:NO];
    [timePicker selectRow:seconds inComponent:2 animated:NO];
    [timePicker selectRow:centiseconds inComponent:3 animated:NO];
}

- (void)actuallySaveChanges{
    if(type == 0){
        NSMutableDictionary *updateDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:time],@"Time",[timeLabel text],@"FTime",[placeLabel text],@"Place",nil];
        [delegate updateRow:index withDict:updateDict];
    }else if(type == 1){
        NSMutableDictionary *updateDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:time],@"Time",[timeLabel text],@"FTime",[bibField text],@"Bib",nil];
        [delegate updateRow:index withDict:updateDict];
    }else{
        NSMutableDictionary *updateDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[bibField text],@"Bib",[placeLabel text],@"Place", nil];
        [delegate updateRow:index withDict:updateDict];
    }
    [saveButton setEnabled: NO];
    didChangeTime = NO;
}

- (IBAction)saveChanges:(id)sender{
    if(didChangeTime){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Changed" message:@"You have changed this runner's time. Updating this will reorder the entire list. Are you sure you wish to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
    }else{
        [self actuallySaveChanges];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self actuallySaveChanges];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4; // Hours, minutes, seconds, centiseconds
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int hours = [pickerView selectedRowInComponent: 0];
    int minutes = [pickerView selectedRowInComponent: 1];
    int seconds = [pickerView selectedRowInComponent: 2];
    int centiseconds = [pickerView selectedRowInComponent: 3];
    
    [timeLabel setText: [NSString stringWithFormat:@"%.2i:%.2i:%.2i.%.2i", hours, minutes, seconds, centiseconds]];
    self.time = (hours * 3600.0) + (minutes * 60.0) + (seconds * 1.0) + (centiseconds / 100.0);
    
    if(type == 0){
        [saveButton setEnabled: YES];
    }else if(type == 1 && [[bibField text] length] > 0){
        [saveButton setEnabled: YES];
    }
    
    didChangeTime = YES;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0 || component == 3){
        return 100;
    }else{
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%.2i", row];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string length] == 1){
        if(textField.text.length < 5 && strchr("1234567890", [string characterAtIndex: 0])){
            [saveButton setEnabled: YES];
            return YES;
        }else{
            return NO;
        }
    }else if([string length] == 0){
        [saveButton setEnabled: YES];
        return YES;
    }
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
