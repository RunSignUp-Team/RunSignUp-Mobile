//
//  SelectRaceViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectRaceViewController.h"
#import "MainMenuViewController.h"
#import "RSUModel.h"

@implementation SelectRaceViewController
@synthesize table;
@synthesize raceList;
@synthesize raceIndex;
@synthesize delegate;
@synthesize popoverController;
@synthesize rli;

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
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
    [model attemptRetreiveRaceList: response];
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
            if([delegate respondsToSelector:@selector(didSelectRace:withID:withEventName:withEventID:)]){
                NSString *raceID = [[raceList objectAtIndex:raceIndex.section] objectForKey:@"RaceID"];
                NSString *eventID = [[[[raceList objectAtIndex:raceIndex.section] objectForKey:@"Events"] objectAtIndex:raceIndex.row] objectForKey:@"EventID"];
                
                void (^response)(int) = ^(int didSucceed){
                    if(didSucceed == Success){
                        NSString *raceName = [[raceList objectAtIndex:raceIndex.section] objectForKey:@"Name"];
                        NSString *raceID = [[raceList objectAtIndex:raceIndex.section] objectForKey:@"RaceID"];
                        
                        NSString *eventName = [[[[raceList objectAtIndex:raceIndex.section] objectForKey:@"Events"] objectAtIndex:raceIndex.row] objectForKey:@"Name"];
                        NSString *eventID = [[[[raceList objectAtIndex:raceIndex.section] objectForKey:@"Events"] objectAtIndex:raceIndex.row] objectForKey:@"EventID"];
                        
                        [rli fadeOut];
                        [delegate didSelectRace:raceName withID:raceID withEventName:eventName withEventID:eventID]; 
                        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                            [self dismissModalViewControllerAnimated:YES];
                        else
                            [popoverController dismissPopoverAnimated:YES];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        [rli fadeOut];
                    }
                };
                
                [[rli label] setText: @"Starting session..."];
                [rli fadeIn];
                [[RSUModel sharedModel] beginTimingNewRace:raceID event:eventID response:response];
            }
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

- (IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
