//
//  TouchViewController.m
//  MouseServerTest
//
//  Created by gauravds on 9/3/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "TouchViewController.h"
#import "AppDelegate.h"

@interface TouchViewController () <UIGestureRecognizerDelegate> {
    CGPoint oldPoints, newPoints;
    IBOutlet UISlider *slider;
    CGFloat sliderValue;
}
@end

@implementation TouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(btnRightTapped:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    //tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(btnLeftTapped:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [singleTapGestureRecognizer requireGestureRecognizerToFail: doubleTapGestureRecognizer];
    //tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
}

- (IBAction)btnLeftTapped:(id)sender {
    [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/left"]
         andResponse:NULL];
}

- (IBAction)btnRightTapped:(id)sender {
    [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/right"]
         andResponse:NULL];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        oldPoints = [recognizer locationInView:self.view];
        sliderValue = slider.value;
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        newPoints = [recognizer locationInView:self.view];
        if (newPoints.x != oldPoints.x && newPoints.y != oldPoints.y) {
            [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/movexy_%02.f_%02.f", (newPoints.x - oldPoints.x)*sliderValue,(newPoints.y - oldPoints.y)*sliderValue]
                 andResponse:NULL];
        }
        oldPoints = newPoints;
    }

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
