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
@synthesize rli;

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    RSUModel *model = [RSUModel sharedModel];
    
    self.rli = [[RoundedLoadingIndicator alloc] initWithYLocation:200];
    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    void (^response)(NSArray *) = ^(NSArray *list){
        self.raceList = list;
        [table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, 100, 16)];
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
        [(UILabel *)[cell viewWithTag:12] setText: [[raceList objectAtIndex:indexPath.row] objectForKey:@"Name"]];
        if([[raceList objectAtIndex:indexPath.row] objectForKey:@"NDate"] != nil){
            [(UILabel *)[cell viewWithTag:13] setText:[[raceList objectAtIndex:indexPath.row] objectForKey:@"NDate"]];
        }else if([[raceList objectAtIndex:indexPath.row] objectForKey:@"LDate"]){
            [(UILabel *)[cell viewWithTag:13] setText:[[raceList objectAtIndex:indexPath.row] objectForKey:@"LDate"]];
        }else{
            [(UILabel *)[cell viewWithTag:13] setText:@"No date scheduled"];
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Races You Are Directing";
}

// Select a race to time for (of many that a given director could be directing in the future)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(raceList != nil){
        self.raceIndex = indexPath;
        NSString *raceID = [[raceList objectAtIndex:indexPath.row] objectForKey:@"Name"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:[NSString stringWithFormat:@"Are you sure you wish to select \"%@\" as the race to time?", raceID] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
            if([delegate respondsToSelector:@selector(didSelectRace:withID:)]){
                NSString *raceName = [[raceList objectAtIndex:raceIndex.row] objectForKey:@"Name"];
                NSString *raceID = [[raceList objectAtIndex:raceIndex.row] objectForKey:@"RaceID"];
                
                [delegate didSelectRace:raceName withID:raceID]; 
                [self dismissModalViewControllerAnimated:YES];
            }
        }else{
            if(raceIndex != nil){
                [table deselectRowAtIndexPath:raceIndex animated:YES];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(raceList != nil)
        return [raceList count];
    else
        return 1;
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
