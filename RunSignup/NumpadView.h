//
//  NumpadView.h
//  RunSignup
//
//  Created by Billy Connolly on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumpadView : UIView{
    UIButton *button0;
    UIButton *buttonCamera;
    UIButton *buttonDash;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    UIButton *button6;
    UIButton *button7;
    UIButton *button8;
    UIButton *button9;
    
    UITextField *textField;
    UIButton *recordButton;
}

- (IBAction)buttonDown:(id)sender;

@property (nonatomic, retain) UIButton *button0;
@property (nonatomic, retain) UIButton *buttonDash;
@property (nonatomic, retain) UIButton *buttonBack;
@property (nonatomic, retain) UIButton *button1;
@property (nonatomic, retain) UIButton *button2;
@property (nonatomic, retain) UIButton *button3;
@property (nonatomic, retain) UIButton *button4;
@property (nonatomic, retain) UIButton *button5;
@property (nonatomic, retain) UIButton *button6;
@property (nonatomic, retain) UIButton *button7;
@property (nonatomic, retain) UIButton *button8;
@property (nonatomic, retain) UIButton *button9;

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIButton *recordButton;

@end
