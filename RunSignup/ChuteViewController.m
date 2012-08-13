//
//  ChuteViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
        
        self.zbarReaderViewController = [[ZBarReaderViewController alloc] init];
        zbarReaderViewController.readerDelegate = self;

        RoundedBarcodeView *rbv = [[RoundedBarcodeView alloc] initWithYLocation: 100];
        [zbarReaderViewController.view addSubview: rbv];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(![[RSUModel sharedModel] isOffline]){
        void (^response)(int) = ^(int didSucceed){
            if(didSucceed == NoConnection){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        };
        
        // Clear existing (if any) chute data currently in the individual_result_set
        [[RSUModel sharedModel] deleteResults:ClearChute response:response];
    }
    
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

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.bibField becomeFirstResponder];
        
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
    [dict setObject:[NSNumber numberWithInt:2] forKey:@"Type"];
    
    NSString *data = [dict JSONRepresentation];
    [data writeToFile:fileToSave atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (IBAction)record:(id)sender{
    if([records count] < 10000){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[bibField text], @"Bib", [NSString stringWithFormat:@"%.4i", [records count]+1], @"Place", nil];
        [records insertObject:dict atIndex:0];
        
        if(![[RSUModel sharedModel] isOffline]){
            void (^response)(int) = ^(int didSucceed){
                if(didSucceed == NoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
            };
            
            [[RSUModel sharedModel] addFinishingBibs:[NSArray arrayWithObject: [bibField text]] response:response];
        }
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [table beginUpdates];
        [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
        [table endUpdates];
        
        [bibField setText:@""];
        [recordButton setEnabled:NO];
        [self saveToFile];
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
    if([string length] != 0){
        if(textField.text.length < 5 && strchr("1234567890", [string characterAtIndex: 0])){
            [recordButton setEnabled:YES];
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
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

- (void)reuploadResults{
    void (^response)(int) = ^(int didSucceed){
        if(didSucceed == NoConnection){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [[self recordButton] setEnabled: YES];
        }else{
            void (^response2)(int) = ^(int didSucceed2){
                if(didSucceed2 == NoConnection){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was a problem establishing a connection with RunSignup. Please try again." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    [[self recordButton] setEnabled: YES];
                }else{
                    void (^response3)(int) = ^(int didSucceed3){
                        [[self recordButton] setEnabled: YES];
                        
                        if(didSucceed3 == NoConnection){
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
            };
            [[RSUModel sharedModel] deleteResults:ClearResults response:response2];
        }
    };
    
    [[self recordButton] setEnabled: NO];
    [[RSUModel sharedModel] deleteResults:ClearChute response:response];
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
