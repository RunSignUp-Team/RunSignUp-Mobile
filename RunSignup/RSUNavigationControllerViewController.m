//
//  RSUNavigationControllerViewController.m
//  RunSignup
//
//  Created by Billy Connolly on 12/30/13.
//
//

#import "RSUNavigationControllerViewController.h"

@interface RSUNavigationControllerViewController ()

@end

@implementation RSUNavigationControllerViewController
@synthesize lockToPortraitOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lockToPortraitOrientation = YES;
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        if(lockToPortraitOrientation)
            return UIInterfaceOrientationMaskPortrait;
        else{
            NSLog(@"Landscape bitch");
            return UIInterfaceOrientationMaskLandscape;
        }
    else
        return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
