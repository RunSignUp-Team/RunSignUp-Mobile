//
//  EditBibViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditBibDelegate <NSObject>

- (void)didSaveBib:(NSString *)bib withIndex:(NSIndexPath *)indexPath;

@end

@interface EditBibViewController : UIViewController <UITextFieldDelegate> {
    UIButton *saveAndExitButton;
    UITextField *bibField;
    NSString *bibNumber;
    
    NSIndexPath *indexPath;
    id <EditBibDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIButton *saveAndExitButton;
@property (nonatomic, retain) IBOutlet UITextField *bibField;
@property (nonatomic, retain) NSString *bibNumber;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) id <EditBibDelegate> delegate;

- (IBAction)saveAndExit:(id)sender;
- (IBAction)goBack:(id)sender;

@end
