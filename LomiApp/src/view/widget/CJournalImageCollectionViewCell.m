//
//  CJournalImageCollectionViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/28/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CJournalImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CJournalImageCollectionViewCell

- (void)setData:(CMessageModel*)pModel
{
    self.m_lblDate.text = [pModel.date substringFromIndex:11];
    [self.m_ivImage sd_setImageWithURL:[NSURL URLWithString:pModel.url]
                      placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    
    if (pModel.bIsLiked == YES)
        [self.m_ivLike setHidden:false];
    else
        [self.m_ivLike setHidden:true];
}

@end
