//
//  TimerViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerViewController.h"
#import "RecordTableViewCell.h"

@implementation TimerViewController
@synthesize startButton;
@synthesize recordButton;
@synthesize table;
@synthesize records;
@synthesize timerLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Timer";
        started = NO;
        
        self.records = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.timerLabel = [[TimerLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 92)];
    [self.view addSubview: timerLabel];
    
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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    [editButton release];
    
    [self.table setRowHeight: 54.0f];
    
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

- (IBAction)record:(id)sender{
    if([records count] < 10000){
        [records insertObject:[timerLabel formattedTime] atIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [table beginUpdates];
        [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
        [table endUpdates];
    }
}

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

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [timerLabel stopTiming];
        [recordButton setEnabled:NO];
        started = NO;
        [startButton setTitle:@"Restart" forState:UIControlStateNormal];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:0];
    
    [[cell textLabel] setText: [NSString stringWithFormat:@"%.4i", [records count] - indexPath.row]];
    [[cell dataLabel] setText: [records objectAtIndex: indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [records removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.4f];
    }
}

- (void)updateRecordNumbersAfterDeletion{
    NSArray *cells = [table visibleCells];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (UITableViewCell *cell in cells) {
        [indexPaths addObject:[table indexPathForCell:cell]];
    }
    [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [indexPaths release];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
