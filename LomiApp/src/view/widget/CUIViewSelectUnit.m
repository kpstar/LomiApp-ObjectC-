//
//  CUIViewSelectUnit.m
//  LomiApp
//
//  Created by TwinkleStar on 12/5/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewSelectUnit.h"
#import "CConstant.h"

@implementation CUIViewSelectUnit

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickPounds:(id)sender
{
    id<CUIViewSelectUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onUnitSelected:self type:0 didChooseUnit:UNIT_IMPERAIL];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickKilograms:(id)sender
{
    id<CUIViewSelectUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onUnitSelected:self type:0 didChooseUnit:UNIT_CENTIMETER];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];

}
@end
