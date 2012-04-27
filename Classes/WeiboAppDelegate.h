//
//  WeiboAppDelegate.h
//  Weibo
//
//  Created by Stephen on 4/22/12.
//  Copyright silicon valley 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboViewController;

@interface WeiboAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WeiboViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WeiboViewController *viewController;

@end

