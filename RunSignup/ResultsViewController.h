//
//  ResultsViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 12/30/13.
//
//

#import <UIKit/UIKit.h>
#import "RSUModel.h"
#import "RoundedLoadingIndicator.h"

@interface ResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *results;
    
    UITableView *table;
    UIScrollView *scrollView;
    
    RoundedLoadingIndicator *rli;
}

@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;

- (IBAction)goBack:(id)sender;

@end
