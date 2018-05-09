//
//  CUIViewSelectHeight.h
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_MAX_HEIGHT  300
#define DEFAULT_MIN_HEIGHT  0

@protocol CUIViewSelectHeightDelegate;

@interface CUIViewSelectHeight : UIView

@property (nonatomic, weak) id<CUIViewSelectHeightDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *m_ctlPicker;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property NSInteger m_nCurSelectedIndex;
@property NSInteger m_nMaxHeight;
@property NSInteger m_nMinHeight;
@property NSInteger m_nType;
@property NSInteger m_nLUnit;
@property float     m_fGap;

- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickDone:(id)sender;

- (void)initData:(NSInteger)type title:(NSString*)title lunit:(NSInteger)lunit defaultValue:(float)height maxValue:(NSInteger)max minValue:(NSInteger)min fGap:(float)gap;
@end

@protocol CUIViewSelectHeightDelegate <NSObject>

- (void)onHeightSelected:(CUIViewSelectHeight*)viewHeight type:(NSInteger)type
         didChooseHeight:(float)value;

@end
