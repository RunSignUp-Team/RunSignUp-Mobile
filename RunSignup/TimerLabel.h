//
//  TimerLabel.h
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// Timer Label is a class made to display (in a green/black style) time and hold a timer to update this
@interface TimerLabel : UILabel{
    
    NSTimer *timer;
    NSDateFormatter *formatter;
    NSDate *startDate;
    NSTimeInterval pauseTimeInterval;
    BOOL paused;
}

@property (nonatomic, retain) NSDate *startDate;

- (void)updateTimer;
- (void)startTiming;

- (NSString *)formattedTime;
- (NSTimeInterval)elapsedTime;
- (void)stopTiming;

@end
