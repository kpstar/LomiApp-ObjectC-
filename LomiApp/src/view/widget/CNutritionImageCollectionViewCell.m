//
//  CNutritionImageCollectionViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/16/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CNutritionImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+RoundedCorners.h"

@implementation CNutritionImageCollectionViewCell


- (void)setData:(CMessageModel*)pModel
{
    self.m_lblDate.text = pModel.date;
    [self.m_ivImage sd_setImageWithURL:[NSURL URLWithString:pModel.url]
                       placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    [self.m_ivImage setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft | UIViewRoundedCornerLowerRight radius:14];
}


@end
