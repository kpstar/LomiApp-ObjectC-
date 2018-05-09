//
//  CGlobal.m
//
//  Created by apple on 9/7/15.
//  Copyright (c) 2015 apple. All rights reserved.
//
#import "AppDelegate.h"
#import "NSBundle+Language.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDWebImage/UIImage+GIF.h"
#import "CGlobal.h"
#import "CVCSplashViewController.h"
#import "CChooseNutritionistViewController.h"
#import "CVCLoginController.h"
#import "CNotificationModel.h"
#import "CPromotionCodeViewController.h"

TaskState                           g_nPrevState    = TASKSTATE_NONE;
TaskState                           g_nCurState     = TASKSTATE_NONE;

NSString*                           g_strEmail              = @"";
NSString*                           g_strPassword           = @"";
BOOL                                g_socialTypeFB          = true;

id                                  g_fbResult              = nil;
NSMutableDictionary*                g_twUserDic             = nil;


NSArray*                            g_arrWUnitString        = nil;
NSArray*                            g_arrWUnitValue         = nil;
NSArray*                            g_arrLUnitString        = nil;
NSArray*                            g_arrLUnitValue         = nil;

NSMutableArray*                     g_arrCountryCode        = nil;
NSMutableArray*                     g_arrNutCountryCode     = nil;
NSMutableArray*                     g_arrCountryFullName    = nil;
NSMutableArray*                     g_arrCountryFullNameLocalized    = nil;
NSMutableArray*                     g_arrNutCountryFullName = nil;
NSArray*                            g_arrDietReasonsValue   = nil;
NSArray*                            g_arrSportValue         = nil;
NSArray*                            g_arrWorkValue          = nil;
NSArray*                            g_arrFoodKindValue      = nil;
NSArray*                            g_arrSpecialityFilterValue  = nil;

NSMutableArray*                     g_arrNotificationForJournal = nil;
NSMutableArray*                     g_arrNotificationForDietPlan = nil;
NSMutableArray*                     g_arrNotificationForMessage = nil;
NSMutableArray*                     g_arrNotificationForExpiration = nil;
NSMutableArray*                     g_arrNotificationForMeasurement = nil;
NSMutableArray*                     g_arrNotificationForQuestionnaire = nil;

NSMutableArray*                     g_arrPlans = nil;
NSMutableArray*                     g_arrSpecialityFilter = nil;
NSMutableArray*                     g_arrPromotionPlans = nil;


CUserModel*                         g_pUserModel            = nil;
CTimeZoneModel*                     g_pTimeZoneModel        = nil;
CVCTabHomeViewController*           g_vcTabHome             = nil;

bool                                g_bIsPackageIdle        = true;
bool                                g_bPaid                 = false;
NSString*                           g_strTelephone          = @"";
NSString*                           g_strMaintainance       = @"";
NSString*                           g_strDeviceToken        = @"";

NSString*                           g_strPushType           = @"";

NSString*                           g_strStoreURL           = @"";

@implementation CGlobal

