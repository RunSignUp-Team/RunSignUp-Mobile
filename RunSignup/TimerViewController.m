//
//  TimerViewController.m
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

#import "TimerViewController.h"
#import "RecordTableViewCell.h"
#import "RSUModel.h"
#import "JSON.h"

@implementation TimerViewController
@synthesize startButton;
@synthesize recordButton;
@synthesize table;
@synthesize records;
@synthesize timerLabel;
@synthesize raceID;
@synthesize raceName;
@synthesize eventID;
@synthesize eventName;
@synthesize fileToSave;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Timer";
        started = NO;
        
        self.fileToSave = @"";
        
        [self findDestinationFile];
    }
    return self;
}

- (void)findDestinationFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:(NSString *)[paths objectAtIndex:0] error:nil];
    
    NSString *currentTimerFile = [[NSUserDefaults standardUserDefaults] stringForKey: @"CurrentTimerFile"];
    if(currentTimerFile != nil){
        self.fileToSave = currentTimerFile;
        NSString *data =  [NSString stringWithContentsOfFile:fileToSave encoding:NSUTF8StringEncoding error:nil];
        started = YES;
        if(data != nil){
            self.records = (NSMutableArray *)[(NSDictionary *)[data JSONValue] objectForKey:@"Data"];
            if([records count] == 0){
                self.records = [[NSMutableArray alloc] init];
            }
        }else{
            if([[RSUModel sharedModel] isOffline]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"We detected a timing in progress, but were unable to load the data. The timer will not be reset." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            
            self.records = [[NSMutableArray alloc] init];
        }
    }else{
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
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIExtendedEdgeNone];
    
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
    [startButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    [recordButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    
    // Set up right bar button (upper right corner) of UINavigationBar to edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    [editButton release];
        
    // Check for user setting "BigRecordButton"
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"] && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){        
        [startButton.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
        [table setFrame:CGRectMake(0, 241, 320, 175)];
        [startButton setFrame:CGRectMake(9, 100, 80, 133)];
        [recordButton setFrame:CGRectMake(97, 100, 216, 133)];
    }
    
    // If started has already been set, then we know theres a timer in progress
    if(started){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"]){
            [startButton setTitle:@"End\nRace" forState:UIControlStateNormal];
        }else{
            [startButton setTitle:@"End Race" forState:UIControlStateNormal];
        }
        
        [timerLabel startTiming];
        [timerLabel setStartDate: [[NSUserDefaults standardUserDefaults] objectForKey: @"TimerStartDate"]];
        [recordButton setEnabled:YES];
    }
    
    // Detect differences
    if(![[RSUModel sharedModel] isOffline]){
        void (^response)(RSUDifferences) = ^(RSUDifferences differences){
            currentDifferences = differences;
            [self showDownloadResultsAlert];
            [startButton setEnabled: YES];
        };
        
        [[RSUModel sharedModel] detectDifferencesBetweenLocalAndOnline:(NSArray *)self.records type:0 response:response];
    }else{
        [startButton setEnabled: YES];
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

- (void)saveStartDate{
    [[NSUserDefaults standardUserDefaults] setObject:[timerLabel startDate] forKey:@"TimerStartDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(![[RSUModel sharedModel] isOffline]){
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setTimeZone: [[NSTimeZone alloc] initWithName:@"Eastern Standard Time"]];
        [formatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate: [timerLabel startDate]];
        NSLog(@"DateString: %@", dateString);
        
        void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
            if(didSucceed == RSUNoConnection){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        };
        
        [[RSUModel sharedModel] recordStartDateOfTimer:dateString response:response];
    }
}

- (void)saveToFile{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:raceID forKey:@"RaceID"];
    [dict setObject:raceName forKey:@"RaceName"];
    [dict setObject:eventID forKey:@"EventID"];
    [dict setObject:eventName forKey:@"EventName"];
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
        
        if(![[RSUModel sharedModel] isOffline]){
            void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                if(didSucceed == RSUNoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            };
            
            [[RSUModel sharedModel] addFinishingTimes:[NSArray arrayWithObject: formattedTime] response:response];
        }
        
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
        [self saveStartDate];
        [[NSUserDefaults standardUserDefaults] setObject:self.fileToSave forKey:@"CurrentTimerFile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [recordButton setEnabled:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stop Timer" message:@"Are you sure you wish to stop the timer? This will end the race and will not allow you to continue timing at the place you stopped." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", nil];
        [alert show];
        [alert release];
    }
}

- (void)showDownloadResultsAlert{
    if(currentDifferences == RSUDifferencesNoConnection){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect to RunSignUp. The data on your device and on the server for this event may not be in sync." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(currentDifferences == RSUDifferencesBothDifferent){
        downloadResultsAlert = [[UIAlertView alloc] initWithTitle:@"Data out of sync" message:@"The data on your device and on the results server is different. Would you like to download the server's results or upload yours?" delegate:self cancelButtonTitle:@"Download Results" otherButtonTitles:@"Delete Data", @"Upload Results", nil];
        [downloadResultsAlert show];
        [downloadResultsAlert release];
        NSLog(@"Server and client both have different numbers of records and neither is empty");
    }else if(currentDifferences == RSUDifferencesClientEmpty){
        downloadResultsAlert = [[UIAlertView alloc] initWithTitle:@"Data out of sync" message:@"The results server has data for this event, but your device has none. Would you like to download the server's results and continue timing from there?" delegate:self cancelButtonTitle:@"Yes, download" otherButtonTitles:@"Delete Data", nil];
        [downloadResultsAlert show];
        [downloadResultsAlert release];
        NSLog(@"Server has data, client has none");
    }else if(currentDifferences == RSUDifferencesServerEmpty){
        downloadResultsAlert = [[UIAlertView alloc] initWithTitle:@"Data out of sync" message:@"Your device has data for this event, but the server has none. Would you like to upload your results and continue timing from there?" delegate:self cancelButtonTitle:@"Yes, upload" otherButtonTitles:@"Delete data", nil];
        [downloadResultsAlert show];
        [downloadResultsAlert release];
        NSLog(@"Client has data, server has none");
    }else{
        NSLog(@"No differences between server and client");
    }
}

// Delegate method for making sure the user actually wants to end the race
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"Button: %i", buttonIndex);
    if(alertView == downloadResultsAlert){
        if(buttonIndex == 0){
            if(currentDifferences == RSUDifferencesBothDifferent || currentDifferences == RSUDifferencesClientEmpty){
                [self downloadResults];
            }else{
                [self reuploadResults];
            }
        }else if(buttonIndex == 1){
            deleteResultsAlert = [[UIAlertView alloc] initWithTitle:@"Delete Results?" message:@"Are you sure you wish to delete all timing data for this event on the server and on your device?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [deleteResultsAlert show];
            [deleteResultsAlert release];
        }else if(buttonIndex == 2){
            [self reuploadResults];
        }
    }else if(alertView == deleteResultsAlert){
        if(buttonIndex == 1){
            if(![[RSUModel sharedModel] isOffline]){
                void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                    if(didSucceed == RSUNoConnection){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }else{
                        if(records && [records count] == 0)
                            [self findDestinationFile];
                        else{
                            started = YES;
                            [self start: nil]; // end race
                        }
                    }
                };
                
                [[RSUModel sharedModel] deleteResults:RSUClearTimer response:response];
            }
        }else{
            // User did not want to delete, send them back to the previous menu
            [self showDownloadResultsAlert];
        }
    }else{
        if(buttonIndex == 1){
            [timerLabel stopTiming];
            [recordButton setEnabled: NO];
            [startButton setEnabled: NO];
            started = NO;
            
            [UIView beginAnimations:@"Slide" context:nil];
            [table setFrame: CGRectMake(0, 92, 320, 388)];
            [UIView commitAnimations];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"TimerStartDate"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"CurrentTimerFile"];
            [[NSUserDefaults standardUserDefaults] synchronize];        
        }
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
    if(![[RSUModel sharedModel] isOffline]){
        [self reuploadResults];
    }
}

