//
//  ResultsViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 12/30/13.
//
//

#import "ResultsViewController.h"
#import "ResultsTableViewCell.h"

@implementation ResultsViewController
@synthesize results;
@synthesize table;
@synthesize scrollView;
@synthesize rli;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.results = nil;
        self.title = @"Results";
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self setEdgesForExtendedLayout: UIRectEdgeNone];
        
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack:)];    
    [self.navigationItem setLeftBarButtonItem: cancelButton];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        if([[UIScreen mainScreen] bounds].size.height > 480.0f)
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:160 YLocation:100];
        else
            self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:204 YLocation:100];
    else
        self.rli = [[RoundedLoadingIndicator alloc] initWithXLocation:432 YLocation:100];
    
    [[rli label] setText:@"Retrieving list..."];
    [self.view addSubview: rli];
    
    CGRect oldFrame = [table frame];
    oldFrame.size.width = 1360;
    [table setFrame: oldFrame];
    
    [scrollView setContentSize: CGSizeMake(oldFrame.size.width, 10)];
    
    [rli fadeIn];
    
    void (^response)(NSMutableArray *) = ^(NSMutableArray *list){
        self.results = list;
        NSLog(@"Results: %@", results);
        [table reloadData];
        [rli fadeOut];
    };
    
    [[RSUModel sharedModel] attemptRetrieveResults:response];
    
    [cancelButton release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    ResultsTableViewCell *cell = (ResultsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[ResultsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row % 2)
        [[cell contentView] setBackgroundColor: [UIColor colorWithWhite:0.94f alpha:1.0f]];
    else
        [[cell contentView] setBackgroundColor: [UIColor whiteColor]];
    
    [[cell placeLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"place"]];
    [[cell bibLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"bib"]];
    [[cell firstNameLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"first_name"]];
    [[cell lastNameLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"last_name"]];
    [[cell genderLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"gender"]];
    [[cell cityLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"city"]];
    [[cell stateLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"state"]];
    [[cell countryLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"country"]];
    [[cell clockTimeLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"clock_time"]];
    [[cell chipTimeLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"chip_time"]];
    [[cell paceLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"pace"]];
    [[cell ageLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"age"]];
    [[cell agePercentageLabel] setText:[[results objectAtIndex: indexPath.row] objectForKey:@"age_percentage"]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ResultsTableViewCell *header = [[ResultsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Header"];
    [header setIsHeader: YES];
    return [header contentView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [results count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [table deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)goBack:(id)sender{
    [self dismissModalViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationMaskLandscape;
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return UIInterfaceOrientationLandscapeLeft;
    else
        return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
