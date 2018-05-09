//
//  CUIPopupPromotion.m
//  LomiApp
//
//  Created by Aquari on 05/03/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import "CUIPopupPromotion.h"
#import "CGlobal.h"

@implementation CUIPopupPromotion


- (void)initView
{
    self.backgroundColor=[[UIColor darkGrayColor] colorWithAlphaComponent:.6];
    self.m_viewContent.layer.cornerRadius = 14;
    self.m_viewContent.layer.shadowOpacity = 0.8;
    self.m_viewContent.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.m_btnActivate.layer.cornerRadius = 10;
    self.m_btnCancel.layer.cornerRadius = 10;
    self.m_txtPromotionCode.delegate = self;
    
    /* Class = "UITextView"; text = "Enter your promotional code below and we will contact you to activate it"; ObjectID = "8qo-jo-MYf"; */
    
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"8qo-jo-MYf.text", @"CUIPopupPromotion", @"");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    
    [self addGestureRecognizer:tap];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self endEditing:YES];
    return YES;
}

- (void)dismissView
{
    [self endEditing:YES];
    //[self removeAnimate];
}

- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}



- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


- (IBAction)onClickActivate:(id)sender {
    id<CUIPopupPromotionDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onClickPromotionCode)])
    {
        [self removeAnimate];
        [strongDelegate onClickPromotionCode];
    }
}

- (IBAction)onClickCancel:(id)sender {
    [self removeAnimate];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self showAnimate];
    }
}
@end
