//
//  CPaymentPlanCollectionViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/25/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPaymentPlanModel.h"

@interface CPaymentPlanCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_lblEconomy;
@property (weak, nonatomic) IBOutlet UIView *m_viewCell;
@property BOOL  m_bHasBorder;

- (void)setData:(CPaymentPlanModel*)pModel;
- (void)setBorder:(BOOL)border;

@end
