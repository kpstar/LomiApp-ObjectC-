//
//  CUserModel.h
//  LomiApp
//
//  Created by TwinkleStar on 10/31/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CNutritionistModel.h"
#import "CBodyMeasurementModel.h"
#import "CMobileSettingModel.h"
#import "CWeightModel.h"
#import "CPaymentPlanModel.h"


@interface CUserModel : NSObject <NSCoding>

@property   UIImage          *imgAvatar;
@property   NSString         *strEmail;
@property   NSString         *strPassword;
@property   NSString         *strFirstName;
@property   NSString         *strLastName;
@property   NSString         *strGenderMale;
@property   NSString         *strBirthday;
@property   NSString         *strCountryCode;
//@property   NSString         *strCountryValue;
@property   NSString         *strProfileAddress;
@property   NSString         *strProfileType;

@property   NSString         *strSubPackageDescription;
@property   NSString         *strSubPackageExpDate;
@property   NSInteger        nSubPackageID;
@property   NSString         *strSubPackageTitle;
@property   NSString         *strThumbnail;
@property   NSInteger        nUserID;
@property   NSString         *strUserToken;
@property   NSString         *strUserName;

@property   NSMutableArray   *arrDietReasons;
@property   NSMutableArray   *arrSport;
@property   NSMutableArray   *arrWork;
@property   NSMutableArray   *arrFoodKind;
@property   NSString         *strDiseases;
@property   NSString         *strTelephone;
@property   float            fWeight;


@property   CNutritionistModel      *pNutModel;
@property   CBodyMeasurementModel   *pStartBodyMeasurementModel;
@property   CBodyMeasurementModel   *pBodyMeasurementModel;
@property   CMobileSettingModel     *pMobileSettingModel;
@property   CWeightModel            *pWeightModel;
@property   CPaymentPlanModel       *pPaymentModel;
@property   CPaymentPlanModel       *pSelectedPaymentModel;

- (void)        inititalize;
- (void)        deleteAll;

- (void)        setDietReasons:(NSMutableString*)value;

@end
