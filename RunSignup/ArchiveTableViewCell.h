//
//  ArchiveTableViewCell.h
//  RunSignup
//
//  Created by Billy Connolly on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveTableViewCell : UITableViewCell{
    UIImageView *dataTypeImage;
    UILabel *raceNameLabel;
    UILabel *dateLabel;
}

@property (nonatomic, retain) UIImageView *dataTypeImage;
@property (nonatomic, retain) UILabel *raceNameLabel;
@property (nonatomic, retain) UILabel *dateLabel;

- (void)setType:(int)type;

@end
