//
//  CUIViewStarRate.h
//  LomiApp
//
//  Created by TwinkleStar on 12/19/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@protocol CUIViewStarRateDelegate;

@interface CUIViewStarRate : UIView

@property (nonatomic, weak) id<CUIViewStarRateDelegate> delegate;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *m_viewStarRate;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property NSInteger m_nType;

- (void)initData:(NSInteger)type title:(NSString*)title defaultValue:(CGFloat)value;
- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickRate:(id)sender;

@end

@protocol CUIViewStarRateDelegate <NSObject>

- (void)onRateSelected:(CUIViewStarRate*)view type:(NSInteger)type
          didChooseRate:(CGFloat)value;

@end
