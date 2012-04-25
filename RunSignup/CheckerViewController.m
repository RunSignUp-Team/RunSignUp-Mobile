//
//  CheckerViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckerViewController.h"
#import "RecordTableViewCell.h"

@implementation CheckerViewController
@synthesize startButton;
@synthesize closeNumpadButton;
@synthesize recordButton;
@synthesize table;
@synthesize records;
@synthesize timerLabel;
@synthesize bibField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Checker";
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
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *redButtonImage = [UIImage imageNamed:@"RedButton.png"];
    UIImage *stretchedRedButton = [redButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *redButtonTapImage = [UIImage imageNamed:@"RedButtonTap.png"];
    UIImage *stretchedRedButtonTap = [redButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *grayButtonImage = [UIImage imageNamed:@"GrayButton.png"];
    UIImage *stretchedGrayButton = [grayButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [startButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [startButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [closeNumpadButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [closeNumpadButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    [editButton release];
    
    [self.table setRowHeight: 54.0f];
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
        if([[bibField text] length] > 0 && started){
            NSDictionary *record = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%.5i", [[bibField text] intValue]], @"Bib", [timerLabel formattedTime], @"Time", nil];
            [records insertObject:record atIndex:0];
            [record release];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [table beginUpdates];
            [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
            [table endUpdates];
            
            [self hideCloseNumpadButton:nil];
        }
    }
}

- (IBAction)start:(id)sender{
    if(!started){
        [startButton setTitle:@"End Race" forState:UIControlStateNormal];
        started = YES;
        [timerLabel startTiming];
        if([[bibField text] length] > 0)
            [recordButton setEnabled:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stop Timer" message:@"Are you sure you wish to stop the timer? This will end the race and will not allow you to continue timing at the place you stopped." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)showCloseNumpadButton:(id)sender{
    [closeNumpadButton setFrame: CGRectMake(320, 149, 150, 46)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.25f];
    [closeNumpadButton setFrame: CGRectMake(165, 149, 150, 46)];
    [startButton setFrame: CGRectMake(8, 149, 150, 46)];
    [UIView commitAnimations];
}

- (IBAction)hideCloseNumpadButton:(id)sender{
    [bibField resignFirstResponder];
    [bibField setText:@""];
    [recordButton setEnabled: NO];
    [closeNumpadButton setFrame: CGRectMake(165, 149, 150, 46)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.25f];
    [closeNumpadButton setFrame: CGRectMake(320, 149, 150, 46)];
    [startButton setFrame: CGRectMake(8, 149, 307, 46)];
    [UIView commitAnimations];
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
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:2];
    
    [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Time"]];
    
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string length] != 0){
        if(textField.text.length < 5 && strchr("1234567890-", [string characterAtIndex: 0])){
            if(started)
                [recordButton setEnabled: YES];
            return YES;
        }else{
            return NO;
        }
    }else{
        if([[textField text] length] == 1)
            [recordButton setEnabled: NO];
        return YES;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Bib #                      Time";
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
