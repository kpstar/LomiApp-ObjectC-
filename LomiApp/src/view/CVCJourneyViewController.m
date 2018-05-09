//
//  CVCJourneyViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCJourneyViewController.h"
#import "CVCJournalOneViewController.h"
#import "CJournalImageCollectionViewCell.h"
#import "CNutritionistMessageViewCell.h"
#import "CMyMessageViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Google/Analytics.h>

@interface CVCJourneyViewController ()

@end

@implementation CVCJourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.m_cvImage registerNib:[UINib nibWithNibName:@"CJournalImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_JOURNALIMAGE"];
    [self.m_cvComments registerNib:[UINib nibWithNibName:@"CNutritionistMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_NUTMESSAGE"];
    [self.m_cvComments registerNib:[UINib nibWithNibName:@"CMyMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_MYMESSAGE"];

    self.m_arrImage = [[NSMutableArray alloc] init];
    self.m_arrComment = [[NSMutableArray alloc] init];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.m_strDate = [dateFormat stringFromDate:[NSDate date]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshJournalImage)
                                                 name:@"Notification_JOURNAL"
                                               object:nil];
    
    self.m_constraintHeightOfInputCollectionView.constant = 0;
    [self.m_ctlInputCollection setHidden:YES];
    [self.m_ctlInputCollection setNeedsLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Journal"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
    
    [self.m_ctlCalendar setScope:FSCalendarScopeWeek];
    [self.m_ctlCalendar selectDate:[NSDate date] scrollToDate:YES];
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    NSLocale *Locale = [[NSLocale alloc] initWithLocaleIdentifier:strLan];
    [self.m_ctlCalendar setLocale:Locale];

    [self.m_viewBadgeBreakfast setHidden:YES];
    [self.m_viewBadgeMorningsnack setHidden:YES];
    [self.m_viewBadgeLunch setHidden:YES];
    [self.m_viewBadgeAfternoonsnack setHidden:YES];
    [self.m_viewBadgeDinner setHidden:YES];
    [self.m_viewBadgeEveningsnack setHidden:YES];
    
    if (self.bIsLoaded)
        return;
    self.bIsLoaded = YES;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.m_strDate = [dateFormat stringFromDate:[NSDate date]];
    
    [CGlobal showProgressHUD:g_vcTabHome];
    [self refreshJournalImage];
    
    //[CGlobal setState:g_nCurState nextState:TASKSTATE_TAB_JOURNAL];

}

- (void)refreshJournalImage
{
    //[CGlobal showProgressHUD:g_vcTabHome];
    CJournalSearchModel *model = [[CJournalSearchModel alloc] init];
    model.date = self.m_strDate;
    model.approval = @"";//@"true";
    model.mealTypeId = @"";//[NSString stringWithFormat:@"%ld", (long)self.m_nMealTypeID];
    [CServiceManager onGetApprovedPhotos:self type:0 model:model];
    //[CServiceManager onGetUserPhotos:self type:0 model:model];
    
    self.bIsLoaded = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.bIsLoaded = NO;
    [self.m_viewComment setHidden:YES];
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (type == 0)  //photo list
    {
        if (self.m_arrImage != nil)
            [self.m_arrImage removeAllObjects];
        [self.m_arrImage addObjectsFromArray:result];
        [result removeAllObjects];
        result = nil;
        
        [self.m_cvImage reloadData];
        [self refreshBadge];
        if (self.m_arrImage.count != 0)
            [self.m_cvImage scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else if (type == 1) //get comment
    {
        if (self.m_arrComment != nil)
            [self.m_arrComment removeAllObjects];
        [self.m_arrComment addObjectsFromArray:result];
        [result removeAllObjects];
        result = nil;
        [self.m_cvComments reloadData];
        if (self.m_arrComment.count != 0)
        {
            [self.m_cvComments scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self.m_lblNoComment setHidden:YES];
        }
        else
        {
            [self.m_lblNoComment setHidden:NO];
        }
        [self.m_ivJournalImage sd_setImageWithURL:[NSURL URLWithString:self.m_pSelectedModel.url]
                                 placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
        self.m_ivJournalImage.layer.masksToBounds = YES;
        self.m_ivJournalImage.layer.cornerRadius = 8;
        [self.m_viewComment setHidden:NO];
        [self.view bringSubviewToFront:self.m_viewComment];
        //        NSTimeInterval duration = 0.1f;
        //        [self.m_viewComment setAlpha:0.0];
        //        [UIView beginAnimations:nil context:NULL];
        //        [UIView setAnimationDuration:duration];
        //        [self.m_viewComment setAlpha:1.0f];
    }
    else if (type == 3) //post comment
    {
        [self.m_cvComments reloadData];
        [self refreshCollectionView];
        if (self.m_arrComment.count != 0)
            [self.m_cvComments scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrComment.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        
        self.m_tvInputText.text = @"";
        [self.m_tvInputText setNeedsLayout];
    }

}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (type == 3) //post comment
    {
        CJournalSearchModel* model = result;
        
        [self.m_arrComment removeObjectAtIndex:model.indexOfComment];
        [self.m_cvComments reloadData];
        [self refreshCollectionView];
        if (self.m_arrComment.count != 0)
            [self.m_cvComments scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrComment.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        return;
    }

    
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

-(void) refreshCollectionView
{
    [self.m_cvComments setNeedsLayout];
    [self.m_cvComments layoutIfNeeded];
    
    if (self.m_arrComment.count == 0)
    {
        [self.m_lblNoComment setHidden:NO];
    }
    else
    {
        [self.m_lblNoComment setHidden:YES];
    }
}

- (void)refreshBadge
{
    int nBreakfast = 0, nLunch = 0, nDinner = 0, nMorning = 0, nAfternoon = 0, nEvening = 0;
    
    for (int i = 0; i < self.m_arrImage.count; i++)
    {
        CMessageModel* model = [self.m_arrImage objectAtIndex:i];
        
        switch (model.mealTypeId) {
            case 1:
                nBreakfast++;
                break;
            case 2:
                nLunch++;
                break;
            case 3:
                nDinner++;
                break;
            case 4:
                nMorning++;
                break;
            case 5:
                nAfternoon++;
                break;
            case 6:
                nEvening++;
                break;
                
            default:
                break;
        }
    }
    
    [self.m_viewBadgeBreakfast setHidden:YES];
    [self.m_viewBadgeMorningsnack setHidden:YES];
    [self.m_viewBadgeLunch setHidden:YES];
    [self.m_viewBadgeAfternoonsnack setHidden:YES];
    [self.m_viewBadgeDinner setHidden:YES];
    [self.m_viewBadgeEveningsnack setHidden:YES];
    
    if (nBreakfast > 0)
    {
        [self.m_viewBadgeBreakfast setHidden:NO];
        self.m_lblBadgeBreakfast.text = [NSString stringWithFormat:@"%d", nBreakfast];
    }
    if (nLunch > 0)
    {
        [self.m_viewBadgeLunch setHidden:NO];
        self.m_lblBadgeLunch.text = [NSString stringWithFormat:@"%d", nLunch];
    }
    if (nDinner > 0)
    {
        [self.m_viewBadgeDinner setHidden:NO];
        self.m_lblBadgeDinner.text = [NSString stringWithFormat:@"%d", nDinner];
    }
    if (nMorning > 0)
    {
        [self.m_viewBadgeMorningsnack setHidden:NO];
        self.m_lblBadgeMorningsnack.text = [NSString stringWithFormat:@"%d", nMorning];
    }
    if (nAfternoon > 0)
    {
        [self.m_viewBadgeAfternoonsnack setHidden:NO];
        self.m_lblBadgeAfternoonsnack.text = [NSString stringWithFormat:@"%d", nAfternoon];
    }
    if (nEvening > 0)
    {
        [self.m_viewBadgeEveningsnack setHidden:NO];
        self.m_lblBadgeEveningsnack.text = [NSString stringWithFormat:@"%d", nEvening];
    }
    
    [self.m_ctlCalendar reloadData];
    [self.m_ctlCalendar layoutIfNeeded];
    [g_vcTabHome refreshBadge];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"JOURNAL_TO_JOURNALVIEW"])
    {
        CVCJournalOneViewController* destController = [segue destinationViewController];
        destController.m_nMealTypeID = self.m_nMealTypeID;
        destController.m_strDate = self.m_strDate;
    }
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [dateFormat stringFromDate:date];
    
    int nCount = 0;
    for (int i = 0; i < g_arrNotificationForJournal.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];
        if (model.bIsNew == false)
            continue;
        if ([strDate isEqualToString:model.photoDate])
            nCount += 1;
    }
    if (nCount == 0)
        return [UIColor whiteColor];
    else
        return [UIColor redColor];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [dateFormat stringFromDate:date];
    
    int nCount = 0;
    for (int i = 0; i < g_arrNotificationForJournal.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];
        if (model.bIsNew == false)
            continue;
        if ([strDate isEqualToString:model.photoDate])
            nCount += 1;
    }
    if (nCount == 0)
        return [UIColor whiteColor];
    else
        return [UIColor redColor];
    
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString* strDate = [dateFormat stringFromDate:date];
    
    int nCount = 0;
    for (int i = 0; i < g_arrNotificationForJournal.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];
        if (model.bIsNew == false)
            continue;
        if ([strDate isEqualToString:model.photoDate])
            nCount += 1;
    }
    if (nCount == 0)
        return nil;
    else
        return [NSString stringWithFormat:@"%d", nCount];
    
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date
{
    return [UIColor redColor];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    self.m_constraintHeightOfCalendar.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    
    if (self.m_arrImage != nil)
        [self.m_arrImage removeAllObjects];
    [self.m_cvImage reloadData];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    self.m_strDate = [dateFormat stringFromDate:date];
    
    for (int i = 0; i < g_arrNotificationForJournal.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];
        if ([self.m_strDate isEqualToString:model.photoDate])
        {
            [CServiceManager onSetReadNotification:nil type:1 notificationId:model.notificationId];
            model.bIsNew = false;
        }
    }
    
    [self refreshBadge];
    
    [CGlobal showProgressHUD:g_vcTabHome];
    CJournalSearchModel *model = [[CJournalSearchModel alloc] init];
    model.date = self.m_strDate;
    model.approval = @"";//@"true";
    model.mealTypeId = @"";
    [CServiceManager onGetApprovedPhotos:self type:0 model:model];
    //[CServiceManager onGetUserPhotos:self type:0 model:model];
    
    
}

- (IBAction)onClickBreakfast:(id)sender
{
    self.m_nMealTypeID = MEALTYPE_BREAKFAST;
    [self performSegueWithIdentifier: @"JOURNAL_TO_JOURNALVIEW"
                              sender: self];
}

- (IBAction)onClickMorningsnack:(id)sender
{
    self.m_nMealTypeID = MEALTYPE_MORNINGSNACK;
    [self performSegueWithIdentifier: @"JOURNAL_TO_JOURNALVIEW"
                              sender: self];
}

- (IBAction)onClickLunch:(id)sender
{
    self.m_nMealTypeID = MEALTYPE_LUNCH;
    [self performSegueWithIdentifier: @"JOURNAL_TO_JOURNALVIEW"
                              sender: self];
}

- (IBAction)onClickAfternoonsnack:(id)sender
{
    self.m_nMealTypeID = MEALTYPE_AFTERNOONSNACK;
    [self performSegueWithIdentifier: @"JOURNAL_TO_JOURNALVIEW"
                              sender: self];
}

- (IBAction)onClickDinner:(id)sender
{
    self.m_nMealTypeID = MEALTYPE_DINNER;
    [self performSegueWithIdentifier: @"JOURNAL_TO_JOURNALVIEW"
                              sender: self];
}

- (IBAction)onClickEveningsnack:(id)sender
{
    self.m_nMealTypeID = MEALTYPE_EVENINGSNACK;
    [self performSegueWithIdentifier: @"JOURNAL_TO_JOURNALVIEW"
                              sender: self];
}

- (IBAction)onClickCommentView:(id)sender
{
 
    [self.m_viewComment setHidden:YES];
    //        NSTimeInterval duration = 0.1f;
    //        [self.m_viewComment setAlpha:0.0];
    //        [UIView beginAnimations:nil context:NULL];
    //        [UIView setAnimationDuration:duration];
    //        [self.m_viewComment setAlpha:1.0f];

}


#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 0)
        return self.m_arrImage.count;
    else if (collectionView.tag == 1)
        return self.m_arrComment.count;
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0)
    {
        CJournalImageCollectionViewCell *mCell = (CJournalImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_JOURNALIMAGE" forIndexPath:indexPath];
        
        CMessageModel* model = [self.m_arrImage objectAtIndex:indexPath.row];
        [mCell setData:model];
        mCell.layer.masksToBounds = YES;
        mCell.layer.cornerRadius = 8;
        return mCell;
    }
    else if (collectionView.tag == 1)
    {
        CMessageModel* model = self.m_arrComment[indexPath.row];
        
//        if (model.isNutritionist)
        {
            CNutritionistMessageViewCell *mCell = (CNutritionistMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_NUTMESSAGE" forIndexPath:indexPath];
            [mCell setNeedsLayout];
            [mCell layoutIfNeeded];
            [mCell setData:model];
            return mCell;
        }
//        else
//        {
//            CMyMessageViewCell *mCell = (CMyMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_MYMESSAGE" forIndexPath:indexPath];
//            [mCell setNeedsLayout];
//            [mCell layoutIfNeeded];
//            [mCell setData:model];
//            return mCell;
//        }
    }

    return nil;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0)
    {
        CGFloat nWidth = (self.m_cvImage.frame.size.width - 32) / 3;
        CGFloat nHeight = self.m_cvImage.frame.size.height;
        CGSize mElementSize = CGSizeMake(nWidth, nHeight);
        return mElementSize;
    }
    else if (collectionView.tag == 1)
    {
        CMessageModel* model = self.m_arrComment[indexPath.row];
        
//        if (model.isNutritionist)
        {
            CNutritionistMessageViewCell * cell = (CNutritionistMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
          
            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CNutritionistMessageViewCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            [cell setData:model];
            
            CGFloat nWidth = self.m_cvComments.frame.size.width;
            CGFloat nHeight = [cell.m_tvMessage sizeThatFits:CGSizeMake(nWidth - 90, CGFLOAT_MAX)].height;
            CGSize mElementSize = CGSizeMake(nWidth, nHeight + 52);
            return mElementSize;
        }
//        else
//        {
//        
//            CMyMessageViewCell * cell = (CMyMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
//            
//            if (cell == nil) {
//
//                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CMyMessageViewCell" owner:self options:nil];
//                cell = [topLevelObjects objectAtIndex:0];
//            }
//            
//            [cell setData:model];
//            
//            CGFloat nWidth = self.m_cvComments.frame.size.width;
//            CGFloat nHeight = [cell.m_tvMessage sizeThatFits:CGSizeMake(nWidth * 0.7 - 32, CGFLOAT_MAX)].height;
//            CGSize mElementSize = CGSizeMake(nWidth, nHeight + 52);
//            return mElementSize;
//        }
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0)
    {
        self.m_pSelectedModel = [self.m_arrImage objectAtIndex:indexPath.row];
        
        CJournalSearchModel* model = [[CJournalSearchModel alloc] init];
        model.photoId = [NSString stringWithFormat:@"%ld", (long)self.m_pSelectedModel.photoId];
        [CGlobal showProgressHUD:g_vcTabHome];
        [CServiceManager onGetComments:self type:1 model:model];
    }
}

- (IBAction)onClickSend:(id)sender
{
    NSString* strPhotoId = [NSString stringWithFormat:@"%ld", (long)self.m_pSelectedModel.photoId];
    
    NSString* message = self.m_tvInputText.text;
    
    if (![message isEqualToString:@""])
    {
        [self sendMessage:strPhotoId];
    }
}

- (void)sendMessage:(NSString*) photoId
{
    if (photoId == nil)
        return;
    
    NSString* message = self.m_tvInputText.text;
    
    [[self view] endEditing:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *today = [dateFormat stringFromDate:[NSDate date]];
    
    CMessageModel* model = [[CMessageModel alloc] init];
    model.isNutritionist = NO;
    model.isImage = NO;
    model.isForMessage = NO;
    
    model.bodyText = message;
    model.userId = g_pUserModel.nUserID;
    NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
    model.username = strName;//g_pUserModel.strUserName;
    model.commentDate = [NSString stringWithFormat:@"%@ %@", self.m_strDate, [today substringFromIndex:11]];
    model.commentImage = g_pUserModel.strThumbnail;
    [self.m_arrComment addObject:model];
    
    CJournalSearchModel* searchModel = [[CJournalSearchModel alloc] init];
    searchModel.photoId = photoId;
    searchModel.body = message;
    searchModel.indexOfComment = self.m_arrComment.count - 1;
    
    [CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onPostComments:self type:3 model:searchModel];
}

@end
