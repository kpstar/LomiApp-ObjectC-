//
//  CMyImageCollectionViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/16/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CMyImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+RoundedCorners.h"

@implementation CMyImageCollectionViewCell

- (void)setData:(CMessageModel*)pModel
{
    self.m_lblDate.text = pModel.date;
    if (pModel.image != nil)
        self.m_ivImage.image = pModel.image;
    else
        [self.m_ivImage sd_setImageWithURL:[NSURL URLWithString:pModel.url]
                      placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    [self.m_viewImage setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft | UIViewRoundedCornerLowerRight radius:14];
}

@end
