//
//  CServiceManager.h
//
//  Created by apple on 9/21/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CConstant.h"
#import "CUIViewController.h"
#import "CNutSearchModel.h"
#import "CNutritionistModel.h"
#import "CMessageModel.h"
#import "CJournalSearchModel.h"
#import "CProfileFieldModel.h"
#import "CPromotionModel.h"
#import "CPromotionInfoModel.h"

@interface CServiceManager : NSCoder

+ (void) onGetStoreURL;
+ (void) onGetUserCountryList;
+ (void) onGetNutCountryList;
+ (void) onLoginUser:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onLogout:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onSignup:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onSocialSignup:(const CUIViewController*) mVCPage  type:(int)type fb_uid:(NSString *)fb_uid;
+ (void) onSocialSync:(const CUIViewController*) mVCPage  type:(int)type fbid:(NSString *)fb_uid userid:(NSString *)uid;
+ (void) onSocialSignin:(const CUIViewController*) mVCPage type:(int)type id:(NSString *)fb_uid;
+ (void) onEmailCheck:(const CUIViewController*) mVCPage;
+ (void) onSocialExistCheck:(const CUIViewController*) mVCPage;
+ (void) onForgotPass:(const CUIViewController*) mVCPage;
+ (void) onQuestioners:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onProfileTypes:(const CUIViewController*) mVCPage;
+ (void) onProfileFields:(const CUIViewController*) mVCPage;
+ (void) onProfileAddress:(const CUIViewController*) mVCPage;
+ (void) onEditProfile:(const CUIViewController*) mVCPage type:(int)type model:(CProfileFieldModel*)model;
+ (void) onUserProfile:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetUserProfilePhoto:(const CUIViewController*) mVCPage;
+ (void) onSetUserProfilePhoto:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onRemoveUserProfilePhoto:(const CUIViewController*) mVCPage;
+ (void) onGetMobileSettings:(const CUIViewController*) mVCPage  type:(int)type;
+ (void) onEditMobileSettings:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetLanByType:(const CUIViewController*) mVCPage;
+ (void) onGetUserLan:(const CUIViewController*) mVCPage  type:(int)type;
+ (void) onEditUserLan:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetAllNutritionists:(const CUIViewController*) mVCPage type:(int)type model:(CNutSearchModel*)model;
+ (void) onGetNutritionistMemebers:(const CUIViewController*) mVCPage;
+ (void) onGetUserNutritionist:(const CUIViewController*) mVCPage  type:(int)type;
+ (void) onNutritionistMembership:(const CUIViewController*) mVCPage type:(int)type model:(CNutritionistModel*)model isSelect:(BOOL)select;
+ (void) onRateNutritionist:(const CUIViewController*) mVCPage type:(int)type rate:(NSInteger)rate;
+ (void) onGetUserMeasurements:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onAddNewMeasurement:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onEditMeasurement:(const CUIViewController*) mVCPage;
+ (void) onDeleteMeasurement:(const CUIViewController*) mVCPage;
+ (void) onGetLastMeasurement:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetWeights:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetDietPlans:(const CUIViewController*) mVCPage  type:(int)type date:(NSString*)date;
+ (void) onGetUserPhotos:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model;
+ (void) onGetApprovedPhotos:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model;
+ (void) onPostPhoto:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model;
+ (void) onGetComments:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model;
+ (void) onPostComments:(const CUIViewController*) mVCPage type:(int)type model:(CJournalSearchModel*)model;
+ (void) onDeleteComments:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onPostMessage:(const CUIViewController*) mVCPage type:(int)type model:(CMessageModel*)model;
+ (void) onGetConversations:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetNotifications:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onGetNotificationTypes:(const CUIViewController*) mVCPage;
+ (void) onSetReadNotification:(const CUIViewController*) mVCPage type:(int)type notificationId:(NSInteger)value;
+ (void) onGetUserPlan:(const CUIViewController*) mVCPage  type:(int)type;
+ (void) onGetSubscriptionPlans:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onAddUserPayment:(const CUIViewController*) mVCPage type:(int)type model:(CPromotionModel*)model;
+ (void) onGetPromotionCodeCheck:(const CUIViewController*) mVCPage type:(int)type code:(NSString*)code;
+ (void) onStartPaymentProcess:(const CUIViewController*) mVCPage type:(int)type gateway:(NSString*)gateway;
+ (void) onAddNewPayment:(const CUIViewController*) mVCPage type:(int)type identificationID:(NSString*)identificationID amount:(NSDecimalNumber*)amount status:(NSString*)status;
+ (void) onGetUserTimezone:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onSetUserTimezone:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onEditTelephone:(const CUIViewController*) mVCPage type:(int)type model:(NSString*)telephone;
+ (void) onPostContact:(const CUIViewController*) mVCPage type:(int)type body:(NSString*)body meta:(NSString*)meta;
+ (void) onPostCouponCode:(const CUIViewController*) mVCPage type:(int)type code:(NSString*)code;
+ (void) onPostWirePayment:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onSetLastLogin:(const CUIViewController*) mVCPage type:(int)type;
+ (void) onSendOSVersion:(const CUIViewController*) mVCPage type:(int)type;

@end
