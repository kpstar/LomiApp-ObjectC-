//
//  Header.h
//  LomiApp
//
//  Created by Aquari on 24/02/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUIViewSelectExpMonthDelegate;

@interface CUIViewSelectExpMonth : UIView
@property (nonatomic, weak) id<CUIViewSelectExpMonthDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *m_ctrlPicker;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property NSInteger m_nCurSelectedIndex;
@property NSInteger m_nMaxM;
@property NSInteger m_nMinYear;
@property NSInteger m_nType;
@property NSInteger m_nGap;
@property NSArray* m_arrMonth;

- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickCancel:(id)sender;

- (void)initData:(NSInteger)type title:(NSString*)title defaultValue:(NSInteger)year maxValue:(NSInteger)max minValue:(NSInteger)min Gap:(NSInteger)gap;
@end

@protocol CUIViewSelectExpMonthDelegate<NSObject>
-(void)onExpMonthSelected:(CUIViewSelectExpMonth*)viewExpYear type:(NSInteger)type didChooseExpYear:(NSInteger)value;
@end
