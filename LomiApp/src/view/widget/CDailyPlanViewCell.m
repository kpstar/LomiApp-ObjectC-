//
//  CDailyPlanViewCell.m
//  LomiApp
//
//  Created by TwinkleStar on 12/14/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CDailyPlanViewCell.h"

NSString *m_arrDietImage[] = {@"icon_breakfast", @"icon_lunch", @"icon_lunch", @"icon_morningsnack", @"icon_morningsnack", @"icon_morningsnack", @"icon_walk"};

@implementation CDailyPlanViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setData:(CDietPlanModel*)pModel
{
    self.m_lblType.text = pModel.title;
    self.m_lblPeriod.text = [NSString stringWithFormat:@"%@ - %@", pModel.start_time, pModel.end_time];
    self.m_tvContent.text = pModel.strDescription;
    self.m_ivImage.image = [UIImage imageNamed:m_arrDietImage[pModel.category_id - 1]];
}

@end
