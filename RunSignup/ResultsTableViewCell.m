//
//  ResultsTableViewCell.m
//  RunSignup
//
//  Created by Billy Connolly on 1/1/14.
//
//

#import "ResultsTableViewCell.h"

@implementation ResultsTableViewCell
@synthesize placeLabel;
@synthesize bibLabel;
@synthesize firstNameLabel;
@synthesize lastNameLabel;
@synthesize genderLabel;
@synthesize cityLabel;
@synthesize stateLabel;
@synthesize countryLabel;
@synthesize clockTimeLabel;
@synthesize chipTimeLabel;
@synthesize paceLabel;
@synthesize ageLabel;
@synthesize agePercentageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 56, 36)];
        [placeLabel setFont: [UIFont systemFontOfSize: 16]];
        [placeLabel setTextColor: [UIColor blackColor]];
        [placeLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: placeLabel];
        
        self.bibLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 4, 56, 36)];
        [bibLabel setFont: [UIFont systemFontOfSize: 16]];
        [bibLabel setTextColor: [UIColor blackColor]];
        [bibLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: bibLabel];
        
        self.firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 4, 122, 36)];
        [firstNameLabel setAdjustsFontSizeToFitWidth: YES];
        [firstNameLabel setTextColor: [UIColor blackColor]];
        [firstNameLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: firstNameLabel];
        
        self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(262, 4, 132, 36)];
        [lastNameLabel setAdjustsFontSizeToFitWidth: YES];
        [lastNameLabel setTextColor: [UIColor blackColor]];
        [lastNameLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: lastNameLabel];
        
        self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(400, 4, 18, 36)];
        [genderLabel setAdjustsFontSizeToFitWidth: YES];
        [genderLabel setTextColor: [UIColor blackColor]];
        [genderLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: genderLabel];
        
        self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(424, 4, 122, 36)];
        [cityLabel setAdjustsFontSizeToFitWidth: YES];
        [cityLabel setTextColor: [UIColor blackColor]];
        [cityLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: cityLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(554, 4, 56, 36)];
        [stateLabel setFont: [UIFont systemFontOfSize: 16]];
        [stateLabel setTextColor: [UIColor blackColor]];
        [stateLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: stateLabel];
        
        self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(618, 4, 128, 36)];
        [countryLabel setFont: [UIFont systemFontOfSize: 16]];
        [countryLabel setTextColor: [UIColor blackColor]];
        [countryLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: countryLabel];
        
        self.clockTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(754, 4, 142, 36)];
        [clockTimeLabel setFont: [UIFont systemFontOfSize: 16]];
        [clockTimeLabel setTextColor: [UIColor blackColor]];
        [clockTimeLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: clockTimeLabel];
        
        self.chipTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(904, 4, 142, 36)];
        [chipTimeLabel setFont: [UIFont systemFontOfSize: 16]];
        [chipTimeLabel setTextColor: [UIColor blackColor]];
        [chipTimeLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: chipTimeLabel];
        
        self.paceLabel = [[UILabel alloc] initWithFrame:CGRectMake(1054, 4, 62, 36)];
        [paceLabel setFont: [UIFont systemFontOfSize: 16]];
        [paceLabel setTextColor: [UIColor blackColor]];
        [paceLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: paceLabel];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(1124, 4, 62, 36)];
        [ageLabel setFont: [UIFont systemFontOfSize: 16]];
        [ageLabel setTextColor: [UIColor blackColor]];
        [ageLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: ageLabel];
        
        self.agePercentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(1194, 4, 162, 36)];
        [agePercentageLabel setFont: [UIFont systemFontOfSize: 16]];
        [agePercentageLabel setTextColor: [UIColor blackColor]];
        [agePercentageLabel setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview: agePercentageLabel];
        
        d1 = [[UIView alloc] initWithFrame: CGRectMake(64, 0, 1, 44)];
        d2 = [[UIView alloc] initWithFrame: CGRectMake(128, 0, 1, 44)];
        d3 = [[UIView alloc] initWithFrame: CGRectMake(258, 0, 1, 44)];
        d4 = [[UIView alloc] initWithFrame: CGRectMake(398, 0, 1, 44)];
        d5 = [[UIView alloc] initWithFrame: CGRectMake(420, 0, 1, 44)];
        d6 = [[UIView alloc] initWithFrame: CGRectMake(550, 0, 1, 44)];
        d7 = [[UIView alloc] initWithFrame: CGRectMake(615, 0, 1, 44)];
        d8 = [[UIView alloc] initWithFrame: CGRectMake(750, 0, 1, 44)];
        d9 = [[UIView alloc] initWithFrame: CGRectMake(900, 0, 1, 44)];
        d10 = [[UIView alloc] initWithFrame: CGRectMake(1050, 0, 1, 44)];
        d11 = [[UIView alloc] initWithFrame: CGRectMake(1120, 0, 1, 44)];
        d12 = [[UIView alloc] initWithFrame: CGRectMake(1190, 0, 1, 44)];
        d13 = [[UIView alloc] initWithFrame: CGRectMake(0, 43, 1360, 1)];
        
        [d1 setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]]; // Grabbed from screenshot of table divider
        [d2 setBackgroundColor: [d1 backgroundColor]];
        [d3 setBackgroundColor: [d1 backgroundColor]];
        [d4 setBackgroundColor: [d1 backgroundColor]];
        [d5 setBackgroundColor: [d1 backgroundColor]];
        [d6 setBackgroundColor: [d1 backgroundColor]];
        [d7 setBackgroundColor: [d1 backgroundColor]];
        [d8 setBackgroundColor: [d1 backgroundColor]];
        [d9 setBackgroundColor: [d1 backgroundColor]];
        [d10 setBackgroundColor: [d1 backgroundColor]];
        [d11 setBackgroundColor: [d1 backgroundColor]];
        [d12 setBackgroundColor: [d1 backgroundColor]];
        [d13 setBackgroundColor: [d1 backgroundColor]];
        
        [placeLabel setTextAlignment: NSTextAlignmentCenter];
        [bibLabel setTextAlignment: NSTextAlignmentCenter];
        [firstNameLabel setTextAlignment: NSTextAlignmentCenter];
        [lastNameLabel setTextAlignment: NSTextAlignmentCenter];
        [genderLabel setTextAlignment: NSTextAlignmentCenter];
        [cityLabel setTextAlignment: NSTextAlignmentCenter];
        [stateLabel setTextAlignment: NSTextAlignmentCenter];
        [countryLabel setTextAlignment: NSTextAlignmentCenter];
        [clockTimeLabel setTextAlignment: NSTextAlignmentCenter];
        [chipTimeLabel setTextAlignment: NSTextAlignmentCenter];
        [paceLabel setTextAlignment: NSTextAlignmentCenter];
        [ageLabel setTextAlignment: NSTextAlignmentCenter];
        [agePercentageLabel setTextAlignment: NSTextAlignmentCenter];

        [self.contentView addSubview: d1];
        [self.contentView addSubview: d2];
        [self.contentView addSubview: d3];
        [self.contentView addSubview: d4];
        [self.contentView addSubview: d5];
        [self.contentView addSubview: d6];
        [self.contentView addSubview: d7];
        [self.contentView addSubview: d8];
        [self.contentView addSubview: d9];
        [self.contentView addSubview: d10];
        [self.contentView addSubview: d11];
        [self.contentView addSubview: d12];
        [self.contentView addSubview: d13];
        
    }
    return self;
}

