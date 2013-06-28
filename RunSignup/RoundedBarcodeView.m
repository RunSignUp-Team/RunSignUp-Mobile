//
//  RoundedBarcodeView.m
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

#import "RoundedBarcodeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedBarcodeView
@synthesize numberLabel;

- (id)initWithYLocation:(int)loc{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self = [super initWithFrame:CGRectMake(50, loc, 220, 120)];
    else
        self = [super initWithFrame:CGRectMake(274, loc + 40, 220, 120)];
    if(self){
        UIImageView *checkImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Check.png"]];
        [checkImage setFrame: CGRectMake(94, 45, 32, 28)];
        [self addSubview: checkImage];
        
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(12, 10, 196, 20)];
        [label setFont: [UIFont systemFontOfSize: 18.0f]];
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor whiteColor]];
        [label setTextAlignment: UITextAlignmentCenter];
        [label setText:@"Bib number saved to list"];
        [self addSubview: label];
        
        self.numberLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 88, 200, 28)];
        [numberLabel setFont: [UIFont systemFontOfSize: 26.0f]];
        [numberLabel setBackgroundColor: [UIColor clearColor]];
        [numberLabel setTextColor: [UIColor whiteColor]];
        [numberLabel setTextAlignment: UITextAlignmentCenter];
        [self addSubview: numberLabel];
        
        [self setBackgroundColor: [UIColor colorWithWhite:0.2f alpha:1.0f]];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(1, 0);
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = .25;
        
        [self setHidden: YES];
        [self setAlpha: 0.0f];
        
        [self setTag: 11];
    }
    return self;
}

- (void)fadeIn{
    [self setAlpha: 0.0f];
    [self setHidden: NO];
    [UIView beginAnimations:@"RLI Fade" context:nil];
    [UIView setAnimationDuration:0.25f];
    [self setAlpha: 1.0f];
    [UIView commitAnimations];
}

- (void)fadeOut{
    [self setAlpha: 1.0f];
    [self setHidden: NO];
    [UIView beginAnimations:@"RLI Fade" context:nil];
    [UIView setAnimationDuration:0.25f];
    [self setAlpha: 0.0f];
    [UIView commitAnimations];
    [self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
