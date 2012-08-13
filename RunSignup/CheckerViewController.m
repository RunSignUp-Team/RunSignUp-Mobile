//
//  CheckerViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckerViewController.h"
#import "RecordTableViewCell.h"
#import "JSON.h"

@implementation CheckerViewController
@synthesize startButton;
@synthesize closeNumpadButton;
@synthesize recordButton;
@synthesize table;
@synthesize records;
@synthesize timerLabel;
@synthesize raceID;
@synthesize raceName;
@synthesize eventID;
@synthesize eventName;
@synthesize fileToSave;
@synthesize bibField;
@synthesize numpadView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Checker";
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
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *redButtonImage = [UIImage imageNamed:@"RedButton.png"];
    UIImage *stretchedRedButton = [redButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *redButtonTapImage = [UIImage imageNamed:@"RedButtonTap.png"];
    UIImage *stretchedRedButtonTap = [redButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *grayButtonImage = [UIImage imageNamed:@"GrayButton.png"];
    UIImage *stretchedGrayButton = [grayButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [startButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [startButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [closeNumpadButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [closeNumpadButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    }
    [recordButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [bibField becomeFirstResponder];
    
    // Set up right bar button (upper right corner) of UINavigationBar to edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    [editButton release];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.numpadView = [[NumpadView alloc] initWithFrame: CGRectMake(576, 54, 448, 538)];
        [numpadView setTextField: bibField];
        [numpadView setRecordButton: recordButton];
        [self.view addSubview: numpadView];
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
    [dict setObject:eventID forKey:@"EventID"];
    [dict setObject:eventName forKey:@"EventName"];
    [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Date"];
    [dict setObject:records forKey:@"Data"];
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"Type"];
    
    NSString *data = [dict JSONRepresentation];
    [data writeToFile:fileToSave atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// Record current time and bib number to list
- (IBAction)record:(id)sender{
    if([records count] < 10000){
        if(started){
            if([[bibField text] length] > 0){
                NSTimeInterval elapsedTime = [timerLabel elapsedTime];
                NSString *formattedTime = [timerLabel formattedTime];
                NSMutableDictionary *record = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[bibField text], @"Bib", formattedTime, @"FTime", [NSNumber numberWithDouble:elapsedTime], @"Time", nil];
                [records insertObject:record atIndex:0];
                [record release];
                [self hideCloseNumpadButton:nil];
            }else{
                NSTimeInterval elapsedTime = [timerLabel elapsedTime];
                NSString *formattedTime = [timerLabel formattedTime];
                NSMutableDictionary *record = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"", @"Bib", formattedTime, @"FTime", [NSNumber numberWithDouble:elapsedTime], @"Time", nil];
                [records insertObject:record atIndex:0];
                [record release];
                
                EditBibViewController *editBibViewController = [[EditBibViewController alloc] initWithNibName:@"EditBibViewController" bundle:nil];
                [editBibViewController setBibNumber: @""];
                [editBibViewController setDelegate: self];
                [editBibViewController setIndexPath: [NSIndexPath indexPathForRow:0 inSection:0]];
                [self presentModalViewController:editBibViewController animated:YES];
                [editBibViewController release];
            }
                
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [table beginUpdates];
            [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
            [table endUpdates];
            
            [bibField setText:@""];
            //[recordButton setEnabled: NO];
            [self saveToFile];
        }
    }
}

// Begin race and update buttons to reflect this
- (IBAction)start:(id)sender{
    if(!started){
        [startButton setTitle:@"End Race" forState:UIControlStateNormal];
        started = YES;
        [timerLabel startTiming];
        [recordButton setEnabled:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stop Timer" message:@"Are you sure you wish to stop the timer? This will end the race and will not allow you to continue timing at the place you stopped." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)showCloseNumpadButton:(id)sender{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [closeNumpadButton setFrame: CGRectMake(320, 149, 150, 46)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.25f];
        [closeNumpadButton setFrame: CGRectMake(165, 149, 150, 46)];
        [recordButton setFrame: CGRectMake(6, 149, 150, 46)];
        [UIView commitAnimations];
    }
}

- (IBAction)hideCloseNumpadButton:(id)sender{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [bibField resignFirstResponder];
        [closeNumpadButton setFrame: CGRectMake(165, 149, 150, 46)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.25f];
        [closeNumpadButton setFrame: CGRectMake(320, 149, 150, 46)];
        [recordButton setFrame: CGRectMake(6, 149, 308, 46)];
        [UIView commitAnimations];
    }
}

// Delegate method for making sure the user really wants to end the race
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [timerLabel stopTiming];
        [recordButton setEnabled:NO];
        started = NO;
        [startButton setTitle:@"Restart" forState:UIControlStateNormal];
    }
}

// Create empty cell for displaying a bib paired with a time
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:1];
    
    if([[[records objectAtIndex: indexPath.row] objectForKey: @"Bib"] isEqualToString: @""]){
        [[cell textLabel] setText: @"No Bib"];
    }else{
        [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    }
    
    [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"FTime"]];
    [cell setAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}

// Commit a cell deletion
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [records removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EditBibViewController *editBibViewController = [[EditBibViewController alloc] initWithNibName:@"EditBibViewController" bundle:nil];
    [editBibViewController setBibNumber: [[records objectAtIndex: indexPath.row] objectForKey: @"Bib"]];
    [editBibViewController setDelegate: self];
    [editBibViewController setIndexPath: indexPath];
    [self presentModalViewController:editBibViewController animated:YES];
    [editBibViewController release];
}

- (void)didSaveBib:(NSString *)bib withIndex:(NSIndexPath *)indexPath{
    [[records objectAtIndex: indexPath.row] setObject:bib forKey:@"Bib"];
    NSArray *indexArray = [NSArray arrayWithObject: indexPath];
    [table reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    [self saveToFile];
    
    [self performSelector:@selector(hideCloseNumpadButton:) withObject:nil afterDelay:0.05f];
}

// Limit what the user can enter to the string "1234567890"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string length] != 0){
        if(textField.text.length < 5 && strchr("1234567890", [string characterAtIndex: 0])){
            /*if(started)
                [recordButton setEnabled: YES];*/
            return YES;
        }else{
            return NO;
        }
    }else{
        /*if([[textField text] length] == 1)
            [recordButton setEnabled: NO];*/
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
