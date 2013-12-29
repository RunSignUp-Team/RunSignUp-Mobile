//
//  ArchiveDetailViewController.m
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

#import "ArchiveDetailViewController.h"
#import "RecordTableViewCell.h"
#import "ArchiveEditCellViewController.h"
#import "JSON.h"
#import <MessageUI/MessageUI.h>

@implementation ArchiveDetailViewController
@synthesize nameLabel;
@synthesize raceIDLabel;
@synthesize eventIDLabel;
@synthesize eventIDHintLabel;
@synthesize dateLabel;
@synthesize typeLabel;
@synthesize shareButton;
@synthesize table;
@synthesize records;
@synthesize file;
@synthesize fileDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Details";
        self.records = nil;
        self.file = nil;
        
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEdit)];
        [self.navigationItem setRightBarButtonItem: editItem];
        [editItem release];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    
    UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
    UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
    UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    
    [shareButton setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
    [shareButton setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
    
    NSString *data = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    self.fileDict = [data JSONValue];
    self.records = [fileDict objectForKey:@"Data"];
    
    [nameLabel setText: [fileDict objectForKey:@"RaceName"]];
    NSString *raceID = [fileDict objectForKey:@"RaceID"];
    NSString *eventID = [fileDict objectForKey:@"EventID"];
    
    if([raceID isEqualToString: @"0000"]){
        [raceIDLabel setText:@"Offline Race"];
        [eventIDHintLabel setHidden: YES];
        [eventIDLabel setHidden: YES];
        [raceIDLabel setFrame: CGRectMake(raceIDLabel.frame.origin.x, raceIDLabel.frame.origin.y, 190, raceIDLabel.frame.size.height)];
    }else{
        [raceIDLabel setText:raceID];
        [eventIDLabel setText:eventID];
    }
    
    [dateLabel setText: [fileDict objectForKey:@"Date"]];
    if([[fileDict objectForKey:@"Type"] intValue] == 0){
        [typeLabel setText:@"Timer (Place # and Time)"];
    }else if([[fileDict objectForKey:@"Type"] intValue] == 1){
        [typeLabel setText:@"Checker (Bib # and Time)"];
    }else{
        [typeLabel setText:@"Chute (Place # and Bib #)"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:[[fileDict objectForKey:@"Type"] intValue]];
    
    /*UIImageView *editAccessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"EditIcon.png"]];
    [cell setAccessoryView: editAccessoryView];*/
    
    // !!! Uncomment here to enable buggy individual row editing !!! //
    //[cell setEditingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
    // !!! Uncomment here to enable buggy individual row editing !!! //
    
    if([[fileDict objectForKey:@"Type"] intValue] == 0){
        [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Place"]];
        [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"FTime"]];
    }else if([[fileDict objectForKey:@"Type"] intValue] == 1){
        [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
        [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"FTime"]];
    }else{
        [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Place"]];
        [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([[fileDict objectForKey:@"Type"] intValue] == 0){
        return @"Place                      Time";
    }else if([[fileDict objectForKey:@"Type"] intValue] == 1){
        return @"Bib #                      Time";
    }else{
        return @"Place                      Bib #";
    }
}

- (void)saveToFile{
    [fileDict setObject:records forKey:@"Data"];
    NSString *data = [fileDict JSONRepresentation];
    [data writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete && file != nil){
        [records removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.4f];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return ([[fileDict objectForKey:@"Type"] intValue] == 2);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    if([[fileDict objectForKey:@"Type"] intValue] == 2){
        NSString *bibNumberToMove = [[records objectAtIndex:fromIndexPath.row] retain];
        [records removeObject:bibNumberToMove];
        [records insertObject:bibNumberToMove atIndex:toIndexPath.row];
        [bibNumberToMove release];
        
        [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.25f];
        // Above call is a bit of a misnomer, it's actually updating after a cell movement but the function is the same.
    }
}

- (void)updateRecordNumbersAfterDeletion{
    if([[fileDict objectForKey:@"Type"] intValue] == 0 || [[fileDict objectForKey:@"Type"] intValue] == 2){
        for(int x = 0; x < [records count]; x++){
            [[records objectAtIndex: x] setObject:[NSString stringWithFormat:@"%.4i", [records count] - x] forKey:@"Place"];
        }
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    ArchiveEditCellViewController *archiveEditCellViewController = [[ArchiveEditCellViewController alloc] initWithNibName:@"ArchiveEditCellViewController" bundle:nil type:[[fileDict objectForKey:@"Type"] intValue]];
    if([[fileDict objectForKey:@"Type"] intValue] == 0){
        [archiveEditCellViewController setTime: [[[records objectAtIndex: indexPath.row] objectForKey:@"Time"] doubleValue]];
        [archiveEditCellViewController setPlace: [[records objectAtIndex: indexPath.row] objectForKey:@"Place"]];
    }else if([[fileDict objectForKey:@"Type"] intValue] == 1){
        [archiveEditCellViewController setTime: [[[records objectAtIndex: indexPath.row] objectForKey:@"Time"] doubleValue]];
        [archiveEditCellViewController setBib: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    }else{
        [archiveEditCellViewController setPlace: [[records objectAtIndex: indexPath.row] objectForKey:@"Place"]];
        [archiveEditCellViewController setBib: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
    }
    
    [archiveEditCellViewController setDelegate: self];
    [archiveEditCellViewController setIndex: indexPath];
    [self.navigationController pushViewController:archiveEditCellViewController animated:YES];
    [archiveEditCellViewController release];
}

- (void)updateRow:(NSIndexPath *)indexPath withDict:(NSMutableDictionary *)updateDict{
    if([[fileDict objectForKey:@"Type"] intValue] == 0 || [[fileDict objectForKey:@"Type"] intValue] == 1){
        [records removeObjectAtIndex:indexPath.row];
        double time = [[updateDict objectForKey:@"Time"] doubleValue];
        int lowestIndex;
        for(lowestIndex = 0; lowestIndex < [records count]; lowestIndex++){
            if(time < [[[records objectAtIndex: lowestIndex] objectForKey:@"Time"] doubleValue]){
                break;
            }
        }
        
        NSLog(@"%i", lowestIndex);
        [records insertObject:updateDict atIndex:lowestIndex];
        [self updateRecordNumbersAfterDeletion];
        // Not after a deletion, but function is the same
    }else{
        [records replaceObjectAtIndex:indexPath.row withObject:updateDict];
    }
    [self saveToFile];
    [table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [records count];
}

- (IBAction)share:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"E-mail"/*, @"Upload to RunSignUp"*/, nil];
    [actionSheet showInView: self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
            
            int type = [[fileDict objectForKey: @"Type"] intValue];
            NSString *typeString;
            if(type == 0){
                typeString = @"Timer";
            }else if(type == 1){
                typeString = @"Checker";
            }else{
                typeString = @"Chute";
            }
            [mailComposeViewController setSubject: [NSString stringWithFormat:@"Race Results For %@", [fileDict objectForKey:@"RaceName"]]];
            [mailComposeViewController setMailComposeDelegate: self];
            
            NSString *body = [NSString stringWithFormat: @"Race Name: %@\nEvent Name: %@\n\n", [fileDict objectForKey:@"RaceName"], [fileDict objectForKey:@"EventName"]];
            if(type == 0){
                body = [body stringByAppendingString:@"Place | Time\n"];
            }else if(type == 1){
                body = [body stringByAppendingString:@"Bib | Time\n"];
            }else{
                body = [body stringByAppendingString:@"Place | Bib\n"];
            }
            
            for(int x = 0; x < [records count]; x++){
                if(type == 0)
                    body = [body stringByAppendingFormat: @"%@  | %@\n", [[records objectAtIndex: x] objectForKey:@"Place"], [[records objectAtIndex: x] objectForKey:@"FTime"]];
                else if(type == 1)
                    body = [body stringByAppendingFormat: @"%@ | %@\n", [[records objectAtIndex: x] objectForKey:@"Bib"], [[records objectAtIndex: x] objectForKey:@"FTime"]];
                else
                    body = [body stringByAppendingFormat: @"%@ | %@\n", [[records objectAtIndex: x] objectForKey:@"Place"], [[records objectAtIndex: x] objectForKey:@"Bib"]];    
            }
            [mailComposeViewController setMessageBody:body isHTML: NO];
            
            NSString *csvString;
            if(type == 0){
                csvString = @"Place,FTime,Time\n";
                for(int x = 0; x < [records count]; x++){
                    csvString = [csvString stringByAppendingFormat:@"%@,%@,%@\n", [[records objectAtIndex: x] objectForKey:@"Place"], [[records objectAtIndex: x] objectForKey:@"FTime"], [[records objectAtIndex: x] objectForKey:@"Time"]];
                }
            }else if(type == 1){
                csvString = @"Bib,FTime,Time\n";
                for(int x = 0; x < [records count]; x++){
                    csvString = [csvString stringByAppendingFormat:@"%@,%@,%@\n", [[records objectAtIndex: x] objectForKey:@"Bib"], [[records objectAtIndex: x] objectForKey:@"FTime"], [[records objectAtIndex: x] objectForKey:@"Time"]];
                }
            }else{
                csvString = @"Place,Bib\n";
                for(int x = 0; x < [records count]; x++){
                    csvString = [csvString stringByAppendingFormat:@"%@,%@\n", [[records objectAtIndex: x] objectForKey:@"Place"], [[records objectAtIndex: x] objectForKey:@"Bib"]];
                }
            }
            
            NSData *jsonData = [[records JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
            NSData *csvData = [csvString dataUsingEncoding: NSUTF8StringEncoding];
            [mailComposeViewController addAttachmentData:jsonData mimeType:@"text/plain" fileName:@"Results.json"];
            [mailComposeViewController addAttachmentData:csvData mimeType:@"text/plain" fileName:@"Results.csv"];
            
            [self presentModalViewController:mailComposeViewController animated:YES];
            [mailComposeViewController release];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device can not send mail, try uploading through RunSignUp instead." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else if(buttonIndex == 1){
        // runsignup upload
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissModalViewControllerAnimated: YES];
}

- (void)toggleEdit{
    if([table isEditing]){
        [table setEditing:NO animated:YES];
    }else{
        [table setEditing:YES animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    else
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
