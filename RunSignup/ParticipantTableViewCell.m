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
@synthesize lastNameLabel;
@synthesize genderLabel;
@synthesize bibLabel;
@synthesize ageLabel;
@synthesize cityLabel;
@synthesize stateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 90, 36)];
            [firstNameLabel setAdjustsFontSizeToFitWidth: YES];
            [firstNameLabel setTextColor: [UIColor blackColor]];
            [firstNameLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: firstNameLabel];
            
            self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(106, 4, 100, 36)];
            [lastNameLabel setAdjustsFontSizeToFitWidth: YES];
            [lastNameLabel setTextColor: [UIColor blackColor]];
            [lastNameLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: lastNameLabel];
            
            self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(214, 4, 14, 36)];
            [genderLabel setAdjustsFontSizeToFitWidth: YES];
            [genderLabel setTextColor: [UIColor blackColor]];
            [genderLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: genderLabel];
            
            self.bibLabel = [[UILabel alloc] initWithFrame:CGRectMake(236, 4, 50, 36)];
            [bibLabel setFont: [UIFont systemFontOfSize: 16]];
            [bibLabel setTextColor: [UIColor blackColor]];
            [bibLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: bibLabel];
            
            self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(294, 4, 30, 36)];
            [ageLabel setAdjustsFontSizeToFitWidth: YES];
            [ageLabel setTextColor: [UIColor blackColor]];
            [ageLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: ageLabel];
            
            self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(332, 4, 110, 36)];
            [cityLabel setAdjustsFontSizeToFitWidth: YES];
            [cityLabel setTextColor: [UIColor blackColor]];
            [cityLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: cityLabel];
            
            self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(448, 4, 28, 36)];
            [stateLabel setFont: [UIFont systemFontOfSize: 16]];
            [stateLabel setTextColor: [UIColor blackColor]];
            [stateLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: stateLabel];
            
            d1 = [[UIView alloc] initWithFrame: CGRectMake(102, 0, 1, 44)];
            d2 = [[UIView alloc] initWithFrame: CGRectMake(210, 0, 1, 44)];
            d3 = [[UIView alloc] initWithFrame: CGRectMake(232, 0, 1, 44)];
            d4 = [[UIView alloc] initWithFrame: CGRectMake(290, 0, 1, 44)];
            d5 = [[UIView alloc] initWithFrame: CGRectMake(328, 0, 1, 44)];
            d6 = [[UIView alloc] initWithFrame: CGRectMake(444, 0, 1, 44)];
        }else{
            self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 255, 36)];
            [firstNameLabel setAdjustsFontSizeToFitWidth: YES];
            [firstNameLabel setTextColor: [UIColor blackColor]];
            [firstNameLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: firstNameLabel];
            
            self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(271, 4, 275, 36)];
            [lastNameLabel setAdjustsFontSizeToFitWidth: YES];
            [lastNameLabel setTextColor: [UIColor blackColor]];
            [lastNameLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: lastNameLabel];
            
            self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(562, 4, 14, 36)];
            [genderLabel setAdjustsFontSizeToFitWidth: YES];
            [genderLabel setTextColor: [UIColor blackColor]];
            [genderLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: genderLabel];
            
            self.bibLabel = [[UILabel alloc] initWithFrame:CGRectMake(584, 4, 50, 36)];
            [bibLabel setFont: [UIFont systemFontOfSize: 16]];
            [bibLabel setTextColor: [UIColor blackColor]];
            [bibLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: bibLabel];
            
            self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(642, 4, 30, 36)];
            [ageLabel setAdjustsFontSizeToFitWidth: YES];
            [ageLabel setTextColor: [UIColor blackColor]];
            [ageLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: ageLabel];
            
            self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(680, 4, 234, 36)];
            [cityLabel setAdjustsFontSizeToFitWidth: YES];
            [cityLabel setTextColor: [UIColor blackColor]];
            [cityLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: cityLabel];
            
            self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(922, 4, 28, 36)];
            [stateLabel setFont: [UIFont systemFontOfSize: 16]];
            [stateLabel setTextColor: [UIColor blackColor]];
            [stateLabel setBackgroundColor: [UIColor clearColor]];
            [self.contentView addSubview: stateLabel];
            
            d1 = [[UIView alloc] initWithFrame: CGRectMake(268, 0, 1, 44)];
            d2 = [[UIView alloc] initWithFrame: CGRectMake(558, 0, 1, 44)];
            d3 = [[UIView alloc] initWithFrame: CGRectMake(580, 0, 1, 44)];
            d4 = [[UIView alloc] initWithFrame: CGRectMake(638, 0, 1, 44)];
            d5 = [[UIView alloc] initWithFrame: CGRectMake(676, 0, 1, 44)];
            d6 = [[UIView alloc] initWithFrame: CGRectMake(918, 0, 1, 44)];
        }
        
        [d1 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]]; // Grabbed from screenshot of table divider
        [d2 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]];
        [d3 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]];
        [d4 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]];
        [d5 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]];
        [d6 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]];
        
        [firstNameLabel setTextAlignment: UITextAlignmentLeft];
        [lastNameLabel setTextAlignment: UITextAlignmentLeft];
        [genderLabel setTextAlignment: UITextAlignmentCenter];
        [bibLabel setTextAlignment: UITextAlignmentCenter];
        [ageLabel setTextAlignment: UITextAlignmentCenter];
        [cityLabel setTextAlignment: UITextAlignmentLeft];
        [stateLabel setTextAlignment: UITextAlignmentCenter];
        
        [self.contentView addSubview: d1];
        [self.contentView addSubview: d2];
        [self.contentView addSubview: d3];
        [self.contentView addSubview: d4];
        [self.contentView addSubview: d5];
        [self.contentView addSubview: d6];
        
    }
    return self;
}

