//
//  ArchiveDetailViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArchiveDetailViewController.h"
#import "RecordTableViewCell.h"
#import "ArchiveEditCellViewController.h"
#import "JSON.h"

@implementation ArchiveDetailViewController
@synthesize nameLabel;
@synthesize dateLabel;
@synthesize typeLabel;
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
    NSString *data = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    self.fileDict = [data JSONValue];
    self.records = [fileDict objectForKey:@"Data"];
    
    [nameLabel setText: [fileDict objectForKey:@"RaceID"]];
    [dateLabel setText: [fileDict objectForKey:@"Date"]];
    if([[fileDict objectForKey:@"Type"] intValue] == 0){
        [typeLabel setText:@"Timer (Place # and Time)"];
    }else if([[fileDict objectForKey:@"Type"] intValue] == 1){
        [typeLabel setText:@"Checker (Bib # and Time)"];
    }else{
        [typeLabel setText:@"Chute (Place # and Bib #)"];
    }
    [super viewDidLoad];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    RecordTableViewCell *cell = (RecordTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:[[fileDict objectForKey:@"Type"] intValue]];
    
    /*UIImageView *editAccessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"EditIcon.png"]];
    [cell setAccessoryView: editAccessoryView];*/
    [cell setEditingAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
    
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
    
    [self.navigationController pushViewController:archiveEditCellViewController animated:YES];
    [archiveEditCellViewController release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [records count];
}

- (void)toggleEdit{
    if([table isEditing]){
        [table setEditing:NO animated:YES];
    }else{
        [table setEditing:YES animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
