//
//  CaptureScreenViewController.m
//  MouseServerTest
//
//  Created by gauravds on 9/3/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "CaptureScreenViewController.h"
#import "DetectFace.h"
#import "AppDelegate.h"

@interface CaptureScreenViewController ()<DetectFaceDelegate> {
    CGSize previewSize;
}

@property (nonatomic, weak) IBOutlet UIView *previewView;
@property (nonatomic, strong) DetectFace *detectFaceController;

@end


@implementation CaptureScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    previewSize = self.previewView.frame.size;

    self.detectFaceController = [[DetectFace alloc] init];
    self.detectFaceController.delegate = self;
    self.detectFaceController.previewView = self.previewView;
    [self.detectFaceController startDetection];
}

- (void)viewWillUnload {
    [self.detectFaceController stopDetection];
    [super viewWillUnload];
}

- (void)viewDidUnload {
    [self setPreviewView:nil];
    [super viewDidUnload];
}

- (void)detectedFaceController:(DetectFace *)controller
                      features:(NSArray *)featuresArray
                   forVideoBox:(CGRect)clap
                withPreviewBox:(CGRect)previewBox {
    
    for (CIFaceFeature *ff in featuresArray) {
        // find the correct position for the square layer within the previewLayer
        // the feature box originates in the bottom left of the video frame.
        // (Bottom right if mirroring is turned on)
        CGRect faceRect = [ff bounds];
        
        //isMirrored because we are using front camera
        faceRect = [DetectFace convertFrame:faceRect previewBox:previewBox forVideoBox:clap isMirrored:YES];
        
        if (faceRect.size.width < 80) {
            [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/left"]
                 andResponse:NULL];
        } else if (faceRect.size.width > 200) {
            [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/right"]
                 andResponse:NULL];
        } else {
            CGPoint centerFace = CGPointMake(faceRect.origin.x + faceRect.size.width/2, faceRect.origin.y + faceRect.size.height/2);
            CGPoint newMousePoint = CGPointMake(centerFace.x / previewSize.width * 100, centerFace.y / previewSize.height * 100);
            [APPDELEGATE hit:[APPDELEGATE.SYS_ADD stringByAppendingFormat:@"/move_%f_%f",newMousePoint.x, newMousePoint.y]
                 andResponse:NULL];
        }
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
