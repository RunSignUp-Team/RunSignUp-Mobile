//
//  SelectResultSetViewController.m
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

#import "SelectResultSetViewController.h"
#import "MainMenuViewController.h"
#import "RSUModel.h"

@implementation SelectResultSetViewController
@synthesize table;
@synthesize resultSetIndex;
@synthesize resultSetList;
@synthesize delegate;
@synthesize popoverController;
@synthesize rli;

@synthesize raceName;
@synthesize raceID;
@synthesize eventName;
@synthesize eventID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Result Sets";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEdit)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addResultSet)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editButton, addButton, nil]];
    
    self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    [[RSUModel sharedModel] setCurrentRaceID: raceID];
    [[RSUModel sharedModel] setCurrentEventID: eventID];
    [[RSUModel sharedModel] setLastFinishingTimeID: @"0"];
    [[RSUModel sharedModel] setLastBibNumber: @"0"];
    
    [self retrieveResultSets];
}

- (void)retrieveResultSets{
    RSUModel *model = [RSUModel sharedModel];
    void (^response)(NSMutableArray *) = ^(NSMutableArray *list){
        self.resultSetList = list;
        [table reloadData];
        [rli fadeOut];
    };
    
    self.resultSetList = nil;
    [rli fadeIn];
    
    [model attemptRetrieveResultSetList:raceID event:eventID response:response];
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
        [cell.contentView addSubview: nameLabel];
        
        UILabel *entriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, 200, 16)];
        [entriesLabel setFont: [UIFont systemFontOfSize:14.0f]];
        [entriesLabel setBackgroundColor:[UIColor clearColor]];
        [entriesLabel setTextColor: [UIColor lightGrayColor]];
        [entriesLabel setTag: 13];
        [cell.contentView addSubview: entriesLabel];
    }
    if(resultSetList == nil){
        [[cell textLabel] setText: @"No result sets found. Create one."];
        [(UILabel *)[cell viewWithTag:12] setText:@""];
        [(UILabel *)[cell viewWithTag:13] setText:@""];
    }else{
        [[cell textLabel] setText:@""];
        [(UILabel *)[cell viewWithTag:12] setText: [[resultSetList objectAtIndex: indexPath.row] objectForKey: @"ResultSetName"]];
        [(UILabel *)[cell viewWithTag:13] setText: [[resultSetList objectAtIndex: indexPath.row] objectForKey: @"ResultSetID"]];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Result Sets";
}

// Select a race to time for (of many that a given director could be directing in the future)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(resultSetList != nil){
        self.resultSetIndex = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:@"Are you sure you wish to choose this result set?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        [alert release];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if([alertView alertViewStyle] == UIAlertViewStylePlainTextInput){
        NSString *name = [[alertView textFieldAtIndex: 0] text];
        if([name length] > 0 && [name length] < 30){
            void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                if(didSucceed == RSUNoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }else{
                    [delegate didSelectRace:raceName withID:raceID withEventName:eventName withEventID:eventID];
                    [table deselectRowAtIndexPath:resultSetIndex animated:NO];

                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        [self.navigationController dismissModalViewControllerAnimated: YES];
                    else
                        [popoverController dismissPopoverAnimated: YES];
                }
            };
            
            [[RSUModel sharedModel] createNewResultSet:name response:response];
        }
    }else{
        if(resultSetList != nil){
            if(buttonIndex == 1){
                if([delegate respondsToSelector:@selector(didSelectRace:withID:withEventName:withEventID:)]){
                    [[RSUModel sharedModel] setCurrentResultSetID: [[resultSetList objectAtIndex: resultSetIndex.row] objectForKey:@"ResultSetID"]];
                    
                    /*void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                        if(didSucceed == RSUNoConnection){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                        }
                    };
                    
                    [[RSUModel sharedModel] deleteResults:RSUClearResults response:response];*/
                    
                    [delegate didSelectRace:raceName withID:raceID withEventName:eventName withEventID:eventID];
                    [table deselectRowAtIndexPath:resultSetIndex animated:NO];
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        [self.navigationController dismissModalViewControllerAnimated: YES];
                    else
                        [popoverController dismissPopoverAnimated: YES];
                }
            }else{
                [table deselectRowAtIndexPath:resultSetIndex animated:NO];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
            if(didSucceed == RSUNoConnection){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                [resultSetList removeObjectAtIndex: indexPath.row];
                [table deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        
        NSString *resultSetID = [[resultSetList objectAtIndex: indexPath.row] objectForKey:@"ResultSetID"];
        [[RSUModel sharedModel] deleteResultSet:resultSetID response:response];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [resultSetList count];
}

- (void)addResultSet{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result set name:" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];
    [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [alert show];
    [alert release];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if([alertView alertViewStyle] == UIAlertViewStylePlainTextInput){
        NSUInteger length = [[[alertView textFieldAtIndex: 0] text] length];
        if(length > 0 && length < 30){
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

- (void)toggleEdit{
    if([table isEditing])
        [table setEditing:NO animated:YES];
    else
        [table setEditing:YES animated:YES];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated: YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
