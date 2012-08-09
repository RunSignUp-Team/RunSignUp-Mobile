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

// Create RecordTableViewCell. Mode is 0 for Timer, 1 for Checker, 2 for Chute
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMode:(int)mode{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){     
        self.shouldIndentWhileEditing = YES;
        
        if(mode == 1){
            self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 8, 160, 28)];
            [dataLabel setFont: [UIFont systemFontOfSize: 26.0f]];
            [dataLabel setTextColor: [UIColor blackColor]];
            [self.contentView addSubview: dataLabel];
        }else{
            self.dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 200, 28)];
            [dataLabel setFont: [UIFont systemFontOfSize: 26.0f]];
            [dataLabel setTextColor: [UIColor blackColor]];
            [self.contentView addSubview: dataLabel];
        }
        
        [self.textLabel setBackgroundColor: [UIColor clearColor]];
        
        if(mode == 1){
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(110, 0, 1, 44)];
            [divider setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]]; // 0.878 grabbed from screenshot to match UITableView
            [self.contentView addSubview: divider];
        }else{
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 1, 44)];
            [divider setBackgroundColor: [UIColor colorWithWhite:0.878f alpha:1.0f]]; // 0.878 grabbed from screenshot to match UITableView
            [self.contentView addSubview: divider];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:NO animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted){
        [dataLabel setTextColor:[UIColor whiteColor]];
    }else{
        [dataLabel setTextColor: [UIColor blackColor]];
    }
    [super setHighlighted:highlighted animated:animated];
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
