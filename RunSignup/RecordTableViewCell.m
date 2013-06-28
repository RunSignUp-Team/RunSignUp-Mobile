//
//  RecordTableViewCell.m
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
