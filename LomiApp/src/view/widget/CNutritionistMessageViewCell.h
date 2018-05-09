//
//  CNutritionistMessageViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/14/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMessageModel.h"

@interface CNutritionistMessageViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_ivAvatar;
@property (weak, nonatomic) IBOutlet UITextView *m_tvMessage;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;
@property (weak, nonatomic) IBOutlet UIView *m_viewMessage;

- (void)setData:(CMessageModel*)pModel;

@end
