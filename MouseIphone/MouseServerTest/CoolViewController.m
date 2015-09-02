//
//  CoolViewController.m
//  MouseServerTest
//
//  Created by gauravds on 9/3/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "CoolViewController.h"
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>

@interface CoolViewController () {
    CGPoint lastPoints;
}
@property (strong, nonatomic) CMMotionManager *motionManager;
- (IBAction)btnLeft:(id)sender;
- (IBAction)btnRight:(id)sender;
@end

@implementation CoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lastPoints = CGPointMake(50, 50);
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 } else {
                                                     CGPoint motionPoints = CGPointMake(accelerometerData.acceleration.x*50 + 50, accelerometerData.acceleration.y*50 + 50);
                                                     BOOL shouldMove = (fabsf(motionPoints.x - lastPoints.x) > .5) || (fabsf(motionPoints.y - lastPoints.y) > .5);
                                                     if (shouldMove) {
                                                         [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/move_%02.f_%02.f", motionPoints.x,motionPoints.y]
                                                              andResponse:NULL];
                                                         lastPoints = motionPoints;
                                                     }
                                                 }
                                             }];
}

- (IBAction)btnLeft:(id)sender {
    [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/left"]
         andResponse:NULL];
}

- (IBAction)btnRight:(id)sender {
    [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/right"]
         andResponse:NULL];
}


#pragma mark - shake motion detection
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/center_cursor"]
             andResponse:NULL];
    }
}
@end
