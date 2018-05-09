//
//  CVCDailyViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCDailyViewController.h"
#import "CDailyPlanViewCell.h"
#import <Google/Analytics.h>
#import "CGlobal.h"

@interface CVCDailyViewController ()

@end

@implementation CVCDailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.m_cvDailyPlan registerNib:[UINib nibWithNibName:@"CDailyPlanViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_DAILYPLAN"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.m_strDate = [dateFormat stringFromDate:[NSDate date]];
    
    self.m_arrDailyPlans = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Daily"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
    
    [self.m_ctlCalendar setScope:FSCalendarScopeWeek];
    [self.m_ctlCalendar selectDate:[NSDate date] scrollToDate:YES];
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    NSLocale *Locale = [[NSLocale alloc] initWithLocaleIdentifier:strLan];
    [self.m_ctlCalendar setLocale:Locale];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.m_strDate = [dateFormat stringFromDate:[NSDate date]];
    
    [CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onGetDietPlans:self type:0 date:self.m_strDate];
    
    [CGlobal setState:g_nCurState nextState:TASKSTATE_TAB_DAILYPLAN];
}

- (void)refreshDailyPlan
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.m_strDate = [dateFormat stringFromDate:[NSDate date]];
    
    //[CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onGetDietPlans:self type:0 date:self.m_strDate];    
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
//    self.tabBarItem.badgeValue = nil;

    
    if (self.m_arrDailyPlans != nil)
        [self.m_arrDailyPlans removeAllObjects];
    [self.m_arrDailyPlans addObjectsFromArray:result];
    [result removeAllObjects];
    result = nil;
    [self.m_cvDailyPlan reloadData];
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (self.m_arrDailyPlans != nil)
        [self.m_arrDailyPlans removeAllObjects];
    [self.m_cvDailyPlan reloadData];

    if (result == nil)
    {
        if (g_nCurState == TASKSTATE_TAB_DAILYPLAN)
            [CGlobal showNetworkErrorAlert:self];
    }
    else if ([result isKindOfClass:[NSString class]])
    {
        if ([CGlobal isWeightDietReason] != YES)
            return;
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_SORRY", @"")];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.m_arrDailyPlans.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDailyPlanViewCell *mCell = (CDailyPlanViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_DAILYPLAN" forIndexPath:indexPath];
    
    [mCell setData:self.m_arrDailyPlans[indexPath.row]];
    
    return mCell;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    int nWidth = self.m_cvDailyPlan.frame.size.width;
//    CGSize mElementSize = CGSizeMake(nWidth, nWidth);
//    return mElementSize;
//    return CGSizeMake(0, 0);
    
    CDailyPlanViewCell * cell = (CDailyPlanViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CDailyPlanViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell setData:self.m_arrDailyPlans[indexPath.row]];
    
    int nWidth = self.m_cvDailyPlan.frame.size.width;
    CGFloat nHeight = [cell.m_tvContent sizeThatFits:CGSizeMake(nWidth - 148, CGFLOAT_MAX)].height;
    CGSize mElementSize = CGSizeMake(nWidth, nHeight + 100);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    self.m_constraintHeightOfCalendar.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    self.m_strDate = [dateFormat stringFromDate:date];
    
    [CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onGetDietPlans:self type:0 date:self.m_strDate];}



@end
