//
//  CUIViewSelectWeight.m
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewSelectWeight.h"
#import "CGlobal.h"

@implementation CUIViewSelectWeight

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initData:(NSInteger)type title:(NSString*)title wunit:(NSInteger)wunit defaultValue:(float)weight maxValue:(NSInteger)max minValue:(NSInteger)min fGap:(float)gap
{
    self.m_nType = type;
    self.m_lblTitle.text = title;
    self.m_nMaxWeight = max;
    self.m_nMinWeight = min;
    self.m_nWUnit = wunit;
    self.m_fGap = gap;
    
    if (self.m_nMaxWeight <= DEFAULT_MIN_WEIGHT)
        self.m_nMaxWeight = DEFAULT_MAX_WEIGHT;
    if (self.m_nMinWeight < DEFAULT_MIN_WEIGHT || self.m_nMinWeight > self.m_nMaxWeight)
        self.m_nMinWeight = DEFAULT_MIN_WEIGHT;
    
    [self.m_ctlPicker reloadAllComponents];
    
    self.m_nCurSelectedIndex = (weight - self.m_nMinWeight) / self.m_fGap;
    [self.m_ctlPicker selectRow:self.m_nCurSelectedIndex inComponent:0 animated:YES];
}


- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)onClickDone:(id)sender
{

    id<CUIViewSelectWeightDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onWeightSelected:type:didChooseWeight:)])
    {
        [strongDelegate onWeightSelected:self  type:self.m_nType didChooseWeight:self.m_nCurSelectedIndex * self.m_fGap + self.m_nMinWeight];
    }
    [self removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (self.m_nMaxWeight - self.m_nMinWeight) / self.m_fGap + 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    title = [NSString stringWithFormat:@"%.1f %@", self.m_nMinWeight + row * self.m_fGap, (NSString*)g_arrWUnitValue[self.m_nWUnit]];
    
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.m_nCurSelectedIndex = row;
}
@end
