//
//  ArchiveDetailViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArchiveDetailViewController.h"
#import "RecordTableViewCell.h"
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
    
    if([[fileDict objectForKey:@"Type"] intValue] == 0){
        [[cell textLabel] setText: [NSString stringWithFormat:@"%.4i", [records count] - indexPath.row]];
        [[cell dataLabel] setText: [records objectAtIndex: indexPath.row]];
    }else if([[fileDict objectForKey:@"Type"] intValue] == 1){
        [[cell textLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Bib"]];
        [[cell dataLabel] setText: [[records objectAtIndex: indexPath.row] objectForKey:@"Time"]];
    }else{
        [[cell textLabel] setText: [NSString stringWithFormat:@"%.4i", [records count] - indexPath.row]];
        [[cell dataLabel] setText: [records objectAtIndex: indexPath.row]];
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
        [self saveToFile];
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
