//
//  ParticipantTableViewCell.h
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

@interface ParticipantTableViewCell : UITableViewCell{
    UILabel *firstNameLabel;
    UILabel *lastNameLabel;
    UILabel *genderLabel;
    UILabel *bibLabel;
    UILabel *ageLabel;
    UILabel *cityLabel;
    UILabel *stateLabel;
    
    BOOL isHeader;
    
    UIView *d1;
    UIView *d2;
    UIView *d3;
    UIView *d4;
    UIView *d5;
    UIView *d6;
    UIView *d7;
}

@property (nonatomic, retain) UILabel *firstNameLabel;
@property (nonatomic, retain) UILabel *lastNameLabel;
@property (nonatomic, retain) UILabel *genderLabel;
@property (nonatomic, retain) UILabel *bibLabel;
@property (nonatomic, retain) UILabel *ageLabel;
@property (nonatomic, retain) UILabel *cityLabel;
@property (nonatomic, retain) UILabel *stateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setIsHeader:(BOOL)header;

@end
