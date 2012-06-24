//
//  RoundedLoadingIndicator.h
//  RunSignup
//
//  Created by Billy Connolly on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedLoadingIndicator : UIView{
    UIActivityIndicatorView *activity;
    UILabel *label;
}

- (id)initWithYLocation:(int)loc;

@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) UILabel *label;

- (void)fadeOut;
- (void)fadeIn;

@end
