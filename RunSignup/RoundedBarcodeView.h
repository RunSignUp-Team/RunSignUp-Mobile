//
//  RoundedBarcodeView.h
//  RunSignup
//
//  Created by Billy Connolly on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedBarcodeView : UIView{
    UILabel *numberLabel;
}

- (id)initWithYLocation:(int)loc;

@property (nonatomic, retain) UILabel *numberLabel;

- (void)fadeOut;
- (void)fadeIn;

@end
