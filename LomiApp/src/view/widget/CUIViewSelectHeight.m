//
//  CUIViewSelectHeight.m
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewSelectHeight.h"
#import "CGlobal.h"

@implementation CUIViewSelectHeight

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initData:(NSInteger)type title:(NSString*)title lunit:(NSInteger)lunit defaultValue:(float)height maxValue:(NSInteger)max minValue:(NSInteger)min fGap:(float)gap
{
    self.m_nType = type;
    self.m_lblTitle.text = title;
    self.m_nMaxHeight = max;
    self.m_nMinHeight = min;
    self.m_nLUnit = lunit;
    self.m_fGap = gap;
    
    if (self.m_nMaxHeight <= DEFAULT_MIN_HEIGHT)
        self.m_nMaxHeight = DEFAULT_MAX_HEIGHT;
    if (self.m_nMinHeight < DEFAULT_MIN_HEIGHT || self.m_nMinHeight > self.m_nMaxHeight)
        self.m_nMinHeight = DEFAULT_MIN_HEIGHT;
    
    [self.m_ctlPicker reloadAllComponents];
    
    self.m_nCurSelectedIndex = ((int)height - self.m_nMinHeight) / self.m_fGap;
    [self.m_ctlPicker selectRow:self.m_nCurSelectedIndex inComponent:0 animated:YES];

}

- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)onClickDone:(id)sender
{
    
    id<CUIViewSelectHeightDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onHeightSelected:type:didChooseHeight:)])
    {
        [strongDelegate onHeightSelected:self type:self.m_nType didChooseHeight:self.m_nCurSelectedIndex * self.m_fGap + self.m_nMinHeight];
    }
    [self removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (self.m_nMaxHeight - self.m_nMinHeight) / self.m_fGap + 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    title = [NSString stringWithFormat:@"%g %@", (self.m_nMinHeight + row * self.m_fGap), (NSString*)g_arrLUnitValue[self.m_nLUnit]];
    
    if (self.m_nLUnit == LUNIT_INCHES)
    {
        int nValue = self.m_nMinHeight + row * self.m_fGap;
        int nFeet = nValue / 12;
        int nInch = nValue % 12;
        title = [NSString stringWithFormat:@"%d'%d\"", nFeet, nInch];
    }
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.m_nCurSelectedIndex = row;
}


@end
