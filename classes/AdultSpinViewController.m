//
//  SpinViewController.m
//
//  Created by Chris on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import "AdultSpinViewController.h"
#import "UIView-GetImageOf.h"
#import "UIImage+Resize.h"
#import "MyPickerView.h"
#import <AudioToolbox/AudioToolbox.h>

#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>
#import <RevMobAds/RevMobAds.h>

@interface UIImage ()
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
@end

@implementation AdultSpinViewController

@synthesize animatedImageView;
@synthesize animatedImageView2;
@synthesize longPicker;
@synthesize shortPicker;
@synthesize spinButton;
@synthesize component1Data;
@synthesize component2Data;
@synthesize component3Data;
@synthesize component1Labels;
@synthesize component2Labels;
@synthesize component3Labels;
@synthesize component1BlurredLabels;
@synthesize component2BlurredLabels;
@synthesize component3BlurredLabels;
@synthesize component1DataShort;
@synthesize component2DataShort;
@synthesize component3DataShort;
@synthesize component1LabelsShort;
@synthesize component2LabelsShort;
@synthesize component3LabelsShort;


- (void)unhideShortPicker
{
	shortPicker.hidden = NO;
	longPicker.hidden = YES;
}

- (void)stopBlurring
{
	isSpinning = NO;
    
    [animatedImageView2 stopAnimating];
}

- (void)slowBlurring
{
    [animatedImageView stopAnimating];
    
    animatedImageView2.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"blur_4.png"],
                                         [UIImage imageNamed:@"blur_5.png"],
                                         [UIImage imageNamed:@"blur_6.png"],
                                         [UIImage imageNamed:@"blur_7.png"],
                                         [UIImage imageNamed:@"blur_8.png"],
                                         [UIImage imageNamed:@"blur_9.png"], nil];
    
    animatedImageView2.animationDuration = 1.0f;
    animatedImageView2.animationRepeatCount = -1;
    [animatedImageView2 startAnimating];
}

- (void)playSounds
{
	isSpinning = NO;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"end" ofType:@"aif"];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
	AudioServicesPlaySystemSound (soundID);
	
	//AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
	
- (IBAction)spin
{	
	if (! isSpinning)
	{
		shortPicker.hidden = YES;
		longPicker.hidden = NO;
		
        // Calculate a random index in the array
		spin1 = arc4random()%[component1Data count];
		spin2 = arc4random()%[component2Data count];
		spin3 = arc4random()%[component3Data count];
		
		// Put first and third component near top, second near bottom
		[longPicker selectRow:([longPicker selectedRowInComponent:0]%[component1Data count]) + [component1Data count] inComponent:0 animated:NO];
		[longPicker selectRow:(kRowMultiplier - 2) * [component2Data count] + spin2 inComponent:1 animated:NO];
		[longPicker selectRow:([longPicker selectedRowInComponent:2]%[component3Data count]) + [component3Data count] inComponent:2 animated:NO];
		
		// Spin to the selected value
		[longPicker selectRow:(kRowMultiplier - 2) * [component1Data count] + spin1 inComponent:0 animated:YES];
		[longPicker selectRow:spin2 + [component2Data count] inComponent:1 animated:YES];
		[longPicker selectRow:(kRowMultiplier - 2) * [component3Data count] + spin3 inComponent:2 animated:YES];
        
        
		[shortPicker selectRow:(kRowMultiplier - 2) * [component1Data count] + spin1 inComponent:0 animated:YES];
		[shortPicker selectRow:spin2 + [component2Data count] inComponent:1 animated:YES];
		[shortPicker selectRow:(kRowMultiplier - 2) * [component3Data count] + spin3 inComponent:2 animated:YES];
		
		// Set Slow Mode
		isSpinning = YES;
        
        animatedImageView.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"blur_0.png"],
                                             [UIImage imageNamed:@"blur_1.png"],
                                             [UIImage imageNamed:@"blur_2.png"],
                                             [UIImage imageNamed:@"blur_3.png"],nil];
       
        animatedImageView.animationDuration = 1.0f;
        animatedImageView.animationRepeatCount = -1;
        [animatedImageView startAnimating];
        
		// Need to have it stop blurring a fraction of a second before it stops spinning so that the final appearance is not blurred.
        [self performSelector:@selector(slowBlurring) withObject:nil afterDelay:4.2];
		[self performSelector:@selector(stopBlurring) withObject:nil afterDelay:5.0];
		[self performSelector:@selector(unhideShortPicker) withObject:nil afterDelay:5.0];
		[self performSelector:@selector(playSounds) withObject:nil afterDelay:5.099];
		
        NSString *path = [[NSBundle mainBundle] pathForResource:@"spin" ofType:@"aif"];
		SystemSoundID soundID;
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
		AudioServicesPlaySystemSound (soundID);
    }
}

