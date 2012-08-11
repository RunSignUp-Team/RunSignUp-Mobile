//
//  SelectResultSetViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectResultSetViewController.h"
#import "MainMenuViewController.h"
#import "RSUModel.h"

@implementation SelectResultSetViewController
@synthesize table;
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
    
    RSUModel *model = [RSUModel sharedModel];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addResultSet)];
    [self.navigationItem setLeftBarButtonItem: cancelButton];
    [self.navigationItem setRightBarButtonItem: addButton];
    
    self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:80 YLocation:100];
    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    void (^response)(NSArray *) = ^(NSArray *list){
        self.resultSetList = list;
        [table reloadData];
        [rli fadeOut];
    };
    
    self.resultSetList = nil;
    [rli fadeIn];
    
    [model attemptRetreiveResultSetList:raceID event:eventID response:response];
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
        
        UILabel *entriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 26, 200, 16)];
        [entriesLabel setFont: [UIFont systemFontOfSize:14.0f]];
        [entriesLabel setBackgroundColor:[UIColor clearColor]];
        [entriesLabel setTextColor: [UIColor lightGrayColor]];
        [entriesLabel setTag: 13];
        [cell addSubview: entriesLabel];
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
        if([delegate respondsToSelector:@selector(didSelectRace:withID:withEventName:withEventID:)]){
            [[RSUModel sharedModel] setCurrentResultSetID: [[resultSetList objectAtIndex: indexPath.row] objectForKey:@"ResultSetID"]];
            [[RSUModel sharedModel] setCurrentRaceID: raceID];
            [[RSUModel sharedModel] setCurrentEventID: eventID];
            [[RSUModel sharedModel] setLastFinishingTimeID: @"0"];
            [[RSUModel sharedModel] setLastBibNumber: @"0"];
            
            [delegate didSelectRace:raceName withID:raceID withEventName:eventName withEventID:eventID];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                [self.navigationController dismissModalViewControllerAnimated: YES];
            else
                [popoverController dismissPopoverAnimated: YES];
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [resultSetList count];
}

- (void)addResultSet{
    
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