- (void)downloadResults{
    if([[RSUModel sharedModel] downloadedRecords]){
        NSMutableArray *downloadedRecords = [[RSUModel sharedModel] downloadedRecords];
        
        if([records count] != 0)
            self.records = [[NSMutableArray alloc] init];
        
        for(int x = 0; x < [downloadedRecords count]; x++){
            NSMutableDictionary *record = [[NSMutableDictionary alloc] init];
            [record setObject:[NSString stringWithFormat:@"%.4i", x + 1] forKey:@"Place"];
            [record setObject:[downloadedRecords objectAtIndex: x] forKey:@"FTime"];
            [records insertObject:record atIndex:0];
        }
        
        [table reloadData];
        [self saveToFile];
        
        void (^response)(RSUConnectionResponse, NSString *) = ^(RSUConnectionResponse didSucceed, NSString *startDate){
            if(didSucceed == RSUNoConnection || startDate == nil){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else{
                NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                [formatter setTimeZone: [[NSTimeZone alloc] initWithName:@"Eastern Standard Time"]];
                [formatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
                
                NSDate *date = [formatter dateFromString: startDate];
                if(date != nil){
                    [timerLabel startTiming];
                    [timerLabel setStartDate: date];
                    
                    started = YES;
                    
                    if([[NSUserDefaults standardUserDefaults] boolForKey:@"BigRecordButton"]){
                        [startButton setTitle:@"End\nRace" forState:UIControlStateNormal];
                    }else{
                        [startButton setTitle:@"End Race" forState:UIControlStateNormal];
                    }
                    
                    [recordButton setEnabled:YES];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"TimerStartDate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        };
        
        [[RSUModel sharedModel] retrieveStartDateOfTimer: response];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No results could be downloaded." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)reuploadResults{
    void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
        if(didSucceed == RSUNoConnection){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [[self recordButton] setEnabled: YES];
        }else{
            void (^response2)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed2){
                if(didSucceed2 == RSUNoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [[self recordButton] setEnabled: YES];
                }else{
                    if([records count] > 0){
                        void (^response3)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed3){
                            [[self recordButton] setEnabled: YES];
                            if(didSucceed3 == RSUNoConnection){
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                [alert show];
                                [alert release];
                            }
                        };
                        
                        NSMutableArray *formattedTimes = [[NSMutableArray alloc] init];
                        for(int x = [records count] - 1; x >= 0; x--){
                            [formattedTimes addObject: [[records objectAtIndex: x] objectForKey:@"FTime"]];
                        }
                        
                        [[RSUModel sharedModel] addFinishingTimes:formattedTimes response:response3];
                    }
                }
            };
            [[RSUModel sharedModel] deleteResults:RSUClearResults response:response2];
        }
    };
    
    [[self recordButton] setEnabled: NO];
    [[RSUModel sharedModel] deleteResults:RSUClearTimer response:response];
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