- (NSArray *)arrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker
{
	NSString *arrayName = (thePicker == longPicker) ? [NSString stringWithFormat:@"component%dLabels", index+1] : [NSString stringWithFormat:@"component%dLabelsShort", index+1];
    
    NSArray * arry = [self valueForKey:arrayName];

	return arry;
}

- (NSArray *)blurredArrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker
{
	NSString *arrayName = (thePicker == longPicker) ? [NSString stringWithFormat:@"component%dBlurredLabels", index+1] : [NSString stringWithFormat:@"component%dLabelsShort", index+1];
	return [self valueForKey:arrayName];
}
#pragma mark -

- (NSArray *)blurredLabelArrayFromLabelArray:(NSArray *)labelArray
{
    return labelArray;

/*
	NSMutableArray *blurred = [NSMutableArray array];
	for (UILabel *oneLabel in labelArray)
	{
		UIImage *image = [oneLabel getAsImage];
		UIImage *scaledImage = [image resizedImage:CGSizeMake(image.size.width / 5.0, image.size.width / 5.0) interpolationQuality:3.0];
		UIImage *labelImage = [scaledImage resizedImage:image.size interpolationQuality:3.0];
		UIImageView *labelView = [[UIImageView alloc] initWithImage:labelImage];
		[blurred addObject:labelView];
		[labelView release];
	}
	return blurred;
*/
}

- (NSArray *)labelArrayFromStringArray:(NSArray *)stringArray
{
    return stringArray;
/*
	NSMutableArray *labels = [NSMutableArray array];
	for (NSString *oneValue in stringArray)
	{
		UILabel *tempLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 25.0)];
		tempLabel.text = oneValue;
		tempLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
		//tempLabel.font = [UIFont boldSystemFontOfSize:14.0];
		tempLabel.backgroundColor = [UIColor clearColor];
		//tempLabel.textColor = [UIColor redColor];
		tempLabel.textAlignment = UITextAlignmentCenter;
		[labels addObject:tempLabel];
		[tempLabel release];
	}
	return labels;
*/
}
#pragma mark -

-(void)startAccelerometerData{
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = kUpdateInterval;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {

//        NSLog(@"x:= %f y:= %f z:= %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y,accelerometerData.acceleration.z);
        if (fabsf(accelerometerData.acceleration.x) > kAccelerationThreshold
            || fabsf(accelerometerData.acceleration.y) > kAccelerationThreshold
            || fabsf(accelerometerData.acceleration.z) > kAccelerationThreshold) {
            [self spin];
        }
        
    } ];
}

