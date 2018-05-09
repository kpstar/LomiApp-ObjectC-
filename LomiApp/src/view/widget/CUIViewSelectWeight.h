//
//  CUIViewSelectWeight.h
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_MAX_WEIGHT  300
#define DEFAULT_MIN_WEIGHT  40

@protocol CUIViewSelectWeightDelegate;


@interface CUIViewSelectWeight : UIView

@property (nonatomic, weak) id<CUIViewSelectWeightDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *m_ctlPicker;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property NSInteger m_nCurSelectedIndex;

@property NSInteger m_nMaxWeight;
@property NSInteger m_nMinWeight;
@property NSInteger m_nType;
@property NSInteger m_nWUnit;
@property float     m_fGap;

- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickDone:(id)sender;

- (void)initData:(NSInteger)type title:(NSString*)title wunit:(NSInteger)wunit defaultValue:(float)weight maxValue:(NSInteger)max minValue:(NSInteger)min fGap:(float)gap;

@end

@protocol CUIViewSelectWeightDelegate <NSObject>

- (void)onWeightSelected:(CUIViewSelectWeight*)viewWeight type:(NSInteger)type
           didChooseWeight:(float)value;

@end
