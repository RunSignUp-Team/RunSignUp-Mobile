//
//  ArchiveTableViewCell.m
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

#import "ArchiveTableViewCell.h"

@implementation ArchiveTableViewCell
@synthesize dataTypeImage;
@synthesize raceNameLabel;
@synthesize dateLabel;
@synthesize idsLabel;

// Layout done programatically because of the hackishness of using Nibs for UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.dataTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(288, 0, 32, 44)];
        [dataTypeImage setBackgroundColor: [UIColor whiteColor]];
        [self.contentView addSubview: dataTypeImage];
        
        self.raceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 276, 20)];
        [raceNameLabel setAdjustsFontSizeToFitWidth: YES];
        [raceNameLabel setFont: [UIFont boldSystemFontOfSize:18.0f]];
        [self.contentView addSubview: raceNameLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, 80, 18)];
        [dateLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [dateLabel setTextColor: [UIColor lightGrayColor]];
        [self.contentView addSubview:dateLabel];
        
        self.idsLabel = [[UILabel alloc] initWithFrame: CGRectMake(100, 24, 186, 18)];
        [idsLabel setFont: [UIFont systemFontOfSize: 16.0f]];
        [idsLabel setTextColor: [UIColor lightGrayColor]];
        [self.contentView addSubview: idsLabel];
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
        [idsLabel setTextColor:[UIColor whiteColor]];
    }else{
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        [raceNameLabel setTextColor:[UIColor blackColor]];
        [idsLabel setTextColor:[UIColor lightGrayColor]];
    }
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted){
        [dateLabel setTextColor:[UIColor whiteColor]];
        [raceNameLabel setTextColor:[UIColor whiteColor]];
        [idsLabel setTextColor:[UIColor whiteColor]];
    }else{
        [dateLabel setTextColor:[UIColor lightGrayColor]];
        [raceNameLabel setTextColor:[UIColor blackColor]];
        [idsLabel setTextColor:[UIColor lightGrayColor]];
    }
    [super setHighlighted:highlighted animated:animated];
}

@end
