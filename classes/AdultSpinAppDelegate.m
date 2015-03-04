//
//  SpinAppDelegate.m
//
//  Created by Chris on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import "AdultSpinAppDelegate.h"
#import "AdultSpinViewController.h"
#import <RevMobAds/RevMobAds.h>

@implementation AdultSpinAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    [RevMobAds startSessionWithAppID:@"528ea284a017fd718f000020"];

    // Override point for customization after app launch
//    [window addSubview:viewController.view];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[RevMobAds session] showFullscreen];
    
}


- (void)dealloc {
    [self.viewController release];
    [self.window release];
    [super dealloc];
}


@end
