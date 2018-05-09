//
//  CUIPopupExpire.m
//  LomiApp
//
//  Created by TwinkleStar on 1/28/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CUIPopupExpire.h"

@implementation CUIPopupExpire

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initView
{
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"prW-ff-oCK.text", @"CUIPopupExpire", @"");
    self.m_viewContent.layer.cornerRadius = 14;
}

- (IBAction)onClickYes:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)onClickNo:(id)sender {
    [self removeFromSuperview];
    exit(0);
}

- (IBAction)onClickContact:(id)sender
{
    id<CUIPopupExpireDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onClickContactUs)])
    {
        [strongDelegate onClickContactUs];
    }
}
@end
