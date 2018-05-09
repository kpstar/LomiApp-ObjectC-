//
//  CUIViewSelectWUnit.m
//  LomiApp
//
//  Created by TwinkleStar on 12/5/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewSelectWUnit.h"
#import "CConstant.h"

@implementation CUIViewSelectWUnit

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickPounds:(id)sender
{
    id<CUIViewSelectWUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onWUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onWUnitSelected:self type:0 didChooseUnit:WUNIT_POUNDS];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickKilograms:(id)sender
{
    id<CUIViewSelectWUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onWUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onWUnitSelected:self type:0 didChooseUnit:WUNIT_KILOGRAMS];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];

}
@end
