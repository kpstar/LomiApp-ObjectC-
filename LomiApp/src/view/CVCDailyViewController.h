//
//  CVCDailyViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "MBProgressHUD.h"
#import "FSCalendar.h"
#import "CGlobal.h"

@interface CVCDailyViewController : CUIViewController<FSCalendarDelegate, FSCalendarDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintHeightOfCalendar;
@property (weak, nonatomic) IBOutlet FSCalendar *m_ctlCalendar;
@property   NSString*        m_strDate;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cvDailyPlan;

@property (strong, nonatomic) NSMutableArray *m_arrDailyPlans;

- (void)refreshDailyPlan;

@end
