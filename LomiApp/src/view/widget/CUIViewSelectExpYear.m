//
//  CUIViewSelectExpYear.m
//  LomiApp
//
//  Created by Aquari on 23/02/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import "CUIViewSelectExpYear.h"
#import "CGlobal.h"

@implementation CUIViewSelectExpYear

- (IBAction)onClickDone:(id)sender {
    id<CUIViewSelectExpYearDelegate> strongDelegate = self.delegate;
    if([strongDelegate respondsToSelector:@selector(onExpYearSelected:type:didChooseExpYear:)])
    {
        [strongDelegate onExpYearSelected:self type:self.m_nType didChooseExpYear:self.m_nCurSelectedIndex * self.m_nGap + self.m_nMinYear];
    }
    
    [self removeFromSuperview];
}

- (IBAction)onClickCancel:(id)sender {
    [self removeFromSuperview];
}

-(void)initData:(NSInteger)type title:(NSString *)title lunit:(NSInteger)lunit defaultValue:(NSInteger)year maxValue:(NSInteger)max minValue:(NSInteger)min Gap:(NSInteger)gap
{
    self.m_nType = type;
    self.m_lblTitle.text = title;
    self.m_nMaxYear = max;
    self.m_nMinYear = min;
    self.m_nGap = gap;
    
    [self.m_ctrlPicker reloadAllComponents];
    
    self.m_nCurSelectedIndex = (year - self.m_nMinYear) / self.m_nGap;
    [self.m_ctrlPicker selectRow:self.m_nCurSelectedIndex inComponent:0 animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView * )pickerView
{
    return 1;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    title = [NSString stringWithFormat:@"%d", self.m_nMinYear + row * self.m_nGap];
    
    return title;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (self.m_nMaxYear - self.m_nMinYear) / self.m_nGap + 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.m_nCurSelectedIndex = row;
}
@end
