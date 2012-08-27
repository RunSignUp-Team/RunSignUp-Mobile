//
//  SelectRaceViewController.m
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

#import "SelectRaceViewController.h"
#import "MainMenuViewController.h"
#import "SelectResultSetViewController.h"
#import "RSUModel.h"

@implementation SelectRaceViewController
@synthesize table;
@synthesize raceList;
@synthesize raceIndex;
@synthesize delegate;
@synthesize popoverController;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Race List";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
        [self.navigationItem setLeftBarButtonItem: cancelButton];
    }
    
    RSUModel *model = [RSUModel sharedModel];
    
    self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    void (^response)(NSArray *) = ^(NSArray *list){
        self.raceList = list;
        [table reloadData];
        [rli fadeOut];
    };
    
    self.raceList = nil;
    [rli fadeIn];
    [model attemptRetrieveRaceList: response];
}

// Create empty cell to display race for director
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 310, 20)];
        [nameLabel setFont: [UIFont boldSystemFontOfSize:18.0f]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTag: 12];
        [cell addSubview: nameLabel];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, 200, 16)];
        [dateLabel setFont: [UIFont systemFontOfSize:14.0f]];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setTextColor: [UIColor lightGrayColor]];
        [dateLabel setTag: 13];
        [cell addSubview: dateLabel];
    }
    if(raceList == nil){
        [[cell textLabel] setText: @"No races found. Please retry."];
        [(UILabel *)[cell viewWithTag:12] setText:@""];
        [(UILabel *)[cell viewWithTag:13] setText:@""];
    }else{
        [[cell textLabel] setText:@""];
        [(UILabel *)[cell viewWithTag:12] setText: [[[[raceList objectAtIndex:indexPath.section] objectForKey:@"Events"] objectAtIndex:indexPath.row] objectForKey:@"Name"]];
        [(UILabel *)[cell viewWithTag:13] setText: [[[[raceList objectAtIndex:indexPath.section] objectForKey:@"Events"] objectAtIndex:indexPath.row] objectForKey:@"StartTime"]];
        /*if([[raceList objectAtIndex:indexPath.row] objectForKey:@"NDate"] != nil){
            [(UILabel *)[cell viewWithTag:13] setText:[[raceList objectAtIndex:indexPath.row] objectForKey:@"NDate"]];
        }else if([[raceList objectAtIndex:indexPath.row] objectForKey:@"LDate"]){
            [(UILabel *)[cell viewWithTag:13] setText:[[raceList objectAtIndex:indexPath.row] objectForKey:@"LDate"]];
        }else{
            [(UILabel *)[cell viewWithTag:13] setText:@"No date scheduled"];
        }*/
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = nil;
    if([[raceList objectAtIndex:section] objectForKey:@"NDate"] != nil){
        NSString *name = [[raceList objectAtIndex: section] objectForKey: @"Name"];
        if([name length] > 22)
            name = [name substringToIndex: 21];
        NSString *ndate = [[raceList objectAtIndex: section] objectForKey: @"NDate"];
        title = [NSString stringWithFormat:@"%@ - %@", name, ndate];
    }else if([[raceList objectAtIndex:section] objectForKey:@"LDate"] != nil){
        NSString *name = [[raceList objectAtIndex: section] objectForKey: @"Name"];
        if([name length] > 22)
            name = [name substringToIndex: 21];
        NSString *ldate = [[raceList objectAtIndex: section] objectForKey: @"LDate"];
        title = [NSString stringWithFormat:@"%@ - %@", name, ldate];    
    }else{
        title = [[raceList objectAtIndex: section] objectForKey: @"Name"];
    }
    return title;
}

// Select a race to time for (of many that a given director could be directing in the future)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(raceList != nil){
        self.raceIndex = indexPath;
        NSString *eventName = [[[[raceList objectAtIndex:indexPath.section] objectForKey:@"Events"] objectAtIndex:indexPath.row] objectForKey:@"Name"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:[NSString stringWithFormat:@"Are you sure you wish to select \"%@\" as the event to time?", eventName] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

// Delegate method to check if the selected race is really the one to time for
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(raceList != nil){
        if(buttonIndex == 1){
            NSString *raceName = [[raceList objectAtIndex:raceIndex.section] objectForKey:@"Name"];
            NSString *raceID = [[raceList objectAtIndex:raceIndex.section] objectForKey:@"RaceID"];
            
            NSString *eventName = [[[[raceList objectAtIndex:raceIndex.section] objectForKey:@"Events"] objectAtIndex:raceIndex.row] objectForKey:@"Name"];
            NSString *eventID = [[[[raceList objectAtIndex:raceIndex.section] objectForKey:@"Events"] objectAtIndex:raceIndex.row] objectForKey:@"EventID"];
            
            SelectResultSetViewController *selectResultSetViewController = [[SelectResultSetViewController alloc] initWithNibName:@"SelectResultSetViewController" bundle:nil];
            [selectResultSetViewController setDelegate: delegate];
            [selectResultSetViewController setPopoverController: popoverController];
            [selectResultSetViewController setRaceName: raceName];
            NSLog(@"Race %@", raceID);
            NSLog(@"Event %@", eventID);
            [selectResultSetViewController setRaceID: raceID];
            [selectResultSetViewController setEventName: eventName];
            [selectResultSetViewController setEventID: eventID];
            
            [table deselectRowAtIndexPath:raceIndex animated:YES];
            
            [self.navigationController pushViewController:selectResultSetViewController animated:YES];
        }else{
            if(raceIndex != nil){
                [table deselectRowAtIndexPath:raceIndex animated:YES];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(raceList != nil)
        return [raceList count];
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[raceList objectAtIndex: section] objectForKey:@"Events"] count];
}

- (void)goBack{
    [self dismissModalViewControllerAnimated: YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
