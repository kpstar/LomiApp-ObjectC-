//
//  CMyImageCollectionViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/16/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMessageModel.h"

@interface CMyImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_ivImage;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;
@property (weak, nonatomic) IBOutlet UIView *m_viewImage;

- (void)setData:(CMessageModel*)pModel;

@end