- (void)setIsHeader:(BOOL)header{
    isHeader = header;
    if(header){
        CGRect frame = [firstNameLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.firstNameLabel setFrame: frame];
        frame = [lastNameLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.lastNameLabel setFrame: frame];
        frame = [genderLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.genderLabel setFrame: frame];
        frame = [bibLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.bibLabel setFrame: frame];
        frame = [ageLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.ageLabel setFrame: frame];
        frame = [cityLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.cityLabel setFrame: frame];
        frame = [stateLabel frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [self.stateLabel setFrame: frame];
        
        frame = [d1 frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [d1 setFrame: frame];
        frame = [d2 frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [d2 setFrame: frame];
        frame = [d3 frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [d3 setFrame: frame];
        frame = [d4 frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [d4 setFrame: frame];
        frame = [d5 frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [d5 setFrame: frame];
        frame = [d6 frame];
        frame.size.height = 22;
        frame.origin.y = 0;
        [d6 setFrame: frame];
        
        [firstNameLabel setTextAlignment: UITextAlignmentCenter];
        [lastNameLabel setTextAlignment: UITextAlignmentCenter];
        [genderLabel setTextAlignment: UITextAlignmentCenter];
        [bibLabel setTextAlignment: UITextAlignmentCenter];
        [ageLabel setTextAlignment: UITextAlignmentCenter];
        [cityLabel setTextAlignment: UITextAlignmentCenter];
        [stateLabel setTextAlignment: UITextAlignmentCenter];
        [self.contentView setBackgroundColor: [UIColor colorWithWhite:0.8f alpha:1.0f]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(isHeader){
        [super setSelected:NO animated:NO];
    }else{
        [super setSelected:selected animated:animated];
        if(selected){
            [firstNameLabel setTextColor: [UIColor whiteColor]];
            [lastNameLabel setTextColor: [UIColor whiteColor]];
            [genderLabel setTextColor: [UIColor whiteColor]];
            [bibLabel setTextColor: [UIColor whiteColor]];
            [ageLabel setTextColor: [UIColor whiteColor]];
            [cityLabel setTextColor: [UIColor whiteColor]];
            [stateLabel setTextColor: [UIColor whiteColor]];
        }else{
            [firstNameLabel setTextColor: [UIColor blackColor]];
            [lastNameLabel setTextColor: [UIColor blackColor]];
            [genderLabel setTextColor: [UIColor blackColor]];
            [bibLabel setTextColor: [UIColor blackColor]];
            [ageLabel setTextColor: [UIColor blackColor]];
            [cityLabel setTextColor: [UIColor blackColor]];
            [stateLabel setTextColor: [UIColor blackColor]];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(isHeader){
        [super setHighlighted:NO animated:NO];
    }else{
        [super setHighlighted:highlighted animated:animated];
        if(highlighted){
            [firstNameLabel setTextColor: [UIColor whiteColor]];
            [lastNameLabel setTextColor: [UIColor whiteColor]];
            [genderLabel setTextColor: [UIColor whiteColor]];
            [bibLabel setTextColor: [UIColor whiteColor]];
            [ageLabel setTextColor: [UIColor whiteColor]];
            [cityLabel setTextColor: [UIColor whiteColor]];
            [stateLabel setTextColor: [UIColor whiteColor]];
        }else{
            [firstNameLabel setTextColor: [UIColor blackColor]];
            [lastNameLabel setTextColor: [UIColor blackColor]];
            [genderLabel setTextColor: [UIColor blackColor]];
            [bibLabel setTextColor: [UIColor blackColor]];
            [ageLabel setTextColor: [UIColor blackColor]];
            [cityLabel setTextColor: [UIColor blackColor]];
            [stateLabel setTextColor: [UIColor blackColor]];
        }
    }
}

@end
