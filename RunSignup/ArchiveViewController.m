//
//  ArchiveViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArchiveViewController.h"
#import "ArchiveTableViewCell.h"
#import "ArchiveDetailViewController.h"
#import "JSON.h"

@implementation ArchiveViewController
@synthesize table;
@synthesize fileArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Archive";
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
            [self.navigationItem setLeftBarButtonItem: cancelItem];
            [cancelItem release];
        }
        
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEdit)];
        [self.navigationItem setRightBarButtonItem: editItem];
        [editItem release];
        
        self.fileArray = [[NSMutableArray alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:(NSString *)[paths objectAtIndex:0] error:nil];
        for(NSString *string in files){
            if([[string substringFromIndex: [string length] - 4] isEqualToString:@"json"]){
                NSString *data = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],string] encoding:NSUTF8StringEncoding error:nil];
                NSMutableDictionary *fileDict = [data JSONValue];
                [fileDict setObject:[NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],string] forKey:@"File"];
                
                NSDictionary *fileProperties = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],string] error:nil];
                NSDate *lastModifiedDate = [fileProperties objectForKey: NSFileModificationDate];
                [fileDict setObject:lastModifiedDate forKey:@"LastModifiedDate"];
                
                [fileArray addObject: fileDict];
            }
        }
        
        NSArray *sortedArray = [fileArray sortedArrayUsingComparator:^(id obj1, id obj2){                               
            NSComparisonResult comparison = [[obj1 objectForKey:@"LastModifiedDate"] compare:[obj2 objectForKey:@"LastModifiedDate"]];
            // Invert ordering so it goes last modified first
            if(comparison == NSOrderedDescending){
                comparison = NSOrderedAscending;
            }else if(comparison == NSOrderedAscending){
                comparison = NSOrderedDescending;
            }
            return comparison;                                
        }];
        
        for(NSMutableDictionary *fileDict in sortedArray){
            [fileDict removeObjectForKey:@"LastModifiedDate"];
        }
        
        self.fileArray = [NSMutableArray arrayWithArray: sortedArray];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    ArchiveTableViewCell *cell = (ArchiveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[ArchiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell setType: [[[fileArray objectAtIndex: indexPath.row] objectForKey: @"Type"] intValue]];
    [[cell raceNameLabel] setText:[[fileArray objectAtIndex: indexPath.row] objectForKey: @"RaceName"]];
    [[cell dateLabel] setText:[[fileArray objectAtIndex: indexPath.row] objectForKey: @"Date"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSString *fileToDelete = [[fileArray objectAtIndex: indexPath.row] objectForKey:@"File"];
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:fileToDelete error:nil];
        NSLog(@"%i", indexPath.row);
        [fileArray removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArchiveDetailViewController *archiveDetailViewController = [[ArchiveDetailViewController alloc] initWithNibName:nil bundle:nil];
    [archiveDetailViewController setFile:[[fileArray objectAtIndex: indexPath.row] objectForKey: @"File"]];
    [self.navigationController pushViewController:archiveDetailViewController animated:YES];
    [archiveDetailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Race                                Data Type";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [fileArray count];
}

- (void)cancel{
    [self dismissModalViewControllerAnimated:YES];
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
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
