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
    UIButton *offlineButton;
    UIButton *checkerButton;
    UIButton *selectRaceButton;
    UIButton *chuteButton;
    UIButton *participantsButton;
    
    UIButton *signOutButton;
    UIButton *archiveButton;
    UIButton *settingsButton;
    UILabel *signedInAs;
    UILabel *emailLabel;
    
    UILabel *timingFor;
    UILabel *raceLabel;
    
    NSString *raceDirectorEmail;
    NSString *raceDirectorRaceName;
    NSString *raceDirectorRaceID;
    NSString *raceDirectorEventName;
    NSString *raceDirectorEventID;
    
    UILabel *copyrightLabel;
    UILabel *hintLabel;
    UILabel *hintLabel2;
}

@property (nonatomic, retain) IBOutlet UIButton *timerButton;
@property (nonatomic, retain) IBOutlet UIButton *signInButton;
@property (nonatomic, retain) IBOutlet UIButton *offlineButton;
@property (nonatomic, retain) IBOutlet UIButton *checkerButton;
@property (nonatomic, retain) IBOutlet UIButton *chuteButton;
@property (nonatomic, retain) IBOutlet UIButton *participantsButton;
@property (nonatomic, retain) IBOutlet UILabel *copyrightLabel;
@property (nonatomic, retain) IBOutlet UILabel *hintLabel;
@property (nonatomic, retain) IBOutlet UILabel *hintLabel2;

@property (nonatomic, retain) IBOutlet UIButton *signOutButton;
@property (nonatomic, retain) IBOutlet UIButton *archiveButton;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UILabel *signedInAs;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;

@property (nonatomic, retain) IBOutlet UIButton *selectRaceButton;
@property (nonatomic, retain) IBOutlet UILabel *timingFor;
@property (nonatomic, retain) IBOutlet UILabel *raceLabel;

@property (nonatomic, retain) NSString *raceDirectorEmail;
@property (nonatomic, retain) NSString *raceDirectorRaceName;
@property (nonatomic, retain) NSString *raceDirectorRaceID;
@property (nonatomic, retain) NSString *raceDirectorEventName;
@property (nonatomic, retain) NSString *raceDirectorEventID;

- (IBAction)timer:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)offline:(id)sender;
- (IBAction)checker:(id)sender;
- (IBAction)selectRace:(id)sender;
- (IBAction)chute:(id)sender;
- (IBAction)participants:(id)sender;

- (IBAction)showArchive:(id)sender;
- (IBAction)showSettings:(id)sender;

- (IBAction)didSignOut;
- (void)didSignInEmail:(NSString *)email password:(NSString *)password response:(void (^)(int))responseBlock;
- (void)didCreateOfflineRace:(NSString *)name;
- (void)didSelectRace:(NSString *)raceName withID:(NSString *)raceID withEventName:(NSString *)eventName withEventID:(NSString *)eventID;

@end
