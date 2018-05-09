//
//  CNutritionistTableViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CNutritionistTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CNutritionistTableViewCell

@synthesize m_viewContainer, m_nTopConstraint, m_ivAvatar, m_lblName, m_ivStar1, m_ivStar2,m_ivStar3, m_ivStar4, m_ivStar5;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setData:(CNutritionistModel*)model
{
    
    [m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:model.strThumbnail]
                  placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    m_lblName.text = model.strTitle;
    
    
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
