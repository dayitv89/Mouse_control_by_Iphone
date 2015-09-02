//
//  AppDelegate.h
//  MouseServerTest
//
//  Created by gauravds on 9/3/15.
//  Copyright (c) 2015 GDS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString *SYS_ADD;

- (void)hit:(NSString*)url andResponse:(void (^) (BOOL success, id data))response;

@end


extern AppDelegate *APPDELEGATE;