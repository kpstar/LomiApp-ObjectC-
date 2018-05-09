//
//  CVCTabHomeViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/9/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCTabHomeViewController.h"
#import "CGlobal.h"
#import "CNotificationModel.h"
#import "CVCJourneyViewController.h"
#import "CVCDailyViewController.h"
#import "CVCMyProgressViewController.h"
#import "CVCMessageViewController.h"
#import "CVCProfileViewController.h"

@interface CVCTabHomeViewController ()

@end

@implementation CVCTabHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setDelegate:self];
    g_vcTabHome = self;

    //self.m_timerNotification = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

    self.bIsLoaded = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshBadge
{
    int nJournalCount = 0;
    int nMessageCount = 0;
    int nDailyCount = 0;
    for (int i = 0; i < g_arrNotificationForJournal.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];

        if (model.bIsNew == true)
        {
            nJournalCount++;
        }
    }
    for (int i = 0; i < g_arrNotificationForMessage.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForMessage objectAtIndex:i];

        if (model.bIsNew == true)
        {
            nMessageCount++;
        }
    }
    for (int i = 0; i < g_arrNotificationForDietPlan.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForDietPlan objectAtIndex:i];

        if (model.bIsNew == true)
        {
            nDailyCount++;
        }
    }

    NSString* strMessage = nil;
    if (nMessageCount != 0)
        strMessage = [NSString stringWithFormat:@"%lu", (unsigned long)nMessageCount];
    [[self.viewControllers objectAtIndex:3] tabBarItem].badgeValue = strMessage;
    
    NSString* strJournal = nil;
    if (nJournalCount != 0)
        strJournal = [NSString stringWithFormat:@"%lu", (unsigned long)nJournalCount];
    [[self.viewControllers objectAtIndex:0] tabBarItem].badgeValue = strJournal;
    
    NSString* strDietPlan = nil;
    if (nDailyCount != 0)
        strDietPlan= [NSString stringWithFormat:@"%lu", (unsigned long)nDailyCount];
    [[self.viewControllers objectAtIndex:1] tabBarItem].badgeValue = strDietPlan;

    
    NSInteger nCount = nJournalCount + nMessageCount + nDailyCount;
    [UIApplication sharedApplication].applicationIconBadgeNumber = nCount;

}
- (void)refreshTab
{
    NSInteger index = self.selectedIndex;
    
    if (index == 0)
    {
        CVCJourneyViewController* viewJournal = (CVCJourneyViewController*)[self.viewControllers objectAtIndex:0];
        [viewJournal refreshJournalImage];
    }
    else if (index == 1)
    {
        CVCDailyViewController* viewDaily = (CVCDailyViewController*)[self.viewControllers objectAtIndex:1];
        [viewDaily refreshDailyPlan];
        
        for (int i = 0; i < g_arrNotificationForDietPlan.count; i++)
        {
            CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForDietPlan objectAtIndex:i];
            [CServiceManager onSetReadNotification:nil type:2 notificationId:model.notificationId];
            model.bIsNew = false;
        }
    }
    else if (index == 3)
    {
        CVCMessageViewController* viewMessage = (CVCMessageViewController*)[self.viewControllers objectAtIndex:3];
        [viewMessage refreshMessage];
        
        for (int i = 0; i < g_arrNotificationForMessage.count; i++)
        {
            CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForMessage objectAtIndex:i];
            [CServiceManager onSetReadNotification:nil type:3 notificationId:model.notificationId];
            model.bIsNew = false;
        }
    }
    
    [self refreshBadge];
    
    