- (void)viewDidLoad
{
    
//	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
//	accel.delegate = self;
//	accel.updateInterval = kUpdateInterval;
	
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float >= 7.0)
    {
        self.overlayView.hidden = YES;
        self.shortPicker.frame = CGRectMake(7, 44, 306, 216);
    }
    else {
        
//        CALayer* mask = [[CALayer alloc] init];
//        [mask setBackgroundColor: [UIColor redColor].CGColor];
//        [mask setFrame:  CGRectMake(10.0f, 10.0f, 260.0f, 196.0f)];
//        [mask setCornerRadius: 5.0f];
//        [self.shortPicker.layer setMask: mask];
//        [mask release];
    }
    
    
    [self startAccelerometerData];
    
	isSpinning = NO;
	
    // Dummy data to display
	self.component1Data = [NSArray arrayWithObjects:@"Kiss", @"Fondle", @"Squeeze", @"Massage", @"Touch", @"Lick", @"Stroke", @"Rub", @"Suck", @"Tease", nil];
	self.component2Data = [NSArray arrayWithObjects:@"Breasts", @"Her Private", @"His Butt", @"Inner Thigh", @"Nipples", @"Face", @"Ur Choice", @"His Private", @"Shoulders", @"Lips", @"Cheek",@"Foot", @"Back", @"His Jewels", @"Neck", @"Her Butt", nil];
	self.component3Data = [NSArray arrayWithObjects:@"In Bedroom", @"45 Sec", @"Softly", @"15 Sec", @"Slowly", @"1 Min", @"On The Bed", @"30 Sec", @"2 Min", @"Gently", nil];
	
	// Create UILabels out of them
	self.component1Labels = [self labelArrayFromStringArray:component1Data];
	self.component2Labels = [self labelArrayFromStringArray:component2Data];
	self.component3Labels = [self labelArrayFromStringArray:component3Data];
	
	// Create blurred UIImageViews out of the labels - we don't want to be blurring every time, so we do on load and cache
	self.component1BlurredLabels = [self blurredLabelArrayFromLabelArray:component1Labels];
    self.component2BlurredLabels = [self blurredLabelArrayFromLabelArray:component2Labels];
	self.component3BlurredLabels = [self blurredLabelArrayFromLabelArray:component3Labels];
	
	self.component1DataShort = [NSArray arrayWithObjects:@"Kiss", @"Fondle", @"Squeeze", @"Massage", @"Touch", @"Lick", @"Stroke", @"Rub", @"Suck", @"Tease", nil];
	self.component2DataShort = [NSArray arrayWithObjects:@"Breasts", @"Her Private", @"His Butt", @"Inner Thigh", @"Nipples", @"Face", @"Ur Choice", @"His Private", @"Shoulders", @"Lips", @"Cheek", @"Foot", @"Back", @"His Jewels", @"Neck", @"Her Butt", nil];
	self.component3DataShort = [NSArray arrayWithObjects:@"In Bedroom", @"45 Sec", @"Softly", @"15 Sec", @"Slowly", @"1 Min", @"On The Bed", @"30 Sec", @"2 Min", @"Gently", nil];
	self.component1LabelsShort = [self labelArrayFromStringArray:component1DataShort];
	self.component2LabelsShort = [self labelArrayFromStringArray:component2DataShort];
	self.component3LabelsShort = [self labelArrayFromStringArray:component3DataShort];

	[longPicker selectRow: [component1Data count] * (kRowMultiplier / 2) inComponent:0 animated:NO];
	[longPicker selectRow: [component2Data count] * (kRowMultiplier / 2) inComponent:1 animated:NO];
	[longPicker selectRow: [component3Data count] * (kRowMultiplier / 2) inComponent:2 animated:NO];
	[shortPicker selectRow: [component1Data count] * (kRowMultiplier / 2) inComponent:0 animated:NO];
	[shortPicker selectRow: [component2Data count] * (kRowMultiplier / 2) inComponent:1 animated:NO];
	[shortPicker selectRow: [component3Data count] * (kRowMultiplier / 2) inComponent:2 animated:NO];
	
    [super viewDidLoad];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo
{
    [[RevMobAds session] showFullscreen];

	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)dealloc 
{
	[longPicker release];
	[shortPicker release];
	[spinButton release];
	[component1Data release];
	[component2Data release];
	[component3Data release];
	[component1Labels release];
	[component2Labels release];
	[component3Labels release];
    [animatedImageView release];
    [animatedImageView2 release];
	[component1BlurredLabels release];
	[component2BlurredLabels release];
	[component3BlurredLabels release];
 
    [super dealloc];
}
#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	int actualRow = row%[[self arrayForComponent:component inPicker:pickerView] count];

//	if (!isSpinning)
//	{
//        NSArray *componentArray = [self arrayForComponent:component inPicker:pickerView];
//        return [componentArray objectAtIndex:actualRow];
//    }
//	
//	NSArray *componentArray = [self blurredArrayForComponent:component inPicker:pickerView];
//	return [componentArray objectAtIndex:actualRow];

	
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 70, 25);
        pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    }
    
    NSArray *componentArray = [self arrayForComponent:component inPicker:pickerView];
    NSString * title = [componentArray objectAtIndex:actualRow];
    [pickerLabel setText:title];
    
    
    return pickerLabel;
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    int actualRow = row%[[self arrayForComponent:component inPicker:pickerView] count];
	
	if (!isSpinning)
	{
        NSArray *componentArray = [self arrayForComponent:component inPicker:pickerView];
        return [componentArray objectAtIndex:actualRow];
    }
	
	NSArray *componentArray = [self blurredArrayForComponent:component inPicker:pickerView];
	return [componentArray objectAtIndex:actualRow];

}
*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	NSLog(@"Did select row %d in component %d", row, component);
	NSArray *componentArray = [self arrayForComponent:component inPicker:pickerView];
	int actualRow = row%[componentArray count];
	
	int newRow = ([componentArray count] * (kRowMultiplier / 2)) + actualRow;
	[longPicker selectRow:newRow inComponent:component animated:NO];
	[shortPicker selectRow:newRow inComponent:component animated:NO];

}
#pragma mark -
#pragma mark UIPickerViewDatasource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[self arrayForComponent:component inPicker:pickerView] count] * kRowMultiplier;
	
}

@end