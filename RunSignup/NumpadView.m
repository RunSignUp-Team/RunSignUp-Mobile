//
//  NumpadView.m
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

#import "NumpadView.h"

@implementation NumpadView
@synthesize button0;
@synthesize buttonBack;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;
@synthesize button7;
@synthesize button8;
@synthesize button9;
@synthesize textField;
@synthesize recordButton;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        int buttonWidth = (frame.size.width - 32) / 3;
        int buttonHeight = (frame.size.height - 40) / 4;
        
        UIImage *blueButtonImage = [UIImage imageNamed:@"BlueButton.png"];
        UIImage *stretchedBlueButton = [blueButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        UIImage *blueButtonTapImage = [UIImage imageNamed:@"BlueButtonTap.png"];
        UIImage *stretchedBlueButtonTap = [blueButtonTapImage stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        
        self.button0 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.buttonBack = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button1 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button2 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button3 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button4 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button5 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button6 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button7 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button8 = [UIButton buttonWithType: UIButtonTypeCustom];
        self.button9 = [UIButton buttonWithType: UIButtonTypeCustom];
        
        [button1 setFrame: CGRectMake(8, 8, buttonWidth, buttonHeight)];
        [button4 setFrame: CGRectMake(8, 16 + buttonHeight, buttonWidth, buttonHeight)];
        [button7 setFrame: CGRectMake(8, 24 + (2*buttonHeight), buttonWidth, buttonHeight)];
        [button0 setFrame: CGRectMake(8, 32 + (3*buttonHeight), buttonWidth * 2 + 8, buttonHeight)];
        [button2 setFrame: CGRectMake(16 + buttonWidth, 8, buttonWidth, buttonHeight)];
        [button5 setFrame: CGRectMake(16 + buttonWidth, 16 + buttonHeight, buttonWidth, buttonHeight)];
        [button8 setFrame: CGRectMake(16 + buttonWidth, 24 + (2*buttonHeight), buttonWidth, buttonHeight)];
        [button3 setFrame: CGRectMake(24 + (2*buttonWidth), 8, buttonWidth, buttonHeight)];
        [button6 setFrame: CGRectMake(24 + (2*buttonWidth), 16 + buttonHeight, buttonWidth, buttonHeight)];
        [button9 setFrame: CGRectMake(24 + (2*buttonWidth), 24 + (2*buttonHeight), buttonWidth, buttonHeight)];
        [buttonBack setFrame: CGRectMake(24 + (2*buttonWidth), 32 + (3*buttonHeight), buttonWidth, buttonHeight)];
        
        [button0 setTag: 0];
        [buttonBack setTag: 11];
        [button1 setTag: 1];
        [button2 setTag: 2];
        [button3 setTag: 3];
        [button4 setTag: 4];
        [button5 setTag: 5];
        [button6 setTag: 6];
        [button7 setTag: 7];
        [button8 setTag: 8];
        [button9 setTag: 9];
        
        [button0 setTitle:@"0" forState:UIControlStateNormal];
        [button1 setTitle:@"1" forState:UIControlStateNormal];
        [button2 setTitle:@"2" forState:UIControlStateNormal];
        [button3 setTitle:@"3" forState:UIControlStateNormal];
        [button4 setTitle:@"4" forState:UIControlStateNormal];
        [button5 setTitle:@"5" forState:UIControlStateNormal];
        [button6 setTitle:@"6" forState:UIControlStateNormal];
        [button7 setTitle:@"7" forState:UIControlStateNormal];
        [button8 setTitle:@"8" forState:UIControlStateNormal];
        [button9 setTitle:@"9" forState:UIControlStateNormal];
        
        [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button9 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [[button0 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button1 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button2 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button3 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button4 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button5 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button6 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button7 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button8 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        [[button9 titleLabel] setFont: [UIFont systemFontOfSize: 48.0f]];
        
        [button0 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button0 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [buttonBack setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [buttonBack setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button1 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button1 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button2 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button2 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button3 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button3 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button4 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button4 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button5 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button5 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button6 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button6 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button7 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button7 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button8 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button8 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        [button9 setBackgroundImage:stretchedBlueButton forState:UIControlStateNormal];
        [button9 setBackgroundImage:stretchedBlueButtonTap forState:UIControlStateHighlighted];
        
        [buttonBack setImage:[UIImage imageNamed:@"KeypadBack.png"] forState:UIControlStateNormal];
        [buttonBack setAdjustsImageWhenHighlighted: NO];
        
        [button0 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBack addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button1 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button4 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button5 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button6 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button7 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button8 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        [button9 addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview: button0];
        [self addSubview: buttonBack];
        [self addSubview: button1];
        [self addSubview: button2];
        [self addSubview: button3];
        [self addSubview: button4];
        [self addSubview: button5];
        [self addSubview: button6];
        [self addSubview: button7];
        [self addSubview: button8];
        [self addSubview: button9];
    }
    return self;
}

- (IBAction)buttonDown:(id)sender{
    int buttonTag = [sender tag];
    if(textField != nil){
        [[UIDevice currentDevice] playInputClick];
        if(buttonTag >= 0 && buttonTag <= 9 && [[textField text] length]  < 5){
            //[textField setText: [NSString stringWithFormat:@"%@%i", [textField text], buttonTag]];
            [textField setText: [[textField text] stringByAppendingFormat:@"%i", buttonTag]];
            [recordButton setEnabled: YES];
        }else{
            if(buttonTag == 10 && [[textField text] length]  < 5){
                [textField setText: [NSString stringWithFormat:@"%@-", [textField text]]];
                [recordButton setEnabled: YES];
            }else if(buttonTag == 11 && [[textField text] length] != 0){
                [textField setText: [[textField text] substringToIndex: [[textField text] length] - 1]];
                if([[textField text] length] == 0)
                    [recordButton setEnabled: NO];
            }
        }
    }
}

- (BOOL) enableInputClicksWhenVisible{
    return YES;
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
