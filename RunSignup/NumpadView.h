//
//  NumpadView.h
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

#import <UIKit/UIKit.h>

@interface NumpadView : UIView <UIInputViewAudioFeedback>{
    UIButton *button0;
    UIButton *buttonCamera;
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
