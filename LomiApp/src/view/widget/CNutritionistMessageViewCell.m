//
//  CNutritionistMessageViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/14/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CNutritionistMessageViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+RoundedCorners.h"

@implementation CNutritionistMessageViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setData:(CMessageModel*)pModel
{
    if (pModel.isForMessage)
    {
        [self.m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:pModel.thumbnail]
                           placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
        self.m_tvMessage.text = pModel.body;
        self.m_lblTime.text = pModel.date;
    }
    else
    {
        [self.m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:pModel.commentImage]
                           placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
        self.m_tvMessage.text = pModel.bodyText;
        self.m_lblTime.text = pModel.commentDate;
    }
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    [self.m_viewMessage setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft | UIViewRoundedCornerLowerRight radius:14];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.frame;
}

@end
