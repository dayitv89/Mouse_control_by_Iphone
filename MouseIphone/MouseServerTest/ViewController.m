//
//  ViewController.m
//  MouseServerTest
//
//  Created by gauravds on 9/3/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController () {
    IBOutlet UITextField *__weak txtFieldAddress;
}
@end

@implementation ViewController

- (IBAction)btnConnectTapped:(id)sender {
    if (txtFieldAddress.text) {
       [APPDELEGATE hit:txtFieldAddress.text andResponse:^(BOOL success, id data) {
           if (success) {
               APPDELEGATE.SYS_ADD = txtFieldAddress.text;
//               [self performSegueWithIdentifier:@"captureScreen" sender:self];
//               [self performSegueWithIdentifier:@"coolConcept" sender:self];
               [self performSegueWithIdentifier:@"touchMagic" sender:self];
           } else {
               [[[UIAlertView alloc] initWithTitle:@"Please enter valid IP and port"
                                           message:@"192.168.1.1:3128"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil] show];
           }
       }];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Please enter valid IP and port"
                                    message:@"192.168.1.1:3128"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end