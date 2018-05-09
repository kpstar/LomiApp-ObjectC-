//
//  CNutritionImageCollectionViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/16/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMessageModel.h"

@interface CNutritionImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_ivAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivImage;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;

- (void)setData:(CMessageModel*)pModel;

@end
