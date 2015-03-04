//
//  UIView-GetImageOf.m
//  Spin
//
//  Created by Chris on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import "UIView-GetImageOf.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(GetImageOf)
- (UIImage *)getAsImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	return viewImage;
}
@end
