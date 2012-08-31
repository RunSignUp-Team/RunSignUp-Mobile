//
//  ChuteViewController.m
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

#import "ChuteViewController.h"
#import "RecordTableViewCell.h"
#import "JSON.h"
#import "ZBarSDK.h"
#import "RoundedBarcodeView.h"
#import "RSUModel.h"

@implementation ChuteViewController
@synthesize recordButton;
@synthesize barcodeButton;
@synthesize table;
@synthesize records;
@synthesize fileToSave;
@synthesize raceID;
@synthesize raceName;
@synthesize eventID;
@synthesize eventName;
@synthesize bibField;
@synthesize zbarReaderViewController;
@synthesize numpadView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Chute";
        
        self.fileToSave = @"";
        [self findDestinationFile];
        
        self.zbarReaderViewController = [[ZBarReaderViewController alloc] init];
        zbarReaderViewController.readerDelegate = self;

        RoundedBarcodeView *rbv = [[RoundedBarcodeView alloc] initWithYLocation: 100];
        [zbarReaderViewController.view addSubview: rbv];
    }
    return self;
}

- (void)findDestinationFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:(NSString *)[paths objectAtIndex:0] error:nil];
    
    NSString *currentChuteFile = [[NSUserDefaults standardUserDefaults] stringForKey: @"CurrentChuteFile"];
    if(currentChuteFile != nil){
        self.fileToSave = currentChuteFile;
        NSString *data =  [NSString stringWithContentsOfFile:fileToSave encoding:NSUTF8StringEncoding error:nil];
        
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
    
    [recordButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    [barcodeButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [barcodeButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    [barcodeButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.bibField becomeFirstResponder];
        
    // Set up right bar button (upper right corner) of UINavigationBar to edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopRace:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:editButton, stopButton, nil] animated:YES];
    [editButton release];
    [stopButton release];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.numpadView = [[NumpadView alloc] initWithFrame: CGRectMake(576, 54, 448, 538)];
        [numpadView setTextField: bibField];
        [numpadView setRecordButton: recordButton];
        [self.view addSubview: numpadView];
    }
    
    // Detect differences
    if(![[RSUModel sharedModel] isOffline]){
        void (^response)(RSUDifferences) = ^(RSUDifferences differences){
            currentDifferences = differences;
            [self showDownloadResultsAlert];
        };
        
        [[RSUModel sharedModel] detectDifferencesBetweenLocalAndOnline:(NSArray *)self.records type:2 response:response];
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
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:raceID forKey:@"RaceID"];
    [dict setObject:raceName forKey:@"RaceName"];
    [dict setObject:eventID forKey:@"EventID"];
    [dict setObject:eventName forKey:@"EventName"];
    [dict setObject:[formatter stringFromDate:[NSDate date]] forKey:@"Date"];
    [dict setObject:records forKey:@"Data"];
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"Type"];
    
    NSString *data = [dict JSONRepresentation];
    [data writeToFile:fileToSave atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)record:(id)sender{
    if([records count] < 10000){
        if([[bibField text] length] > 0){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[bibField text], @"Bib", [NSString stringWithFormat:@"%.4i", [records count]+1], @"Place", nil];
            [records insertObject:dict atIndex:0];
            
            if(![[RSUModel sharedModel] isOffline]){
                void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                    if(didSucceed == RSUNoConnection){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                };
                
                [[RSUModel sharedModel] addFinishingBibs:[NSArray arrayWithObject: [bibField text]] response:response];
            }
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentChuteFile"] == nil){
                [[NSUserDefaults standardUserDefaults] setObject:self.fileToSave forKey:@"CurrentChuteFile"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [table beginUpdates];
            [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
            [table endUpdates];
            
            [bibField setText:@""];
            [recordButton setEnabled:NO];
            [self saveToFile];
        }else{
            [recordButton setEnabled: NO];
        }
    }
}

- (IBAction)stopRace:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure you wish to stop adding bib numbers? This will end the race and will not allow you to continue adding at the place you stopped." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
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
            void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
                if(didSucceed == RSUNoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignUp. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }else{
                    [self findDestinationFile];
                }
            };
            
            [[RSUModel sharedModel] deleteResults:RSUClearTimer response:response];
        }else{
            [self showDownloadResultsAlert];
        }
    }else{
        if(buttonIndex == 1){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"CurrentChuteFile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [recordButton setEnabled: NO];
            [barcodeButton setEnabled: NO];
            [bibField setEnabled: NO];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            [UIView beginAnimations:@"Slide" context:nil];
                [recordButton setFrame: CGRectMake(recordButton.frame.origin.x, 365, recordButton.frame.size.width, recordButton.frame.size.height)];
                [barcodeButton setFrame: CGRectMake(barcodeButton.frame.origin.x, 365, barcodeButton.frame.size.width, barcodeButton.frame.size.height)];
                [bibField setFrame: CGRectMake(bibField.frame.origin.x, 365, bibField.frame.size.width, bibField.frame.size.height)];
                [table setFrame: CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 362)];
                [UIView setAnimationDuration: 0.5f];
                [UIView commitAnimations];
            }
        }
    }
}

