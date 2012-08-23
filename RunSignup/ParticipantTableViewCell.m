//
//  ParticipantTableViewCell.m
//  RunSignup
//
//  Created by Billy Connolly on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParticipantTableViewCell.h"

@implementation ParticipantTableViewCell
@synthesize firstNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 300, 16)];
        [firstNameLabel setFont: [UIFont systemFontOfSize: 14.0f]];
        [firstNameLabel setTextColor: [UIColor blackColor]];
        [self.contentView addSubview: firstNameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
