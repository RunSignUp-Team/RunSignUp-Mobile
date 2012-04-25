//
//  MainMenuViewController.h
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController{
    UIButton *timerButton;
    UIButton *checkerButton;
    UIButton *chuteButton;
    
    UILabel *copyrightLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *timerButton;
@property (nonatomic, retain) IBOutlet UIButton *checkerButton;
@property (nonatomic, retain) IBOutlet UIButton *chuteButton;
@property (nonatomic, retain) IBOutlet UILabel *copyrightLabel;

- (IBAction)timer:(id)sender;
- (IBAction)checker:(id)sender;
- (IBAction)chute:(id)sender;

- (IBAction)showInfo:(id)sender;
- (IBAction)showSettings:(id)sender;

@end
