//
//  CUIViewSelectLUnit.m
//  LomiApp
//
//  Created by TwinkleStar on 12/5/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewSelectLUnit.h"
#import "CConstant.h"

@implementation CUIViewSelectLUnit

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickCentimetrs:(id)sender
{
    id<CUIViewSelectLUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onLUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onLUnitSelected:self type:0 didChooseUnit:LUNIT_CENTIMETRS];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickInches:(id)sender
{
    id<CUIViewSelectLUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onLUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onLUnitSelected:self type:0 didChooseUnit:LUNIT_INCHES];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)onClickFeets:(id)sender {
    id<CUIViewSelectLUnitDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onLUnitSelected:type:didChooseUnit:)])
    {
        [strongDelegate onLUnitSelected:self type:0 didChooseUnit:LUNIT_FEETS];
    }
    [self removeFromSuperview];
}
@end
