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

- (void)viewDidLoad{
    RSUModel *model = [RSUModel sharedModel];
    self.raceList = [model attemptRetreiveRaceList];

    [super viewDidLoad];
}

// Create empty cell to display race for director
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if(raceList == nil){
        [[cell textLabel] setText: @"No races found. Please try again."];
    }else{
        [[cell textLabel] setText: [[raceList objectAtIndex:indexPath.row] objectForKey:@"Name"]];

    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Races You Are Directing";
}

// Select a race to time for (of many that a given director could be directing in the future)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.raceIndex = indexPath;
    NSString *raceID = [[raceList objectAtIndex:indexPath.row] objectForKey:@"Name"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure?" message:[NSString stringWithFormat:@"Are you sure you wish to select \"%@\" as the race to time?", raceID] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

// Delegate method to check if the selected race is really the one to time for
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if([delegate respondsToSelector:@selector(didSelectRace:)]){
            NSString *raceID = [[raceList objectAtIndex:raceIndex.row] objectForKey:@"Name"];
            if([delegate didSelectRace:raceID]){
                [self dismissModalViewControllerAnimated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We were unable to select that race. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }
    }else{
        if(raceIndex != nil){
            [table deselectRowAtIndexPath:raceIndex animated:YES];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
