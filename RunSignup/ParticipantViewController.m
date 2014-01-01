//
//  ParticipantViewController.m
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

#import "ParticipantViewController.h"
#import "ParticipantTableViewCell.h"
#import "ParticipantDetailViewController.h"
#import "RSUModel.h"
#import "AppDelegate.h"

@implementation ParticipantViewController
@synthesize table;
@synthesize participants;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Participants";
        self.participants = nil;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    if([table respondsToSelector:@selector(setSeparatorStyle:)]){
        [table setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    }
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEdit:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addParticipant:)];
    
    [self.navigationItem setLeftBarButtonItem: cancelButton];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addButton, editButton, nil]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        if([[UIScreen mainScreen] bounds].size.height > 480.0f)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:160 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:204 YLocation:100];
    else
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:100];

    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    [rli fadeIn];
    
    void (^response)(NSMutableArray *) = ^(NSMutableArray *list){
        self.participants = list;
        if([list count] >= 250){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There are too many participants in the list for a mobile device to edit. Please make any changes or edits on a desktop or laptop computer." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        [table reloadData];
        [rli fadeOut];
    };
    
    [[RSUModel sharedModel] attemptRetrieveParticipants:response];
    
    [cancelButton release];
    [editButton release];
    [addButton release];
}

- (void)viewDidAppear:(BOOL)animated{
    [table deselectRowAtIndexPath:[table indexPathForSelectedRow] animated:YES];
}

- (void)sortParticipants{
    [participants sortUsingComparator: ^NSComparisonResult(id a, id b) {
        NSString *first = [NSString stringWithFormat:@"%@ %@", [a objectForKey:@"LastName"], [a objectForKey:@"FirstName"]];
        NSString *second = [NSString stringWithFormat:@"%@ %@", [b objectForKey:@"LastName"], [b objectForKey:@"FirstName"]];
        return [first compare:second];
    }];
    
    [table reloadData];
}

- (void)createParticipantWithDictionary:(NSDictionary *)dict response:(void (^)(RSUConnectionResponse))responseBlock{
    void (^response)(RSUConnectionResponse, NSString *) = ^(RSUConnectionResponse didSucceed, NSString *regID){
        if(didSucceed == RSUSuccess){
            if(regID){
                NSMutableDictionary *newParticipant = [[NSMutableDictionary alloc] initWithDictionary: dict];
                [newParticipant setObject:regID forKey:@"RegistrationID"];
                [participants insertObject:newParticipant atIndex:0];
                [self sortParticipants];
                [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(didSucceed);});
    };
    
    [[RSUModel sharedModel] editParticipants:[NSArray arrayWithObject:dict] response:response];
}

- (void)editParticipantWithDictionary:(NSDictionary *)dict editPath:(NSIndexPath *)editPath response:(void (^)(RSUConnectionResponse))responseBlock{
    void (^response)(RSUConnectionResponse, NSString *) = ^(RSUConnectionResponse didSucceed, NSString *regID){
        if(didSucceed == RSUSuccess){
            if(regID){
                [self sortParticipants];
                [table selectRowAtIndexPath:editPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(didSucceed);});
    };
    
    NSMutableDictionary *newParticipant = [[NSMutableDictionary alloc] initWithDictionary: dict];
    [newParticipant setObject:[[participants objectAtIndex: [editPath row]] objectForKey: @"RegistrationID"] forKey:@"RegistrationID"];
    [participants replaceObjectAtIndex:[editPath row] withObject:newParticipant];
    [[RSUModel sharedModel] editParticipants:[NSArray arrayWithObject:newParticipant] response:response];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    ParticipantTableViewCell *cell = (ParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ParticipantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row % 2)
        [[cell contentView] setBackgroundColor: [UIColor colorWithWhite:0.94f alpha:1.0f]];
    else
        [[cell contentView] setBackgroundColor: [UIColor whiteColor]];

    [[cell firstNameLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"FirstName"]];
    [[cell lastNameLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"LastName"]];
    [[cell genderLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"Gender"]];
    [[cell bibLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    [[cell ageLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"Age"]];
    [[cell cityLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"City"]];
    [[cell stateLabel] setText:[[participants objectAtIndex: indexPath.row] objectForKey:@"State"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2)
        [cell setBackgroundColor: [UIColor colorWithWhite:0.94f alpha:1.0f]];
    else
        [cell setBackgroundColor: [UIColor whiteColor]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ParticipantTableViewCell *header = [[ParticipantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Header"];
    [header setIsHeader: YES];
    [[header firstNameLabel] setText:@"First name"];
    [[header lastNameLabel] setText:@"Last name"];
    [[header genderLabel] setText:@"G"];
    [[header bibLabel] setText:@"Bib #"];
    [[header ageLabel] setText:@"Age"];
    [[header cityLabel] setText:@"City"];
    [[header stateLabel] setText:@"ST"];
    return [header contentView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [participants count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ParticipantDetailViewController *participantDetailViewController = [[ParticipantDetailViewController alloc] initWithNibName:@"ParticipantDetailViewController" bundle:nil isCreating:NO];
    [participantDetailViewController setDelegate: self];
    [participantDetailViewController setEditDictionary: [participants objectAtIndex: indexPath.row]];
    [participantDetailViewController setEditPath: indexPath];
    [self.navigationController pushViewController:participantDetailViewController animated:YES];
}

- (IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated: YES];
}

- (IBAction)toggleEdit:(id)sender{
    if([table isEditing])
        [table setEditing:NO animated:YES];
    else
        [table setEditing:YES animated:YES];
}

- (IBAction)addParticipant:(id)sender{
    ParticipantDetailViewController *participantDetailViewController = [[ParticipantDetailViewController alloc] initWithNibName:@"ParticipantDetailViewController" bundle:nil isCreating:YES];
    [participantDetailViewController setDelegate: self];
    [self.navigationController pushViewController:participantDetailViewController animated:YES];
}

- (NSUInteger)supportedInterfaceOrientations{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskLandscape;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationLandscapeLeft;
    else
        return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
