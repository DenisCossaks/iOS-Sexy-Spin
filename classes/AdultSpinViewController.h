//
//  SpinViewController.h
//
//  Created by Chris on 6/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"

#define kRowMultiplier				100
#define kAccelerationThreshold		2.0
#define kUpdateInterval				(1.0f/10.0f)

@class MyPickerView;

@interface AdultSpinViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, FlipsideViewControllerDelegate>
{
    UIImageView     *animatedImageView;
    UIImageView     *animatedImageView2;
	
    MyPickerView	*longPicker;
	UIPickerView	*shortPicker;
	
	UIButton		*spinButton;
	
	NSArray			*component1Data;
	NSArray			*component2Data;
	NSArray			*component3Data;
	
	NSArray			*component1Labels;
	NSArray			*component2Labels;
	NSArray			*component3Labels;
	
	NSArray			*component1BlurredLabels;
	NSArray			*component2BlurredLabels;
	NSArray			*component3BlurredLabels;
	
	NSArray			*component1DataShort;
	NSArray			*component2DataShort;
	NSArray			*component3DataShort;
	
	NSArray			*component1LabelsShort;
	NSArray			*component2LabelsShort;
	NSArray			*component3LabelsShort;
	
	@private
	BOOL			isSpinning;
	NSUInteger		spin1;
	NSUInteger		spin2;	
	NSUInteger		spin3;

}

@property (nonatomic, retain) IBOutlet MyPickerView *longPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *shortPicker;
@property (nonatomic, retain) IBOutlet UIImageView *animatedImageView;
@property (nonatomic, retain) IBOutlet UIImageView *animatedImageView2;
@property (nonatomic, retain) IBOutlet UIButton *spinButton;
@property (nonatomic, retain) IBOutlet UIImageView * overlayView;


@property (nonatomic, retain) NSArray *component1Data;
@property (nonatomic, retain) NSArray *component2Data;
@property (nonatomic, retain) NSArray *component3Data;
@property (nonatomic, retain) NSArray *component1Labels;
@property (nonatomic, retain) NSArray *component2Labels;
@property (nonatomic, retain) NSArray *component3Labels;
@property (nonatomic, retain) NSArray *component1BlurredLabels;
@property (nonatomic, retain) NSArray *component2BlurredLabels;
@property (nonatomic, retain) NSArray *component3BlurredLabels;
@property (nonatomic, retain) NSArray *component1DataShort;
@property (nonatomic, retain) NSArray *component2DataShort;
@property (nonatomic, retain) NSArray *component3DataShort;
@property (nonatomic, retain) NSArray *component1LabelsShort;
@property (nonatomic, retain) NSArray *component2LabelsShort;
@property (nonatomic, retain) NSArray *component3LabelsShort;

- (IBAction)spin;
- (IBAction)showInfo;
- (NSArray *)blurredLabelArrayFromLabelArray:(NSArray *)labelArray;
- (NSArray *)labelArrayFromStringArray:(NSArray *)stringArray;
- (NSArray *)arrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker;
- (NSArray *)blurredArrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker;

@end

