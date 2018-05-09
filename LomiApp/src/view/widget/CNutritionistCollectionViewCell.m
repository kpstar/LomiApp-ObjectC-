//
//  CNutritionistCollectionViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CNutritionistCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CNutritionistCollectionViewCell

@synthesize m_viewContainer, m_nTopConstraint, m_ivAvatar, m_lblName, m_ivStar1, m_ivStar2,m_ivStar3, m_ivStar4, m_ivStar5;


- (void)setTopConstraint:(int)constraint
{
    self.m_nTopConstraint.constant = constraint;
    self.m_nTopConstraintMask.constant = constraint;
    
    [self.m_viewContainer setNeedsUpdateConstraints];
    [self.m_viewContainer layoutIfNeeded];
}

- (void)setData:(CNutritionistModel*)model
{
    
    [m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:model.strThumbnail]
                   placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    m_lblName.text = model.strTitle;
    

    if (model.recommended == YES && model.fullybooked == NO)
        [self.m_lblRecommended setHidden:false];
    else
        [self.m_lblRecommended setHidden:true];
    
    [m_ivStar1 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar2 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_red"]];

    if (model.fRateAVG < 1)
    {
        [m_ivStar1 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar2 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 2)
    {
        [m_ivStar2 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 3)
    {
        [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 4)
    {
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 4.5)
    {
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
}

@end
