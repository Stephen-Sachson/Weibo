//
//  WeiboAppDelegate.m
//  Weibo
//
//  Created by Stephen on 4/22/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import "WeiboAppDelegate.h"
#import "WeiboViewController.h"

@implementation WeiboAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
