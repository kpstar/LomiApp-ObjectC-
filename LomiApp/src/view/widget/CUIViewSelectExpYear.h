//
//  CUIViewSelectExpYear.h
//  LomiApp
//
//  Created by Aquari on 23/02/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUIViewSelectExpYearDelegate;

@interface CUIViewSelectExpYear : UIView

@property (nonatomic, weak) id<CUIViewSelectExpYearDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *m_ctrlPicker;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;

@property NSInteger m_nCurSelectedIndex;
@property NSInteger m_nMaxYear;
@property NSInteger m_nMinYear;
@property NSInteger m_nType;
@property NSInteger m_nGap;

- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickCancel:(id)sender;

- (void)initData:(NSInteger)type title:(NSString*)title lunit:(NSInteger)lunit defaultValue:(NSInteger)year maxValue:(NSInteger)max minValue:(NSInteger)min Gap:(NSInteger)gap;
@end

@protocol CUIViewSelectExpYearDelegate <NSObject>

-(void)onExpYearSelected:(CUIViewSelectExpYear*)viewExpYear type:(NSInteger)type didChooseExpYear:(NSInteger)value;
@end
