//
//  CUIViewStarRate.m
//  LomiApp
//
//  Created by TwinkleStar on 12/19/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewStarRate.h"

@implementation CUIViewStarRate

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initData:(NSInteger)type title:(NSString*)title defaultValue:(CGFloat)value
{
    self.m_nType = type;
    self.m_lblTitle.text = title;
    [self.m_viewStarRate setValue:value];
}

- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)onClickRate:(id)sender
{
    id<CUIViewStarRateDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onRateSelected:type:didChooseRate:)])
    {
        [strongDelegate onRateSelected:self type:self.m_nType didChooseRate:self.m_viewStarRate.value];
    }
    [self removeFromSuperview];
}

@end
