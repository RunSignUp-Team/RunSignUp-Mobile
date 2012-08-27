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

@implementation ParticipantViewController
@synthesize table;
@synthesize participants;
@synthesize rli;
@synthesize row;
@synthesize raceName;
@synthesize eventName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Participants";
        self.participants = nil;
        self.row = nil;
        
        /*for(int x = 0; x < 7; x++){
            NSMutableDictionary *participant = [[NSMutableDictionary alloc] init];
            [participant setObject: [[NSArray arrayWithObjects:@"Alex", @"Maria", @"June", @"Samantha", @"Martin", @"Justin", @"William", nil] objectAtIndex: x] forKey:@"FirstName"];
            [participant setObject: [[NSArray arrayWithObjects:@"Wang", @"San Jose", @"Schweikert", @"Schmalbach", @"Stankeveciute", @"Muise", @"Connolly", nil] objectAtIndex: x] forKey:@"LastName"];
            [participant setObject: [[NSArray arrayWithObjects:@"M", @"F", @"F", @"F", @"M", @"M", @"M", nil] objectAtIndex: x] forKey:@"Gender"];
            [participant setObject: [[NSArray arrayWithObjects:@"13324", @"01892", @"01995", @"41512", @"53012", @"50632", @"20569", nil] objectAtIndex: x] forKey:@"Bib"];
            [participant setObject: [[NSArray arrayWithObjects:@"14", @"22", @"126", @"64", @"29", @"16", @"17", nil] objectAtIndex: x] forKey:@"Age"];
            [participant setObject: [[NSArray arrayWithObjects:@"Moorestown", @"Collingswood", @"Schenectady", @"Philadelphia", @"Austin", @"San Fransisco", @"Cherry Hill", nil] objectAtIndex: x] forKey:@"City"];
            [participant setObject: [[NSArray arrayWithObjects:@"NJ", @"NJ", @"NY", @"PA", @"TX", @"CA", @"NJ", nil] objectAtIndex: x] forKey:@"State"];
            [participants addObject: participant];
        }*/
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEdit:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addParticipant:)];
    
    [self.navigationItem setLeftBarButtonItem: cancelButton];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editButton, addButton, nil]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:160 YLocation:100];
    else
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:100];

    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    [rli fadeIn];
    
    void (^response)(NSMutableArray *) = ^(NSMutableArray *list){
        self.participants = list;
        if([list count] == 250){
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
    if(row != nil){
        [table deselectRowAtIndexPath:row animated:YES];
        self.row = nil;
    }
}

- (void)createParticipantWithDictionary:(NSDictionary *)dict response:(void (^)(RSUConnectionResponse))responseBlock{
    NSString *key = [NSString stringWithFormat: @"%@ %@", [dict objectForKey:@"LastName"], [dict objectForKey:@"FirstName"]];
    
    NSUInteger rowToAdd = [participants count];
    for(int x = 0; x < [participants count]; x++){
        NSDictionary *partDict = [participants objectAtIndex: x];
        NSString *partKey = [NSString stringWithFormat: @"%@ %@", [partDict objectForKey:@"LastName"], [partDict objectForKey:@"FirstName"]];
        
        if([key compare: partKey] == NSOrderedAscending){
            rowToAdd = x;
            break;
        }
    }
    
    void (^response)(RSUConnectionResponse, NSString *) = ^(RSUConnectionResponse didSucceed, NSString *regID){
        if(didSucceed == RSUSuccess){
            if(regID){
                NSMutableDictionary *newParticipant = [[NSMutableDictionary alloc] initWithDictionary: dict];
                [newParticipant setObject:regID forKey:@"RegistrationID"];
                [participants insertObject:newParticipant atIndex:rowToAdd];
                self.row = [NSIndexPath indexPathForRow:rowToAdd inSection:0];
                [table reloadData];
                [table selectRowAtIndexPath:row animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
        dispatch_async(dispatch_get_main_queue(),^(){responseBlock(didSucceed);});
    };
    
    [[RSUModel sharedModel] addParticipants:[NSArray arrayWithObject:dict] response:response];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    ParticipantTableViewCell *cell = (ParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ParticipantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setEditingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return raceName;
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    ParticipantDetailViewController *participantDetailViewController = [[ParticipantDetailViewController alloc] initWithNibName:@"ParticipantDetailViewController" bundle:nil isCreating:NO];
    [self.navigationController pushViewController:participantDetailViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame: CGRectMake(0, 0, 480, 0)];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
