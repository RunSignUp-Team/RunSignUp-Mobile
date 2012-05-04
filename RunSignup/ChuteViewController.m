//
//  ChuteViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChuteViewController.h"
#import "RecordTableViewCell.h"

@implementation ChuteViewController
@synthesize recordButton;
@synthesize table;
@synthesize records;
@synthesize bibField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Chute";
        
        self.records = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // Images created for stretching to variably sized UIButtons (see buttons in resources)
    UIImage *redButtonImage = [UIImage imageNamed:@"RedButton.png"];
    UIImage *stretchedRedButton = [redButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *redButtonTapImage = [UIImage imageNamed:@"RedButtonTap.png"];
    UIImage *stretchedRedButtonTap = [redButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIImage *grayButtonImage = [UIImage imageNamed:@"GrayButton.png"];
    UIImage *stretchedGrayButton = [grayButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    
    [recordButton setBackgroundImage:stretchedRedButton forState:UIControlStateNormal];
    [recordButton setBackgroundImage:stretchedRedButtonTap forState:UIControlStateHighlighted];
    [recordButton setBackgroundImage:stretchedGrayButton forState:UIControlStateDisabled];
    
    // Set up right bar button (upper right corner) of UINavigationBar to edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    [editButton release];
    
    [self.bibField becomeFirstResponder];
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
        [records insertObject:[bibField text] atIndex:0];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [table beginUpdates];
        [table insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationBottom];
        [table endUpdates];
        
        [bibField setText:@""];
        [recordButton setEnabled:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string length] != 0){
        if(textField.text.length < 5 && strchr("1234567890-", [string characterAtIndex: 0])){
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
        cell = [[RecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withMode:1];
        cell.showsReorderControl = YES;
    }
    
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

/*- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    NSString *bibNumberToMove = [[records objectAtIndex:fromIndexPath.row] retain];
    [records removeObject:bibNumberToMove];
    [records insertObject:bibNumberToMove atIndex:toIndexPath.row];
    [bibNumberToMove release];
    
    [self performSelector:@selector(updateRecordNumbersAfterDeletion) withObject:nil afterDelay:0.25f];
    // Above call is a bit of a misnomer, it's actually after a movement but the function is the same.
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
    return @"Place                           Bib #";
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
