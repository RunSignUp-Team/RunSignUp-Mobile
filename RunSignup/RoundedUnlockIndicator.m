//
//  RoundedLoadingIndicator.m
//  RunSignup
//
//  Created by Billy Connolly on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundedLoadingIndicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedLoadingIndicator
@synthesize activity;
@synthesize label;

- (id)initWithYLocation:(int)loc{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self = [super initWithFrame:CGRectMake(80, loc, 160, 100)];
    else
        self = [super initWithFrame:CGRectMake(402, loc + 40, 160, 100)];
    if(self){
        self.activity = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(62, 20, 36, 36)];
        self.label = [[UILabel alloc] initWithFrame: CGRectMake(10, 70, 140, 20)];
        [label setFont: [UIFont systemFontOfSize: 18.0f]];
        
        [activity setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhiteLarge];
        [activity setBackgroundColor: [UIColor clearColor]];
        [activity startAnimating];
        [self addSubview: activity];
        
        [label setBackgroundColor: [UIColor clearColor]];
        [label setTextColor: [UIColor whiteColor]];
        [label setTextAlignment: UITextAlignmentCenter];
        [label setText: @"Signing in..."];
        [self addSubview: label];
        
        [self setBackgroundColor: [UIColor colorWithWhite:0.2f alpha:1.0f]];
        self.layer.cornerRadius = 10.0f;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(1, 0);
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = .25;
        
        [self setHidden: YES];
        [self setAlpha: 0.0f];
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
