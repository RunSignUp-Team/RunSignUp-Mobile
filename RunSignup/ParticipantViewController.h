//
//  ParticipantViewController.h
//  RunSignUp
//
// Copyright 2012 RunSignUp
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>
#import "RoundedLoadingIndicator.h"
#import "RSUModel.h"

@interface ParticipantViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *table;
    
    NSMutableArray *participants;
    
    RoundedLoadingIndicator *rli;
    
    NSIndexPath *row;
    
    NSString *raceName;
    NSString *eventName;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *participants;
@property (nonatomic, retain) RoundedLoadingIndicator *rli;
@property (nonatomic, retain) NSIndexPath *row;
@property (nonatomic, retain) NSString *raceName;
@property (nonatomic, retain) NSString *eventName;

- (IBAction)goBack:(id)sender;
- (IBAction)toggleEdit:(id)sender;
- (IBAction)addParticipant:(id)sender;

- (void)createParticipantWithDictionary:(NSDictionary *)dict response:(void (^)(RSUConnectionResponse))responseBlock;

@end
