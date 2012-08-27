//
//  ParticipantDetailViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantDetailViewController.h"
#import "ParticipantViewController.h"

@implementation ParticipantDetailViewController
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize bibField;
@synthesize ageField;
@synthesize stateField;
@synthesize cityField;
@synthesize genderControl;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCreating:(BOOL)isCreating{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        if(isCreating){
            self.title = @"Add Participant";
        }else{
            self.title = @"Edit Participant";
        }
        
        UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submit:)];
        [self.navigationItem setRightBarButtonItem: submitButton];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [firstNameField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == firstNameField){
        [firstNameField resignFirstResponder];
        [lastNameField becomeFirstResponder];
    }else if(textField == lastNameField){
        [lastNameField resignFirstResponder];
        [bibField becomeFirstResponder];
    }else if(textField == bibField){
        [bibField resignFirstResponder];
        [ageField becomeFirstResponder];
    }else if(textField == ageField){
        [ageField resignFirstResponder];
        [cityField becomeFirstResponder];
    }else if(textField == cityField){
        [cityField resignFirstResponder];
        [stateField becomeFirstResponder];
    }else if(textField == stateField){
        [self submit: nil];
    }
    return NO;
}

- (IBAction)submit:(id)sender{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[firstNameField text] forKey:@"FirstName"];
    [dict setObject:[lastNameField text] forKey:@"LastName"];
    [dict setObject:[bibField text] forKey:@"Bib"];
    [dict setObject:[ageField text] forKey:@"Age"];
    [dict setObject:[cityField text] forKey:@"City"];
    [dict setObject:[stateField text] forKey:@"State"];
    
    if([genderControl selectedSegmentIndex] == 0){
        [dict setObject:@"M" forKey:@"Gender"];
    }else{
        [dict setObject:@"F" forKey:@"Gender"];
    }
    
    [delegate createParticipantWithDictionary: dict];
    [self.navigationController popViewControllerAnimated: YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
