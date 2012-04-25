//
//  RecordTableViewCell.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell
@synthesize dataLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMode:(int)mode{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){     
        self.shouldIndentWhileEditing = YES;
        
        if(mode == 0){
            self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 12, 200, 28)];
        }else if(mode == 1){
            self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 7, 200, 28)];
        }else{
            self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 12, 200, 28)];
        }
        [dataLabel setFont: [UIFont systemFontOfSize: 26.0f]];
        [dataLabel setTextColor: [UIColor blackColor]];
        [self addSubview: dataLabel];
        
        /*self.placeLabel = [[UILabel alloc] initWithFrame: CGRectMake(60, 12, 220, 20)];
        [placeLabel setFont: [UIFont systemFontOfSize:18.0f]];
        [placeLabel setBackgroundColor: [UIColor clearColor]];
        [placeLabel setText:@"Place #                   Bib #"];
        [placeLabel setTextColor: [UIColor lightGrayColor]];
        [self addSubview: placeLabel];*/
        
        UIView *divider;
        if(mode == 0){
            divider = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 1, 54)];
        }else if(mode == 1){
            divider = [[UIView alloc] initWithFrame:CGRectMake(130, 0, 1, 44)];
        }else{
            divider = [[UIView alloc] initWithFrame:CGRectMake(105, 0, 1, 44)];
        }
        
        [divider setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]]; // 0.878 grabbed from screenshot to match uitableview HRs
        [self addSubview: divider];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:NO animated:animated];
}

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if(editing && animated && placeLabel != nil){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.25f];
        [placeLabel setAlpha: 0];
        [UIView commitAnimations];
    }else if(animated && placeLabel != nil){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.25f];
        [placeLabel setAlpha: 1];
        [UIView commitAnimations];
    }
}
*/
@end
