//
//  CDailyPlanViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/14/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDietPlanModel.h"

@interface CDailyPlanViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_lblPeriod;
@property (weak, nonatomic) IBOutlet UILabel *m_lblType;
@property (weak, nonatomic) IBOutlet UITextView *m_tvContent;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivImage;



- (void)setData:(CDietPlanModel*)pModel;

@end