- (IBAction)barcodeScanner:(id)sender{        
    [self presentModalViewController:zbarReaderViewController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info{
    ZBarSymbolSet *results = [info objectForKey: ZBarReaderControllerResults];
    
    for(ZBarSymbol *symbol in results){
        if([symbol.data length] <= 5 && [symbol.data length] != 0){
            [bibField setText: symbol.data];
            [self record:nil];
            
            RoundedBarcodeView *rbv = (RoundedBarcodeView *)[reader.view viewWithTag: 11];
            [[rbv numberLabel] setText: symbol.data];
            [NSObject cancelPreviousPerformRequestsWithTarget:rbv selector:@selector(fadeIn) object:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:rbv selector:@selector(fadeOut) object:nil];
            [rbv fadeIn];
            [rbv performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0f];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string length] == 1){
        if(textField.text.length < 5 && strchr("1234567890", [string characterAtIndex: 0])){
            [recordButton setEnabled:YES];
            return YES;
        }else{
            return NO;
        }
    }else if([string length] == 0){
        return YES;
    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:2];
        cell.showsReorderControl = YES;
    }
    
    [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Place"]];
    [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [records removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.4f];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    NSString *bibNumberToMove = [[records objectAtIndex:fromIndexPath.row] retain];
    [records removeObject:bibNumberToMove];
    [records insertObject:bibNumberToMove atIndex:toIndexPath.row];
    [bibNumberToMove release];
    
    [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.25f];
    // Above call is a bit of a misnomer, it's actually updating after a cell movement but the function is the same.
}

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

- (void)reuploadResults{
    void (^response)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed){
        if(didSucceed == RSUNoConnection){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [[self recordButton] setEnabled: YES];
        }else{
            void (^response2)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed2){
                if(didSucceed2 == RSUNoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [[self recordButton] setEnabled: YES];
                }else{
                    if([records count] > 0){
                        void (^response3)(RSUConnectionResponse) = ^(RSUConnectionResponse didSucceed3){
                            [[self recordButton] setEnabled: YES];
                            
                            if(didSucceed3 == RSUNoConnection){
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                [alert show];
                                [alert release];
                            }
                        };
                        
                        NSMutableArray *bibs = [[NSMutableArray alloc] init];
                        for(int x = [records count] - 1; x >= 0; x--){
                            [bibs addObject: [[records objectAtIndex: x] objectForKey:@"Bib"]];
                        }
                        
                        [[RSUModel sharedModel] addFinishingBibs:bibs response:response3];
                    }
                }
            };
            [[RSUModel sharedModel] deleteResults:RSUClearResults response:response2];
        }
    };
    
    [[self recordButton] setEnabled: NO];
    [[RSUModel sharedModel] deleteResults:RSUClearChute response:response];
}

- (void)downloadResults{
    if([[RSUModel sharedModel] downloadedRecords]){
        NSMutableArray *downloadedRecords = [[RSUModel sharedModel] downloadedRecords];
        
        if([records count] != 0)
            self.records = [[NSMutableArray alloc] init];
        
        for(int x = 0; x < [downloadedRecords count]; x++){
            NSMutableDictionary *record = [[NSMutableDictionary alloc] init];
            [record setObject:[NSString stringWithFormat:@"%.4i", x + 1] forKey:@"Place"];
            [record setObject:[downloadedRecords objectAtIndex: x] forKey:@"Bib"];
            [records insertObject:record atIndex:0];
        }
        
        [table reloadData];
        [self saveToFile];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No results could be downloaded." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Place                           Bib #";
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
