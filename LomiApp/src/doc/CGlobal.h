//
//  CGlobal.h
//
//  Created by apple on 9/7/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CConstant.h"
#import "CServiceManager.h"
#import "CPreferenceManager.h"
#import "MBProgressHUD.h"
#import "CUserModel.h"
#import "CUtility.h"
#import "CVCTabHomeViewController.h"
#import "CNotificationModel.h"
#import "CTimeZoneModel.h"
#import "CVCMaintainanceViewController.h"

typedef NS_ENUM(NSInteger, TaskState)
{
    TASKSTATE_NONE                          = 0,
    
    TASKSTATE_SIGN                          = 1,
    TASKSTATE_LOGIN                         = 2,
    TASKSTATE_FORGOTPASS                    = 3,
    TASKSTATE_SIGNUP                        = 4,
    TASKSTATE_REG_QUESTIONARIES             = 5,
    TASKSTATE_REG_BODYMEASUREMENTS          = 6,
    TASKSTATE_REG_CHOOSENUTRITIONIST        = 7,
    TASKSTATE_TAB_HOME                      = 8,
    TASKSTATE_TAB_JOURNAL                   = 9,
    TASKSTATE_TAB_DAILYPLAN                 = 10,
    TASKSTATE_TAB_PROGRESS                  = 11,
    TASKSTATE_TAB_MESSAGES                  = 12,
    TASKSTATE_TAB_PROFILE                   = 13,
    TASKSTATE_SETTING                       = 14,
    TASKSTATE_PROFILE_NUT                   = 15,
    TASKSTATE_PROFILE_QUESTIONNAIRE         = 16,
    TASKSTATE_PROFILE_BODYMEASUREMENT       = 17,
    TASKSTATE_PROFILE_EDIT                  = 18,
    TASKSTATE_SETTING_UPDATE                = 19,
    TASKSTATE_SETTING_UPDATE_PROMOTION      = 20,
    TASKSTATE_SETTING_UPDATE_STRIPE         = 21,
    TASKSTATE_SETTING_CONTACTUS             = 22,
};

extern TaskState                            g_nPrevState;
extern TaskState                            g_nCurState;

extern NSString*                            g_strEmail;
extern NSString*                            g_strPassword;

extern BOOL                                 g_socialTypeFB;
extern NSMutableDictionary*                 g_twUserDic;
extern id                                   g_fbResult;

extern CUserModel*                          g_pUserModel;
extern CTimeZoneModel*                      g_pTimeZoneModel;

extern NSArray*                             g_arrWUnitString;
extern NSArray*                             g_arrWUnitValue;
extern NSArray*                             g_arrLUnitString;
extern NSArray*                             g_arrLUnitValue;
extern NSMutableArray*                             g_arrCountryCode;
extern NSMutableArray*                             g_arrNutCountryCode;
extern NSMutableArray*                             g_arrCountryFullName;
extern NSMutableArray*                             g_arrCountryFullNameLocalized;
extern NSMutableArray*                             g_arrNutCountryFullName;
extern NSArray*                             g_arrDietReasonsValue;
extern NSArray*                             g_arrSportValue;
extern NSArray*                             g_arrWorkValue;
extern NSArray*                             g_arrFoodKindValue;
extern NSArray*                             g_arrSpecialityFilterValue;
extern NSMutableArray*                      g_arrNotificationForJournal;
extern NSMutableArray*                      g_arrNotificationForDietPlan;
extern NSMutableArray*                      g_arrNotificationForMessage;
extern NSMutableArray*                      g_arrNotificationForExpiration;
extern NSMutableArray*                      g_arrNotificationForMeasurement;
extern NSMutableArray*                      g_arrNotificationForQuestionnaire;
extern NSMutableArray*                      g_arrSpecialityFilter;
extern NSMutableArray*                      g_arrPlans;
extern NSMutableArray*                      g_arrPromotionPlans;
extern bool                                 g_bIsPackageIdle;
extern bool                                 g_bPaid;
extern CVCTabHomeViewController*            g_vcTabHome;
extern NSString*                            g_strTelephone;

extern NSString*                            g_strMaintainance;

extern NSString*                            g_strDeviceToken;

extern NSString*                            g_strPushType;

extern NSString*                            g_strStoreURL;

@interface CGlobal : NSCoder


+ (void) initAppConstantVariables;
+ (void) showAlert:(UIViewController*)controller message:(NSString*)strMessage title:(NSString*)strTitle;
+ (void) showAlertWithYesNo:(UIViewController*)controller type:(int)type message:(NSString*)strMessage title:(NSString*)strTitle;
+ (void) showAlertWithIgnoreSure:(UIViewController*)controller type:(int)type message:(NSString*)strMessage title:(NSString*)strTitle;

+ (void) showNetworkErrorAlert:(UIViewController*)controller;
+ (void) showNetworkErrorAlertWithYesNo:(UIViewController*)controller type:(int)type;
+ (void) showProgressHUD:(UIViewController*)controller;
+ (void) hideProgressHUD:(UIViewController*)controller;

+ (void) setState:(TaskState)curState nextState:(TaskState)nextState;
+ (NSInteger) getState;

+ (NSString*) countryFullName:(NSString*)countrycode;
+ (NSString*) countryCode:(NSString*)countryFullName;
+ (NSInteger) countryIndex:(NSString*)countryFullName;
+ (NSInteger) countryIndexFromCode:(NSString*)countrycode;
+ (NSInteger) wunitIndexFromValue:(NSString*)value;
+ (NSInteger) lunitIndexFromValue:(NSString*)value;

+ (Boolean) isInNotificationArray:(NSMutableArray*)array model:(CNotificationModel*)newModel;

+ (void)setLanguage:(NSString*)strLan;
+ (void)reloadRootViewController;
+ (BOOL)isWeightDietReason;
+ (void)goMaintainance:(CUIViewController*)controller;

@end
