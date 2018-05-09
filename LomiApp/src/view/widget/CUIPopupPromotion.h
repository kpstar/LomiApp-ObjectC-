//
//  CUIPopupPromotion.h
//  LomiApp
//
//  Created by Aquari on 05/03/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CUIPopupPromotionDelegate;

@interface CUIPopupPromotion : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<CUIPopupPromotionDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (weak, nonatomic) IBOutlet UIView *m_viewContent;
@property (weak, nonatomic) IBOutlet UIButton *m_btnActivate;
@property (weak, nonatomic) IBOutlet UIButton *m_btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPromotionCode;

- (IBAction)onClickActivate:(id)sender;
- (IBAction)onClickCancel:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField;
- (void)initView;

- (void)showInView:(UIView * )aView animated:(BOOL)animated;
@end

@protocol CUIPopupPromotionDelegate <NSObject>

- (void)onClickPromotionCode;
@end
