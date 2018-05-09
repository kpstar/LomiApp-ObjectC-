//
//  CPaymentPlanCollectionViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/25/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CPaymentPlanCollectionViewCell.h"

@implementation CPaymentPlanCollectionViewCell

- (void)setData:(CPaymentPlanModel*)pModel
{
    if ([pModel.packageTitle containsString:@"week"] || [pModel.packageTitle containsString:@"month"])
    {
        self.m_lblTitle.text = pModel.packageTitle;
    }
    else
    {
        self.m_lblTitle.text = [NSString stringWithFormat:@"%@ (%ld %@)",  pModel.packageTitle, (long)pModel.packageDuration, pModel.packageDurationType];
    }
    self.m_lblPrice.text = [NSString stringWithFormat:@"$ %g", pModel.packagePrice];
    
    NSString* strImageName = [NSString stringWithFormat:@"icon_%ldmonth", (long)pModel.packageDuration];
    if ([pModel.packageDurationType isEqualToString:@"week"])
        strImageName = [NSString stringWithFormat:@"icon_%ldweek", (long)pModel.packageDuration];
    
    UIImage * image = [UIImage imageNamed:strImageName];
    if (image == nil)
        image = [UIImage imageNamed:@"icon_6month"];
    
    self.m_ivIcon.image = image;//[UIImage imageNamed:strImageName];
    self.m_lblEconomy.text = pModel.packageDescription;
}

- (void)setBorder:(BOOL)border
{
    self.m_bHasBorder = border;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.m_bHasBorder)
        self.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] CGColor];
    else
        self.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(255.0f / 255) blue:(255.0f / 255) alpha:1] CGColor];
}

@end
