//
//  CUIPopupExpire.h
//  LomiApp
//
//  Created by TwinkleStar on 1/28/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CUIPopupExpireDelegate;


@interface CUIPopupExpire : UIView

@property (nonatomic, weak) id<CUIPopupExpireDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (weak, nonatomic) IBOutlet UIView *m_viewContent;

- (IBAction)onClickYes:(id)sender;
- (IBAction)onClickNo:(id)sender;
- (IBAction)onClickContact:(id)sender;

- (void)initView;


@end

@protocol CUIPopupExpireDelegate <NSObject>

- (void)onClickContactUs;

@end
