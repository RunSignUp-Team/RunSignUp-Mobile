//
//  ParticipantDetailViewController.m
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

#import "ParticipantDetailViewController.h"
#import "ParticipantViewController.h"

@implementation ParticipantDetailViewController
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize bibField;
@synthesize ageField;
@synthesize stateField;
@synthesize rli;
@synthesize cityField;
@synthesize genderControl;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isCreating:(BOOL)isCreating{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        creating = isCreating;
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
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:160 YLocation:100];
    else
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:100];
    
    if(creating)
        [[rli label] setText:@"Adding..."];
    else
        [[rli label] setText:@"Editing..."];

    [self.view addSubview: rli];

    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == bibField){
        if([string length] == 1){
            if(textField.text.length < 5 && strchr("1234567890", [string characterAtIndex: 0])){
                return YES;
            }else{
                return NO;
            }
        }else if([string length] == 0){
            return YES;
        }
    }else if(textField == ageField){
        if([string length] == 1){
            if(textField.text.length < 3 && strchr("1234567890", [string characterAtIndex: 0])){
                return YES;
            }else{
                return NO;
            }
        }else if([string length] == 0){
            return YES;
        }
    }else if(textField == stateField){
        if([string length] == 1){
            if(textField.text.length < 2 && strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZ ", [string characterAtIndex: 0])){
                return YES;
            }else{
                return NO;
            }
        }else if([string length] == 0){
            return YES;
        }
    }else if(textField == firstNameField || textField == lastNameField || textField == cityField){
        if([string length] == 1){
            if(textField.text.length < 30 && strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ", [string characterAtIndex: 0])){
                return YES;
            }else{
                return NO;
            }
        }else if([string length] == 0){
            return YES;
        }
    }
    return YES;
}

- (IBAction)submit:(id)sender{
    
    // Auto capitalize the names for proper alphabetization
    if([[firstNameField text] length] >= 1)
        [firstNameField setText: [[firstNameField text] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[firstNameField text] substringToIndex:1] capitalizedString]]];
    if([[lastNameField text] length] >= 1)
        [lastNameField setText: [[lastNameField text] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[lastNameField text] substringToIndex:1] capitalizedString]]];
    if([[cityField text] length] >= 1)
        [cityField setText: [[cityField text] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[[cityField text] substringToIndex:1] capitalizedString]]];
    
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
    
    if(creating){
        void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
            if(didSucceed == RSUNoConnection){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                [self.navigationController popViewControllerAnimated: YES];
            }
            
            [rli fadeOut];
        };
        
        [rli fadeIn];
        [delegate createParticipantWithDictionary:dict response:response];
    }else{
        // edit/upload participant
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

@end
