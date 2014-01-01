//
//  SettingsViewController.m
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

#import "SettingsViewController.h"

@implementation SettingsViewController
@synthesize settings;
@synthesize autoSignInSwitch;
@synthesize bigRecordSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return 2;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Settings";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell.textLabel setText: [[NSArray arrayWithObjects:@"Automatically Sign In:", @"Big Record Button:", nil] objectAtIndex:indexPath.row]];
    
    switch(indexPath.row){
        case 0:
            [autoSignInSwitch setFrame: CGRectMake(220, 7, 0, 0)];
            [cell addSubview: autoSignInSwitch];
            break;
        case 1:
            [bigRecordSwitch setFrame: CGRectMake(220, 7, 0, 0)];
            [cell addSubview: bigRecordSwitch];
            break;
        default:
            break;
    }
    
    return cell;
}

- (IBAction)bigRecordChange:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:bigRecordSwitch.on forKey:@"BigRecordButton"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)autoSignInChange:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:autoSignInSwitch.on forKey:@"AutoSignIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        for(UIView *subView in [self.view subviews]){
            CGRect frame = [subView frame];
            frame.origin.y += 20;
            [subView setFrame: frame];
        }
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [bigRecordSwitch setHidden: YES];
    
    [autoSignInSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoSignIn"]];
    [bigRecordSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"]];
}

- (IBAction)done:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskPortrait;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationPortrait;
    else
        return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