+ (void)initAppConstantVariables {

    g_strEmail = @"twinklestar871025@hotmail.com";
    g_strPassword = @"aaaaaa";//@"6e41f5aa21";
    
    g_arrWUnitString    =   @[
                              @"Pounds (lbs)",
                              @"Kilograms (kg)"];
    g_arrWUnitValue     =   @[
                              @"lb",
                              @"kg"];
    g_arrLUnitString    =   @[
                              @"Centimetrs (cm)",
                              @"Inches (in)",
                              @"Feets (ft)"];
    g_arrLUnitValue     =   @[
                              @"cm",
                              @"in",
                              @"ft"];
    
//    g_arrCountryCode    =   @[
//                              @"440",
//                              @"441",
//                              @"442",
//                              @"443",
//                              @"444",
//                              @"445",
//                              @"446",
//                              @"447",
//                              @"448",
//                              @"449",
//                              @"450",
//                              @"451",
//                              @"452",
//                              @"453",
//                              @"454",
//                              @"455",
//                              @"456",
//                              @"457",
//                              @"458",
//                              @"459"];
//    
//    g_arrCountryFullName    =   @[
//                              @"Algeria",
//                              @"Bahrain",
//                              @"Canada",
//                              @"Egypt",
//                              @"Jordan",
//                              @"Kuwait",
//                              @"Lebanon",
//                              @"Libya",
//                              @"Morocco",
//                              @"Oman",
//                              @"Qatar",
//                              @"Saudi Arabia",
//                              @"Sudan",
//                              @"Syria",
//                              @"Tunisia",
//                              @"Turkey",
//                              @"United Arab Emirates",
//                              @"United Kingdom",
//                              @"United States",
//                              @"Yemen"];
//    g_arrCountryFullNameLocalized    =   @[
//                                  NSLocalizedString(@"COUNTRY_Algeria", @""),
//                                  NSLocalizedString(@"COUNTRY_Bahrain", @""),
//                                  NSLocalizedString(@"COUNTRY_Canada", @""),
//                                  NSLocalizedString(@"COUNTRY_Egypt", @""),
//                                  NSLocalizedString(@"COUNTRY_Jordan", @""),
//                                  NSLocalizedString(@"COUNTRY_Kuwait", @""),
//                                  NSLocalizedString(@"COUNTRY_Lebanon", @""),
//                                  NSLocalizedString(@"COUNTRY_Libya", @""),
//                                  NSLocalizedString(@"COUNTRY_Morocco", @""),
//                                  NSLocalizedString(@"COUNTRY_Oman", @""),
//                                  NSLocalizedString(@"COUNTRY_Qatar", @""),
//                                  NSLocalizedString(@"COUNTRY_SaudiArabia", @""),
//                                  NSLocalizedString(@"COUNTRY_Sudan", @""),
//                                  NSLocalizedString(@"COUNTRY_Syria", @""),
//                                  NSLocalizedString(@"COUNTRY_Tunisia", @""),
//                                  NSLocalizedString(@"COUNTRY_Turkey", @""),
//                                  NSLocalizedString(@"COUNTRY_UnitedArabEmirates", @""),
//                                  NSLocalizedString(@"COUNTRY_UnitedKingdom", @""),
//                                  NSLocalizedString(@"COUNTRY_UnitedStates", @""),
//                                  NSLocalizedString(@"COUNTRY_Yemen", @"")];
//    
//    g_arrNutCountryCode    =   @[
//                              @"463",
//                              @"464",
//                              @"465",
//                              @"466",
//                              @"467",
//                              @"468",
//                              @"469",
//                              @"470",
//                              @"471",
//                              @"472",
//                              @"473",
//                              @"474",
//                              @"475",
//                              @"476",
//                              @"477",
//                              @"478",
//                              @"479",
//                              @"480",
//                              @"481",
//                              @"482"];
    
    g_arrDietReasonsValue    =   @[
                              @"502",
                              @"503",
                              @"504",
                              @"505",
                              @"506",
                              @"507",
                              @"508",
                              @"509",
                              @"510",
                              @"511",
                              @"512",
                              @"513",
                              @"514",
                              @"515"];
    g_arrSportValue     =   @[
                              @"421",
                              @"420",
                              @"422",
                              @"423"];
    g_arrWorkValue     =   @[
                              @"427",
                              @"426",
                              @"425",
                              @"424",
                              @"428"];
    g_arrFoodKindValue     =   @[
                             @"437",
                             @"436",
                             @"435",
                             @"434",
                             @"433",
                             @"432",
                             @"431",
                             @"430",
                             @"438",
                             @"439"];
    
    g_arrSpecialityFilterValue     =   @[
                                 @"486",
                                 @"487",
                                 @"488",
                                 @"489",
                                 @"490",
                                 @"491"];
    g_arrCountryCode = [[NSMutableArray alloc] init];
    g_arrCountryFullName = [[NSMutableArray alloc] init];
    g_arrCountryFullNameLocalized = [[NSMutableArray alloc] init];
    g_arrNutCountryCode = [[NSMutableArray alloc] init];
    g_arrNutCountryFullName = [[NSMutableArray alloc] init];
    g_arrNotificationForJournal = [[NSMutableArray alloc] init];
    g_arrNotificationForMessage = [[NSMutableArray alloc] init];
    g_arrNotificationForDietPlan = [[NSMutableArray alloc] init];
    g_arrNotificationForExpiration = [[NSMutableArray alloc] init];
    g_arrNotificationForMeasurement = [[NSMutableArray alloc] init];
    g_arrNotificationForQuestionnaire = [[NSMutableArray alloc] init];
    g_arrSpecialityFilter = [[NSMutableArray alloc] init];
    [CServiceManager onGetUserCountryList];
    [CServiceManager onGetNutCountryList];
    
}