- (void)setIsHeader:(BOOL)header{
    isHeader = header;
    if(header){
        for(UIView *view in self.contentView.subviews){
            if([view isKindOfClass: [UILabel class]] || [view isKindOfClass: [UIView class]]){
                CGRect frame = [view frame];
                frame.size.height = 22;
                frame.origin.y = 0;
                [view setFrame: frame];
            }
        }
        
        [placeLabel setText: @"Place"];
        [bibLabel setText: @"Bib"];
        [firstNameLabel setText: @"First Name"];
        [lastNameLabel setText: @"Last Name"];
        [genderLabel setText: @"G"];
        [cityLabel setText: @"City"];
        [stateLabel setText: @"State"];
        [countryLabel setText: @"Country"];
        [clockTimeLabel setText: @"Clock Time"];
        [chipTimeLabel setText: @"Chip Time"];
        [paceLabel setText: @"Pace"];
        [ageLabel setText: @"Age"];
        [agePercentageLabel setText: @"Age Percentage"];
        
        [d13 setHidden: YES];
        [self.contentView setBackgroundColor: [UIColor colorWithWhite:0.8f alpha:1.0f]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(isHeader){
        [super setSelected:NO animated:NO];
    }else{
        [super setSelected:selected animated:animated];
        if(selected){
            for(UIView *view in self.contentView.subviews){
                if([view isKindOfClass: [UILabel class]])
                    [(UILabel *)view setTextColor: [UIColor whiteColor]];
            }
        }else{
            for(UIView *view in self.contentView.subviews){
                if([view isKindOfClass: [UILabel class]])
                    [(UILabel *)view setTextColor: [UIColor blackColor]];
            }
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(isHeader){
        [super setHighlighted:NO animated:NO];
    }else{
        [super setHighlighted:highlighted animated:animated];
        if(highlighted){
            for(UIView *view in self.contentView.subviews){
                if([view isKindOfClass: [UILabel class]])
                    [(UILabel *)view setTextColor: [UIColor whiteColor]];
            }
        }else{
            for(UIView *view in self.contentView.subviews){
                if([view isKindOfClass: [UILabel class]])
                    [(UILabel *)view setTextColor: [UIColor blackColor]];
            }
        }
    }
}

@end
