//
//  OfflineRaceViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OfflineRaceViewController.h"
#import "MainMenuViewController.h"

@implementation OfflineRaceViewController
@synthesize nameField;
@synthesize createButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (IBAction)createRace:(id)sender{
    if([[nameField text] length] > 0){
        if([delegate respondsToSelector:@selector(didCreateOfflineRace:)]){
            [delegate didCreateOfflineRace:[nameField text]];
            [self dismissModalViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a race name." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self createRace: nil];
    return NO;
}

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad{
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [createButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [createButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    [nameField becomeFirstResponder];
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
