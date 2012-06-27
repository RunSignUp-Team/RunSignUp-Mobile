//
//  OfflineRaceViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainMenuViewController;

@interface OfflineRaceViewController : UIViewController <UITextFieldDelegate>{
    UITextField *nameField;
    UIButton *createButton;
    
    MainMenuViewController *delegate;
}

@property (nonatomic, retain) MainMenuViewController *delegate;

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UIButton *createButton;

- (IBAction)createRace:(id)sender;
- (IBAction)cancel:(id)sender;

@end