//    CVCJourneyViewController* viewJournal = (CVCJourneyViewController*)[self.viewControllers objectAtIndex:0];
//    [viewJournal refreshJournalImage];
//    CVCDailyViewController* viewDaily = (CVCDailyViewController*)[self.viewControllers objectAtIndex:1];
//    [viewDaily refreshDailyPlan];
//    CVCMyProgressViewController* viewProgress = (CVCMyProgressViewController*)[self.viewControllers objectAtIndex:2];
//    [viewProgress refreshMyProgress];
//    CVCMessageViewController* viewMessage = (CVCMessageViewController*)[self.viewControllers objectAtIndex:3];
//    [viewMessage refreshMessage];
//    CVCProfileViewController* viewProfile = (CVCProfileViewController*)[self.viewControllers objectAtIndex:4];
//    [viewProfile refreshProfile];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (g_nCurState == TASKSTATE_TAB_PROFILE)
        self.selectedIndex = 4;
    if (g_nCurState == TASKSTATE_TAB_MESSAGES)
        self.selectedIndex = 3;
    if (g_nCurState == TASKSTATE_TAB_PROGRESS)
        self.selectedIndex = 2;
    if (g_nCurState == TASKSTATE_TAB_DAILYPLAN)
        self.selectedIndex = 1;
    if (g_nCurState == TASKSTATE_TAB_JOURNAL)
        self.selectedIndex = 0;

    if (self.bIsLoaded)
        return;
    self.bIsLoaded = YES;

    CVCJourneyViewController* viewJournal = (CVCJourneyViewController*)[self.viewControllers objectAtIndex:0];
    [viewJournal refreshJournalImage];
    CVCDailyViewController* viewDaily = (CVCDailyViewController*)[self.viewControllers objectAtIndex:1];
    [viewDaily refreshDailyPlan];
    CVCMyProgressViewController* viewProgress = (CVCMyProgressViewController*)[self.viewControllers objectAtIndex:2];
    [viewProgress refreshMyProgress];
    CVCMessageViewController* viewMessage = (CVCMessageViewController*)[self.viewControllers objectAtIndex:3];
    [viewMessage refreshMessage];
    CVCProfileViewController* viewProfile = (CVCProfileViewController*)[self.viewControllers objectAtIndex:4];
    [viewProfile refreshProfile];


    if (self.m_timerNotification == nil)
    {
        self.m_timerNotification = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [self.m_timerNotification fire];
//        [[NSRunLoop mainRunLoop] addTimer:self.m_timerNotification forMode:NSDefaultRunLoopMode];
    }

    if (![g_strPushType isEqualToString:@""])
    {
        NSString *type = g_strPushType;
        g_strPushType = @"";
        int nShowTabIndex = -1;

        if ([type isEqualToString:NOTIFICATION_MESSAGENEW])
        {
            nShowTabIndex = 3;
        }
        else if ([type isEqualToString:NOTIFICATION_PHOTOAPPROVED] || [type isEqualToString:NOTIFICATION_PHOTOCOMMENT])
        {
            nShowTabIndex = 0;
            
        }
        else if ([type isEqualToString:NOTIFICATION_SHCEDULECREATED] || [type isEqualToString:NOTIFICATION_SCHEDULEEDITED])
        {
            nShowTabIndex = 1;
            
        }
        else if ([type isEqualToString:NOTIFICATION_EXPIRATIONNOTICE])
        {
            nShowTabIndex = 4;
        }
        else if ([type isEqualToString:NOTIFICATION_MEASUREMENTSWEEKLYNOTICE])
        {
            nShowTabIndex = 2;
        }
        else if ([type isEqualToString:NOTIFICATION_QUESTIONNAIRE])
        {
            nShowTabIndex = 4;
        }
        
        if (nShowTabIndex != -1)
            self.selectedIndex = nShowTabIndex;
    }
    [self onAPISuccess:0 result:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    [self.m_timerNotification invalidate];
    self.m_timerNotification = nil;
}

- (void)onTimer
{
    [CServiceManager onGetNotifications:nil type:0];
}

