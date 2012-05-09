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
    UIButton *signInButton;
    UIButton *checkerButton;
    UIButton *selectRaceButton;
    UIButton *chuteButton;
    
    UIButton *signOutButton;
    UILabel *signedInAs;
    UILabel *emailLabel;
    
    UILabel *timingFor;
    UILabel *raceLabel;
    
    NSString *raceDirectorEmail;
    NSString *raceDirectorRaceID;
    
    UILabel *copyrightLabel;
    UILabel *hintLabel;
}

@property (nonatomic, retain) IBOutlet UIButton *timerButton;
@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UIButton *checkerButton;
@property (nonatomic, retain) IBOutlet UIButton *chuteButton;
@property (nonatomic, retain) IBOutlet UILabel *copyrightLabel;
@property (nonatomic, retain) IBOutlet UILabel *hintLabel;

@property (nonatomic, retain) IBOutlet UIButton *signOutButton;
@property (nonatomic, retain) IBOutlet UILabel *signedInAs;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;

@property (nonatomic, retain) IBOutlet UIButton *selectRaceButton;
@property (nonatomic, retain) IBOutlet UILabel *timingFor;
@property (nonatomic, retain) IBOutlet UILabel *raceLabel;

@property (nonatomic, retain) NSString *raceDirectorEmail;
@property (nonatomic, retain) NSString *raceDirectorRaceID;

- (IBAction)timer:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)checker:(id)sender;
- (IBAction)selectRace:(id)sender;
- (IBAction)chute:(id)sender;

- (IBAction)showInfo:(id)sender;
- (IBAction)showSettings:(id)sender;

- (IBAction)didSignOut;
- (BOOL)didSignInEmail:(NSString *)email password:(NSString *)password;
- (BOOL)didSelectRace:(NSString *)raceID;

@end
