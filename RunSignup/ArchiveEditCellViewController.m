//
//  ArchiveEditCellViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArchiveEditCellViewController.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(int)t{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        type = t;
        self.title = @"Edit Data";
    }
    return self;
}

- (void)viewDidLoad{
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [saveButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [saveButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    if(type == 0){ //Place + Time
        [bibField setHidden:YES];
        [placeLabel setText:place];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        [formatter setDateFormat:@"HH:mm:ss.SS"];
        NSString *timeString = [formatter stringFromDate:timerDate];
        [timeLabel setText:timeString];
        [self setPickerGivenTime];
    }else if(type == 1){ // Bib + Time
        [placeLabel setHidden:YES];
        [placeHintLabel setHidden:YES];
        [bibField setText:bib];
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        [formatter setDateFormat:@"HH:mm:ss.SS"];
        NSString *timeString = [formatter stringFromDate:timerDate];
        [timeLabel setText:timeString];
        [self setPickerGivenTime];
    }else{ // Place + Bib
        [timeLabel setHidden:YES];
        [timeHintLabel setHidden: YES];
        [timePicker setHidden:YES];
        [bibField setText: bib];
        [bibField becomeFirstResponder];
        [placeLabel setText:place];
    }
    [super viewDidLoad];
}

- (void)setPickerGivenTime{
    int hours = (int)time / 3600;
    int minutes = (int)time / 60;
    int seconds = (int)time % 60;
    int milliseconds = (double)(time - (int)time) * 100.0;
        
    [timePicker selectRow:hours inComponent:0 animated:NO];
    [timePicker selectRow:minutes inComponent:1 animated:NO];
    [timePicker selectRow:seconds inComponent:2 animated:NO];
    [timePicker selectRow:milliseconds inComponent:3 animated:NO];

}

- (IBAction)saveChanges:(id)sender{
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4; // Hours, minutes, seconds, milliseconds
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
    if([string length] != 0){
        if(textField.text.length < 5 && strchr("1234567890-", [string characterAtIndex: 0])){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
