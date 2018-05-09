//
//  CNutritionistTableViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNutritionistModel.h"

@interface CNutritionistTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *m_viewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_nTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar1;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar2;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar3;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar4;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar5;

- (void)setData:(CNutritionistModel*)model;

@end
