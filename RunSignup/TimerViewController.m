//
//  TimerViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerViewController.h"
#import "RecordTableViewCell.h"
#import "JSON.h"

@implementation TimerViewController
@synthesize startButton;
@synthesize recordButton;
@synthesize table;
@synthesize records;
@synthesize timerLabel;
@synthesize raceID;
@synthesize raceName;
@synthesize fileToSave;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Timer";
        started = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:(NSString *)[paths objectAtIndex:0] error:nil];
        self.fileToSave = @"";
        
        int number = 0;
        while(YES){
            BOOL numberIsAvailable = YES;
            for(NSString *string in files){
                if([string isEqualToString:[NSString stringWithFormat:@"%i.json", number]]){
                    numberIsAvailable = NO;
                }
            }
            if(numberIsAvailable){
                self.fileToSave = [NSString stringWithFormat:@"%@/%i.json", [paths objectAtIndex:0], number];
                break;
            }
            number++;
        }
        
        self.records = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.timerLabel = [[TimerLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 92)];
    [self.view addSubview: timerLabel];
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:24];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:24];
    UIImage *redButtonImage = [UIImage imageNamed:@"RedButton.png"];
    UIImage *stretchedRedButton = [redButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:24];
    UIImage *redButtonTapImage = [UIImage imageNamed:@"RedButtonTap.png"];
    UIImage *stretchedRedButtonTap = [redButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:24];
    UIImage *grayButtonImage = [UIImage imageNamed:@"GrayButton.png"];
    UIImage *stretchedGrayButton = [grayButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:24];
    
    [startButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [startButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    
    // Set up right bar button (upper right corner) of UINavigationBar to edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    [editButton release];
        
    // Check for user setting "BigRecordButton"
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"]){        
        [startButton.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [table setFrame:CGRectMake(0, 241, 320, 175)];
        [startButton setFrame:CGRectMake(9, 100, 80, 133)];
        [recordButton setFrame:CGRectMake(97, 100, 216, 133)];
    }
         
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)toggleEditing{
    if(table.editing){
        [table setEditing:NO animated:YES];
    }else{
        [table setEditing:YES animated:YES];
    }
}

- (void)saveToFile{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:raceID forKey:@"RaceID"];
    [dict setObject:raceName forKey:@"RaceName"];
    [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Date"];
    [dict setObject:records forKey:@"Data"];
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"Type"];

    NSString *data = [dict JSONRepresentation];
    [data writeToFile:fileToSave atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// Record current time to next place in list
- (IBAction)record:(id)sender{
    if([records count] < 10000){
        NSTimeInterval elapsedTime = [timerLabel elapsedTime];
        NSString *formattedTime = [timerLabel formattedTime];
        NSString *place = [NSString stringWithFormat:@"%.4i", [records count]+1];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:elapsedTime],@"Time",formattedTime,@"FTime",place,@"Place",nil];
        [records insertObject:dict atIndex:0];
        [dict release];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [table beginUpdates];
        [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
        [table endUpdates];
        [self saveToFile];
    }
}

// Start timer and begin race
- (IBAction)start:(id)sender{
    if(!started){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"]){
            [startButton setTitle:@"End\nRace" forState:UIControlStateNormal];
        }else{
            [startButton setTitle:@"End Race" forState:UIControlStateNormal];
        }
        started = YES;
        [timerLabel startTiming];
        [recordButton setEnabled:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stop Timer" message:@"Are you sure you wish to stop the timer? This will end the race and will not allow you to continue timing at the place you stopped." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", nil];
        [alert show];
        [alert release];
    }
}

// Delegate method for making sure the user actually wants to end the race
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [timerLabel stopTiming];
        [recordButton setEnabled:NO];
        started = NO;
        [startButton setTitle:@"Restart" forState:UIControlStateNormal];
    }
}

// Create a blank cell for displaying a time paired with a place
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:0];
    
    [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Place"]];
    [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"FTime"]];
    
    return cell;
}

// Commit the deletion of a row
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [records removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.4f];
    }
}

// Reload only the visible cells' place numbers after a deletion
- (void)updateRecordNumbersAfterDeletion{
    for(int x = 0; x < [records count]; x++){
        [[records objectAtIndex: x] setObject:[NSString stringWithFormat:@"%.4i", [records count] - x] forKey:@"Place"];
    }
    
    NSArray *cells = [table visibleCells];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (UITableViewCell *cell in cells) {
        [indexPaths addObject:[table indexPathForCell:cell]];
    }
    [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [indexPaths release];
    
    [self saveToFile];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Place                      Time";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [records count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