- (void)onAPISuccess:(int)type result:(id) result
{
    
//    for (int i = 0; i < g_arrNotificationForJournal.count; i++)
//    {
//        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForJournal objectAtIndex:i];
//
//        if (model.bIsNew)
//        {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            NSString *strComment = [model.body stringByReplacingOccurrencesOfString:@"user" withString:@"your"];
//            notification.alertBody = strComment;
//            notification.hasAction = false;
//
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//        model.bIsNew = false;
//    }
//    for (int i = 0; i < g_arrNotificationForMessage.count; i++)
//    {
//        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForMessage objectAtIndex:i];
//
//        if (model.bIsNew)
//        {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            notification.alertBody = model.body;
//            notification.hasAction = false;
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//        model.bIsNew = false;
//    }
//    for (int i = 0; i < g_arrNotificationForDietPlan.count; i++)
//    {
//        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForDietPlan objectAtIndex:i];
//
//        if (model.bIsNew)
//        {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            notification.alertBody = model.body;
//            notification.hasAction = false;
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//        model.bIsNew = false;
//    }
    for (int i = 0; i < g_arrNotificationForExpiration.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForExpiration objectAtIndex:i];
     
//        if (model.bIsNew == true)
//        {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            notification.alertBody = model.body;
//            notification.hasAction = false;
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
        model.bIsNew = false;
        [CServiceManager onSetReadNotification:nil type:1 notificationId:model.notificationId];
    }
    
    [g_arrNotificationForExpiration removeAllObjects];

    for (int i = 0; i < g_arrNotificationForMeasurement.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForMeasurement objectAtIndex:i];

//        if (model.bIsNew == true)
//        {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            notification.alertBody = model.body;
//            notification.hasAction = false;
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
        model.bIsNew = false;
        [CServiceManager onSetReadNotification:nil type:1 notificationId:model.notificationId];
    }
    [g_arrNotificationForMeasurement removeAllObjects];
 
//    for (int i = 0; i < g_arrNotificationForQuestionnaire.count; i++)
//    {
//        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForQuestionnaire objectAtIndex:i];
//     
//        if (model.bIsNew)
//        {
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//            notification.alertBody = model.body;
//            notification.hasAction = true;
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//        model.bIsNew = false;
//    }
  
//    NSString* strMessage = nil;
//    if (g_arrNotificationForMessage.count != 0)
//        strMessage = [NSString stringWithFormat:@"%lu", (unsigned long)g_arrNotificationForMessage.count];
//    [[self.viewControllers objectAtIndex:3] tabBarItem].badgeValue = strMessage;
//    
//    NSString* strJournal = nil;
//    if (g_arrNotificationForJournal.count != 0)
//        strJournal = [NSString stringWithFormat:@"%lu", (unsigned long)g_arrNotificationForJournal.count];
//    [[self.viewControllers objectAtIndex:0] tabBarItem].badgeValue = strJournal;
//    
//    NSString* strDietPlan = nil;
//    if (g_arrNotificationForDietPlan.count != 0)
//        strDietPlan= [NSString stringWithFormat:@"%lu", (unsigned long)g_arrNotificationForDietPlan.count];
//    [[self.viewControllers objectAtIndex:1] tabBarItem].badgeValue = strDietPlan;
//
//    NSInteger nCount = g_arrNotificationForMessage.count + g_arrNotificationForJournal.count + g_arrNotificationForDietPlan.count;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = nCount;

    [self refreshBadge];
}

- (void)onAPIFail:(int)type result:(id) result
{

}

- (void)onClickNotification
{
    self.selectedIndex = 4;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

    NSInteger index = self.selectedIndex;

    if (index == 1)
    {
        [[self.viewControllers objectAtIndex:index] tabBarItem].badgeValue = nil;

        for (int i = 0; i < g_arrNotificationForDietPlan.count; i++)
        {
            CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForDietPlan objectAtIndex:i];
            [CServiceManager onSetReadNotification:nil type:2 notificationId:model.notificationId];
            model.bIsNew = false;
        }
 
    }
    else if (index == 3)
    {
        [[self.viewControllers objectAtIndex:index] tabBarItem].badgeValue = nil;

        for (int i = 0; i < g_arrNotificationForMessage.count; i++)
        {
            
            CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForMessage objectAtIndex:i];
            [CServiceManager onSetReadNotification:nil type:3 notificationId:model.notificationId];
            model.bIsNew = false;
        }
    }

    [self refreshBadge];
}

@end
