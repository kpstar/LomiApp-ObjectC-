//
//  CUpdateAccountViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/20/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CPaymentPlanModel.h"
#import "CUIPopupExpire.h"
#import "CUIPopupPromotion.h"

@interface CUpdateAccountViewController : CUIViewController<CUIPopupExpireDelegate, CUIPopupPromotionDelegate, UITextViewDelegate>

@property   NSInteger   m_nSelectedIndex;

@property (strong, nonatomic) NSMutableArray *m_arrPlans;
@property (strong, nonatomic) NSMutableArray *m_arrPromotionPlans;
@property (strong, nonatomic) CPaymentPlanModel* m_pSelectedModel;
@property (strong, nonatomic) CPaymentPlanModel* m_pCurrentModel;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPlan;
@property (weak, nonatomic) IBOutlet UILabel *m_lblExpDate;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *m_lblAmount;

@property (weak, nonatomic) IBOutlet UICollectionView *m_cvPlan;
@property (weak, nonatomic) IBOutlet UIView *m_viewBtnBack;
@property (weak, nonatomic) IBOutlet UIButton *m_btnUpgrade;

@property NSTimer*  m_timerNotification;

- (IBAction)onClickPromotionCode:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickUpgradeAccount:(id)sender;

@end
