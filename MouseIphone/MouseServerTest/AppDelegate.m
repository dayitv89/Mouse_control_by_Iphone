//
//  AppDelegate.m
//  MouseServerTest
//
//  Created by gauravds on 9/3/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import "AppDelegate.h"

AppDelegate *APPDELEGATE;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    APPDELEGATE = self;
    application.applicationSupportsShakeToEdit = YES;
    return YES;
}

- (void)hit:(NSString*)strUrl andResponse:(void (^) (BOOL success, id data))response {
    if (![strUrl hasPrefix:@"http://"]) {
        strUrl = [NSString stringWithFormat:@"http://%@", strUrl];
    }
//    NSLog(@"%@", strUrl);
    NSError *error;
    NSString *jsonStr = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:strUrl]
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (response) {
        if (!error && jsonStr) {
            response(YES, jsonStr);
        } else {
            response(NO, error);
        }
    }
}

@end
