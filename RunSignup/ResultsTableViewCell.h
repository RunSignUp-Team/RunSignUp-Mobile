//
//  ResultsTableViewCell.h
//  RunSignup
//
//  Created by Billy Connolly on 1/1/14.
//
//

#import <UIKit/UIKit.h>

@interface ResultsTableViewCell : UITableViewCell{
    UILabel *placeLabel;
    UILabel *bibLabel;
    UILabel *firstNameLabel;
    UILabel *lastNameLabel;
    UILabel *genderLabel;
    UILabel *cityLabel;
    UILabel *stateLabel;
    UILabel *countryLabel;
    UILabel *clockTimeLabel;
    UILabel *chipTimeLabel;
    UILabel *paceLabel;
    UILabel *ageLabel;
    UILabel *agePercentageLabel;
    
    BOOL isHeader;
    
    UIView *d1;
    UIView *d2;
    UIView *d3;
    UIView *d4;
    UIView *d5;
    UIView *d6;
    UIView *d7;
    UIView *d8;
    UIView *d9;
    UIView *d10;
    UIView *d11;
    UIView *d12;
    UIView *d13;
    UIView *d14;
}

@property (nonatomic, retain) UILabel *placeLabel;
@property (nonatomic, retain) UILabel *bibLabel;
@property (nonatomic, retain) UILabel *firstNameLabel;
@property (nonatomic, retain) UILabel *lastNameLabel;
@property (nonatomic, retain) UILabel *genderLabel;
@property (nonatomic, retain) UILabel *cityLabel;
@property (nonatomic, retain) UILabel *stateLabel;
@property (nonatomic, retain) UILabel *countryLabel;
@property (nonatomic, retain) UILabel *clockTimeLabel;
@property (nonatomic, retain) UILabel *chipTimeLabel;
@property (nonatomic, retain) UILabel *paceLabel;
@property (nonatomic, retain) UILabel *ageLabel;
@property (nonatomic, retain) UILabel *agePercentageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setIsHeader:(BOOL)header;

@end
