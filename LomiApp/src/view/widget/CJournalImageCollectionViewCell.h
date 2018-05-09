//
//  CJournalImageCollectionViewCell.h
//  LomiApp
//
//  Created by TwinkleStar on 12/28/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMessageModel.h"

@interface CJournalImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_ivImage;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivLike;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;
@property (weak, nonatomic) IBOutlet UIView *m_viewContainer;

- (void)setData:(CMessageModel*)pModel;

@end
