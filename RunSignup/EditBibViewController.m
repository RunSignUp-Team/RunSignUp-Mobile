//
//  EditBibViewControllerViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditBibViewController.h"

@implementation EditBibViewController
@synthesize saveAndExitButton;
@synthesize bibField;
@synthesize bibNumber;
@synthesize indexPath;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];

    [saveAndExitButton setBackgroundImage: stretchedBlueButton forState:UIControlStateNormal];
    [saveAndExitButton setBackgroundImage: stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    [bibField setText: bibNumber];
    [bibField becomeFirstResponder];
}

// Limit what the user can enter to the string "1234567890"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string length] != 0){
        if(textField.text.length < 5 && strchr("1234567890", [string characterAtIndex: 0])){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

- (IBAction)saveAndExit:(id)sender{
    [delegate didSaveBib:[bibField text] withIndex:indexPath];
    [self goBack:nil];
}

- (IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated: YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