+ (void) showAlert:(UIViewController*)controller message:(NSString*)strMessage title:(NSString*)strTitle {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strTitle
                                  message:strMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        if ([controller isKindOfClass:[CVCSplashViewController class]])
        {
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
            
        } else if ([controller isKindOfClass:[CVCLoginController class]]) {
            
            CVCLoginController* class = (CVCLoginController*)controller;
            [class onClickAlertOK];
        } else if ([controller isKindOfClass:[CPromotionCodeViewController class]]) {
            
            if ([strTitle isEqualToString:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")])
                return;
            CPromotionCodeViewController* class = (CPromotionCodeViewController*)controller;
            [class onClickAlertOK];
        }
    }];
    
    [alert addAction:okAction];
    //UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [controller presentViewController:alert animated:YES completion:nil];
}
+ (void) showAlertWithYesNo:(UIViewController*)controller type:(int)type message:(NSString*)strMessage title:(NSString*)strTitle {
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strTitle
                                  message:strMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_YES", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        if ([controller isKindOfClass:[CVCSplashViewController class]]) {
            
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
            
        } else if ( [controller isKindOfClass:[CChooseNutritionistViewController class]]) {
            
            CChooseNutritionistViewController* class = (CChooseNutritionistViewController*)controller;
            [class onAlertYES:type];
        }
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_NO", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        if ([controller isKindOfClass:[CVCSplashViewController class]]) {
            
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
            
        } else if ( [controller isKindOfClass:[CChooseNutritionistViewController class]]) {
            
            CChooseNutritionistViewController* class = (CChooseNutritionistViewController*)controller;
            [class onAlertNO:type];
        }
        
    }];
    [alert addAction:noAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void) showAlertWithIgnoreSure:(UIViewController*)controller type:(int)type message:(NSString*)strMessage title:(NSString*)strTitle {
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strTitle
                                  message:strMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_IGNORE", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        exit(0);
        
        /*
        if ([controller isKindOfClass:[CVCLoginController class]]) {
            
            CVCLoginController* class = (CVCLoginController*)controller;
            [class onClickAlertOK];
            
        } else if ( [controller isKindOfClass:[CVCSplashViewController class]]) {
            
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
        }
         */
        
        
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_SURE", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        //https://itunes.apple.com/us/app/lomiapp/id1190919287?ls=1&mt=8
//        static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@";
        //static NSString *const iOSAppStoreURLFormat = @"https://itunes.apple.com/us/app/lomiapp/id1190919287?ls=1&mt=8";
        NSURL *appStoreLink = [NSURL URLWithString:[NSString stringWithFormat:g_strStoreURL]];
        //NSLog(@"g_strStoreURL = [%@]", g_strStoreURL);
        //NSLog(@"appStoreLink = [%@]", appStoreLink);
        [[UIApplication sharedApplication] openURL:appStoreLink];
        
        
        /*
        if ([controller isKindOfClass:[CVCLoginController class]]) {
            
            CVCLoginController* class = (CVCLoginController*)controller;
            
        } else if ( [controller isKindOfClass:[CVCSplashViewController class]]) {
            
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
        }
         */
        
    }];
    [alert addAction:noAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void) showNetworkErrorAlert:(UIViewController*)controller {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")
                                  message:NSLocalizedString(@"ALERT_MESSAGE_NETWORKERROR", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button

        if ([controller isKindOfClass:[CVCSplashViewController class]])
        {
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
        } else if ([controller isKindOfClass:[CVCLoginController class]]) {
            
            CVCLoginController* class = (CVCLoginController*)controller;
            [class onClickAlertOK];
        }

    }];
    [alert addAction:okAction];
    //UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void) showNetworkErrorAlertWithYesNo:(UIViewController*)controller type:(int)type {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")
                                  message:NSLocalizedString(@"ALERT_MESSAGE_NETWORKERROR_RELOAD", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_YES", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        if ([controller isKindOfClass:[CVCSplashViewController class]]) {
            
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
            
        } else if ( [controller isKindOfClass:[CChooseNutritionistViewController class]]) {
            
            CChooseNutritionistViewController* class = (CChooseNutritionistViewController*)controller;
            [class onAlertYES:type];
        }
        
        
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_NO", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        if ([controller isKindOfClass:[CVCSplashViewController class]]) {
            
            CVCSplashViewController* class = (CVCSplashViewController*)controller;
            [class onClickAlertOK];
            
        } else if ( [controller isKindOfClass:[CChooseNutritionistViewController class]]) {
            
            CChooseNutritionistViewController* class = (CChooseNutritionistViewController*)controller;
            [class onAlertNO:type];
        }
        
    }];
    [alert addAction:noAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void) setState:(TaskState)curState nextState:(TaskState)nextState {
    
    g_nPrevState    = curState;
    g_nCurState     = nextState;
}
+ (NSInteger) getState {
    
    return g_nCurState;
}

