//
//  ArchiveTableViewCell.m
//  RunSignup
//
//  Created by Billy Connolly on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArchiveTableViewCell.h"

@implementation ArchiveTableViewCell
@synthesize dataTypeImage;
@synthesize raceNameLabel;
@synthesize dateLabel;

// Layout done programatically because of the hackishness of using Nibs for UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.dataTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(288, 0, 32, 44)];
        [dataTypeImage setBackgroundColor: [UIColor whiteColor]];
        [self.contentView addSubview: dataTypeImage];
        
        self.raceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 276, 20)];
        [raceNameLabel setFont: [UIFont boldSystemFontOfSize:18.0f]];
        [self.contentView addSubview: raceNameLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, 276, 18.0f)];
        [dateLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [dateLabel setTextColor: [UIColor lightGrayColor]];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}

- (void)setType:(int)type{
    if(type == 0){
        [dataTypeImage setImage: [UIImage imageNamed:@"TimerIcon.png"]];
    }else if(type == 1){
        [dataTypeImage setImage: [UIImage imageNamed:@"CheckerIcon.png"]];
    }else{
        [dataTypeImage setImage: [UIImage imageNamed:@"ChuteIcon"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(selected){
        [dateLabel setTextColor:[UIColor whiteColor]];
        [raceNameLabel setTextColor:[UIColor whiteColor]];
    }else{
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        [raceNameLabel setTextColor:[UIColor blackColor]];
    }
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted){
        [dateLabel setTextColor:[UIColor whiteColor]];
        [raceNameLabel setTextColor:[UIColor whiteColor]];
    }else{
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        [raceNameLabel setTextColor:[UIColor blackColor]];
    }
    [super setHighlighted:highlighted animated:animated];
}

@end
