//
//  CUIViewSelectExpMonth.m
//  LomiApp
//
//  Created by Aquari on 24/02/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import "CUIViewSelectExpMonth.h"
#import "CGlobal.h"

@implementation CUIViewSelectExpMonth
- (IBAction)onClickDone:(id)sender {
    id<CUIViewSelectExpMonthDelegate> strongDelegate = self.delegate;
    if([strongDelegate respondsToSelector:@selector(onExpMonthSelected:type:didChooseExpYear:)])
    {
        [strongDelegate onExpMonthSelected:self type:self.m_nType didChooseExpYear:self.m_nCurSelectedIndex * self.m_nGap + 1];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickCancel:(id)sender {
    [self removeFromSuperview];
}

-(void)initData:(NSInteger)type title:(NSString *)title defaultValue:(NSInteger)month maxValue:(NSInteger)max minValue:(NSInteger)min Gap:(NSInteger)gap
{
    self.m_nType = type;
    self.m_nGap = gap;
    
    self.m_arrMonth = [NSArray arrayWithObjects:@"01 - Jan", @"02 - Feb", @"03 - Mar", @"04 - Apr",@"05 - May", @"06 - Jun", @"07 - Jul", @"08 - Aug", @"09 - Sep", @"10 - Oct", @"11 - Nov", @"12 - Dec", nil];
    
    [self.m_ctrlPicker reloadAllComponents];
    
    self.m_nCurSelectedIndex = (month - 1) / self.m_nGap;
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
    //title = [NSString stringWithFormat:@"%d", 1 + row * self.m_nGap];
    title = self.m_arrMonth[row];
    return title;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 12;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.m_nCurSelectedIndex = row;
}
@end