+ (NSString*) countryFullName:(NSString*)countrycode {
    
    for (int i = 0; i < g_arrCountryCode.count; i++)
        if ([countrycode isEqualToString:g_arrCountryCode[i]])
            return g_arrCountryFullName[i];
    return nil;
}

+ (NSString*) countryCode:(NSString*)countryFullName {
    
    for (int i = 0; i < g_arrCountryFullName.count; i++)
        if ([countryFullName isEqualToString:g_arrCountryFullName[i]])
            return g_arrCountryCode[i];
    return nil;
}

+ (NSInteger) countryIndex:(NSString*)countryFullName {
    
    for (int i = 0; i < g_arrCountryFullName.count; i++)
        if ([countryFullName isEqualToString:g_arrCountryFullName[i]])
            return i;
    return 0;
}

+ (NSInteger) countryIndexFromCode:(NSString*)countrycode {
    
    for (int i = 0; i < g_arrCountryCode.count; i++)
        if ([countrycode isEqualToString:g_arrCountryCode[i]])
            return i;
    return 0;
}
+ (NSInteger) wunitIndexFromValue:(NSString*)value
{
    for (int i = 0; i < g_arrWUnitValue.count; i++)
    {
        if ([value isEqualToString:g_arrWUnitValue[i]])
        {
            return i;
        }
    }
    return 0;
}
+ (NSInteger) lunitIndexFromValue:(NSString*)value
{
    for (int i = 0; i < g_arrLUnitValue.count; i++)
    {
        if ([value isEqualToString:g_arrLUnitValue[i]])
        {
            return i;
        }
    }
    return 0;
}

+ (Boolean) isInNotificationArray:(NSMutableArray*)array model:(CNotificationModel*)newModel
{
    
    for (int i = 0; i < array.count; i++) {
        
        CNotificationModel* model = (CNotificationModel*)[array objectAtIndex:i];
        
        if (newModel.notificationId == model.notificationId)
            return true;
    }
    return false;
}

+ (void) showProgressHUD:(UIViewController*)controller {
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    
    UIImage* gifImg = [UIImage sd_animatedGIFNamed:@"spinner_transparent"];
    UIImageView *img = [[UIImageView alloc] initWithImage:gifImg];

    HUD.color = [UIColor clearColor];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = img;
    
    HUD.labelText = @"";
    HUD.dimBackground = YES;
}

+ (void) hideProgressHUD:(UIViewController*)controller; {
    
    [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
}

+ (void)setLanguage:(NSString*)strLan
{
//    [NSBundle setLanguage:strLan];
//    if ([strLan isEqualToString:@"ar"])
//        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//    else
//        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    //[CGlobal reloadRootViewController];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:strLan, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)reloadRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

+ (BOOL)isWeightDietReason
{
    if (g_pUserModel == nil || g_pUserModel.arrDietReasons == nil)
        return NO;
    
    NSString* strDiet = @"";
    for (int i = 0; i < g_pUserModel.arrDietReasons.count; i++)
    {
        if ([g_pUserModel.arrDietReasons[i] boolValue] == YES)
        {
            strDiet = g_arrDietReasonsValue[i];
        }
    }
    
    if ([strDiet isEqualToString:@"502"]) // is Weight management / Healthy lifestyle diet
    {
        return YES;
    }
    return NO;
}

+ (void)goMaintainance:(CUIViewController*)controller
{
//    CVCMaintainanceViewController *maintainController = [[CVCMaintainanceViewController alloc] init];
    CVCMaintainanceViewController* maintainController = (CVCMaintainanceViewController*)[controller.storyboard instantiateViewControllerWithIdentifier:@"VC_MAINTAINANCE"];
    [controller presentViewController:maintainController animated:YES
                           completion:nil];
}


@end
