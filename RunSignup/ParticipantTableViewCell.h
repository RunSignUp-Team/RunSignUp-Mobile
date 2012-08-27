//
//  ParticipantTableViewCell.h
//  RunSignup
//
//  Created by Billy Connolly on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
