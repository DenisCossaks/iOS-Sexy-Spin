//
//  SpinAppDelegate.h
//
//  Created by Chris on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import <UIKit/UIKit.h>

@class AdultSpinViewController;

@interface AdultSpinAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AdultSpinViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AdultSpinViewController *viewController;

@end

