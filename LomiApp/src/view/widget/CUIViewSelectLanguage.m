//
//  CUIViewSelectLanguage.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewSelectLanguage.h"
#import "CConstant.h"

@implementation CUIViewSelectLanguage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickEnglish:(id)sender
{
    id<CUIViewSelectLanguageDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onLanguageSelected:type:didChooseLanguage:)])
    {
        [strongDelegate onLanguageSelected:self type:0 didChooseLanguage:LAN_ENGLISH];
    }

    [self removeFromSuperview];
}

- (IBAction)onClickArabic:(id)sender
{
    id<CUIViewSelectLanguageDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onLanguageSelected:type:didChooseLanguage:)])
    {
        [strongDelegate onLanguageSelected:self type:0 didChooseLanguage:LAN_ARABIC];
    }
    [self removeFromSuperview];
}

- (IBAction)onClickCancel:(id)sender
{
    [self removeFromSuperview];
}
@end
