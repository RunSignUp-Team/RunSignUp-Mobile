//
//  TimerLabel.m
//  RunSignup
//
//  Created by Billy Connolly on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimerLabel.h"

@implementation TimerLabel
@synthesize startDate;

// Timer Label is a class made to display (in a green/black style) time and hold a timer to update this
- (id)initWithFrame:(CGRect)frame{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 320, 92)];
    else
        self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 576, 92)];
    if (self) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
        self.startDate = nil;
                
        [formatter setDateFormat:@"mm:ss.SS"];
        self.text = @"00:00.00";
        
        
        self.font = [UIFont systemFontOfSize: 54.0f];
        self.textAlignment = UITextAlignmentCenter;
        self.textColor = [UIColor colorWithRed:0.0f green:0.75f blue:0.0f alpha:1.0f];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (NSString *)formattedTime{
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];    
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *oldFormat = [formatter dateFormat];
    [formatter setDateFormat:@"HH:mm:ss.SS"];
    NSString *timeString = [formatter stringFromDate:timerDate];
    [formatter setDateFormat:oldFormat];
    
    return timeString;
}

- (NSTimeInterval)elapsedTime{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:startDate];
    interval = (int)(interval * 100);
    interval /= 100.0;
    return interval;
}

// Called every 1/100.0 seconds
- (void)updateTimer{
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];

    if(timeInterval >= 3600.0)
        [formatter setDateFormat:@"HH:mm:ss.SS"];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *timeString = [formatter stringFromDate:timerDate];
    self.text = timeString;
    pauseTimeInterval = timeInterval;
}

// Start timing (called by Start Race button in timer and checker)
- (void)startTiming{    
    self.startDate = [NSDate date];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0/50.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)stopTiming{
    [timer invalidate];
    timer = nil;
    [self updateTimer];
}

@end
