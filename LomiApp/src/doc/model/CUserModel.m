//
//  CUserModel.m
//  LomiApp
//
//  Created by TwinkleStar on 10/31/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUserModel.h"
#import "CGlobal.h"

@implementation CUserModel

@synthesize imgAvatar,
            strEmail,
            strPassword,
            strProfileAddress,
            strProfileType,
            strFirstName,
            strLastName,
            strGenderMale,
            strBirthday,
            strCountryCode,
//            strCountryValue,
            strSubPackageDescription,
            strSubPackageExpDate,
            nSubPackageID,
            strSubPackageTitle,
            strThumbnail,
            nUserID,
            strUserToken,
            strUserName,
            arrDietReasons,
            arrSport,
            arrWork,
            arrFoodKind,
            strDiseases,
            strTelephone,
            fWeight,
            pNutModel,
            pStartBodyMeasurementModel,
            pBodyMeasurementModel,
            pMobileSettingModel,
            pWeightModel;

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.strEmail               = [decoder decodeObjectForKey:@"USER_EMAIL"];
        self.strPassword            = [decoder decodeObjectForKey:@"USER_PASSWORD"];
        self.strProfileAddress      = [decoder decodeObjectForKey:@"USER_PROFILEADDRESS"];
        self.strProfileType         = [decoder decodeObjectForKey:@"USER_PROFILETYPE"];
        self.strFirstName           = [decoder decodeObjectForKey:@"USER_FIRSTNAME"];
        self.strLastName            = [decoder decodeObjectForKey:@"USER_LASTNAME"];
        self.strGenderMale          = [decoder decodeObjectForKey:@"USER_GENDERMALE"];
        self.strBirthday            = [decoder decodeObjectForKey:@"USER_BIRTHDAY"];
        self.strCountryCode         = [decoder decodeObjectForKey:@"USER_COUNTRYCODE"];
//        self.strCountryValue        = [decoder decodeObjectForKey:@"USER_COUNTRYVALUE"];
        self.strSubPackageDescription    = [decoder decodeObjectForKey:@"USER_SUBPACKDESC"];
        self.strSubPackageExpDate   = [decoder decodeObjectForKey:@"USER_SUBPACKEXP"];
        self.nSubPackageID        = [decoder decodeIntegerForKey:@"USER_SUBPACKID"];
        self.strSubPackageTitle     = [decoder decodeObjectForKey:@"USER_SUBPACKTITLE"];
        self.strThumbnail           = [decoder decodeObjectForKey:@"USER_THUMBNAIL"];
        self.nUserID              = [decoder decodeIntegerForKey:@"USER_USERID"];
        self.strUserToken           = [decoder decodeObjectForKey:@"USER_USERTOKEN"];
        self.strUserName            = [decoder decodeObjectForKey:@"USER_USERNAME"];
        self.arrDietReasons         = [decoder decodeObjectForKey:@"USER_DIETREASONS"];
        self.arrSport               = [decoder decodeObjectForKey:@"USER_SPORT"];
        self.arrWork                = [decoder decodeObjectForKey:@"USER_WORK"];
        self.arrFoodKind            = [decoder decodeObjectForKey:@"USER_FOODKIND"];
        self.strDiseases            = [decoder decodeObjectForKey:@"USER_DISEASES"];
        self.strTelephone           = [decoder decodeObjectForKey:@"USER_TELEPHONE"];
        self.fWeight                = [decoder decodeDoubleForKey:@"USER_WEIGHT"];
        self.pNutModel              = [decoder decodeObjectForKey:@"USER_NUT"];
        
        self.pStartBodyMeasurementModel  = [decoder decodeObjectForKey:@"USER_STARTBODYMEASUREMENT"];
        self.pBodyMeasurementModel  = [decoder decodeObjectForKey:@"USER_BODYMEASUREMENT"];
        self.pMobileSettingModel    = [decoder decodeObjectForKey:@"USER_MOBILESETTING"];
        self.pWeightModel           = [decoder decodeObjectForKey:@"USER_WEIGHTMODEL"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeObject:strEmail forKey:@"USER_EMAIL"];
    [encoder encodeObject:strPassword forKey:@"USER_PASSWORD"];
    [encoder encodeObject:strProfileAddress forKey:@"USER_PROFILEADDRESS"];
    [encoder encodeObject:strProfileType forKey:@"USER_PROFILETYPE"];
    [encoder encodeObject:strFirstName forKey:@"USER_FIRSTNAME"];
    [encoder encodeObject:strLastName forKey:@"USER_LASTNAME"];
    [encoder encodeObject:strGenderMale forKey:@"USER_GENDERMALE"];
    [encoder encodeObject:strBirthday forKey:@"USER_BIRTHDAY"];
    [encoder encodeObject:strCountryCode forKey:@"USER_COUNTRYCODE"];
//    [encoder encodeObject:strCountryValue forKey:@"USER_COUNTRYVALUE"];
    [encoder encodeObject:strSubPackageDescription forKey:@"USER_SUBPACKDESC"];
    [encoder encodeObject:strSubPackageExpDate forKey:@"USER_SUBPACKEXP"];
    [encoder encodeInteger:nSubPackageID forKey:@"USER_SUBPACKID"];
    [encoder encodeObject:strSubPackageTitle forKey:@"USER_SUBPACKTITLE"];
    [encoder encodeObject:strThumbnail forKey:@"USER_THUMBNAIL"];
    [encoder encodeInteger:nUserID forKey:@"USER_USERID"];
    [encoder encodeObject:strUserToken forKey:@"USER_USERTOKEN"];
    [encoder encodeObject:strUserName forKey:@"USER_USERNAME"];
    [encoder encodeObject:arrDietReasons forKey:@"USER_DIETREASONS"];
    [encoder encodeObject:arrSport forKey:@"USER_SPORT"];
    [encoder encodeObject:arrWork forKey:@"USER_WORK"];
    [encoder encodeObject:arrFoodKind forKey:@"USER_FOODKIND"];
    [encoder encodeObject:strDiseases forKey:@"USER_DISEASES"];
    [encoder encodeObject:strTelephone forKey:@"USER_TELEPHONE"];
    [encoder encodeDouble:fWeight forKey:@"USER_WEIGHT"];
    [encoder encodeObject:pNutModel forKey:@"USER_NUT"];
    [encoder encodeObject:pStartBodyMeasurementModel forKey:@"USER_STARTBODYMEASUREMENT"];
    [encoder encodeObject:pBodyMeasurementModel forKey:@"USER_BODYMEASUREMENT"];
    [encoder encodeObject:pMobileSettingModel forKey:@"USER_MOBILESETTING"];
    [encoder encodeObject:pWeightModel forKey:@"USER_WEIGHTMODEL"];

}

- (id)init
{
    
    if ((self = [super init]))
    {
        [self inititalize];
    }
    
    return self;
}

- (void) inititalize
{
    [self deleteAll];
    
    self.imgAvatar              = nil;
    self.strEmail               = nil;
    self.strPassword            = nil;
    self.strProfileAddress      = nil;
    self.strProfileType         = @"410";
    self.strFirstName           = nil;
    self.strLastName            = nil;
    self.strGenderMale          = nil;
    self.strBirthday            = nil;
    self.strCountryCode         = nil;
//    self.strCountryValue        = nil;
    self.strSubPackageDescription    = nil;
    self.strSubPackageExpDate   = nil;
    self.nSubPackageID          = 0;
    self.strSubPackageTitle     = nil;
    self.strThumbnail           = nil;
    self.nUserID                = 0;
    self.strUserToken           = nil;
    self.strUserName            = nil;
    self.arrDietReasons         = [[NSMutableArray alloc] init];;
    self.arrSport               = [[NSMutableArray alloc] init];;
    self.arrWork                = [[NSMutableArray alloc] init];;
    self.arrFoodKind            = [[NSMutableArray alloc] init];;
    self.strDiseases            = nil;
    self.strTelephone           = @"";
    self.fWeight                = 0;
    self.pNutModel              = [[CNutritionistModel alloc] init];
    self.pStartBodyMeasurementModel  = [[CBodyMeasurementModel alloc] init];
    self.pBodyMeasurementModel  = [[CBodyMeasurementModel alloc] init];
    self.pMobileSettingModel    = [[CMobileSettingModel alloc] init];
    self.pWeightModel           = [[CWeightModel alloc] init];
    self.pPaymentModel          = nil;
    self.pSelectedPaymentModel  = nil;
    
}


- (void) deleteAll
{
    self.imgAvatar              = nil;
    self.strEmail               = nil;
    self.strPassword            = nil;
    self.strProfileAddress      = nil;
    self.strProfileType         = @"410";
    self.strFirstName           = nil;
    self.strLastName            = nil;
    self.strGenderMale          = nil;
    self.strBirthday            = nil;
    self.strCountryCode         = nil;
//    self.strCountryValue        = nil;
    self.strSubPackageDescription    = nil;
    self.strSubPackageExpDate   = nil;
    self.nSubPackageID          = 0;
    self.strSubPackageTitle     = nil;
    self.strThumbnail           = nil;
    self.nUserID                = 0;
    self.strUserToken           = nil;
    self.strUserName            = nil;
    [self.arrDietReasons removeAllObjects];
    self.arrDietReasons         = nil;
    [self.arrSport removeAllObjects];
    self.arrSport               = nil;
    [self.arrWork removeAllObjects];
    self.arrWork                = nil;
    [self.arrFoodKind removeAllObjects];
    self.arrFoodKind            = nil;
    self.strDiseases            = nil;
    self.strTelephone           = @"";
    self.fWeight                = 0;
    [self.pNutModel deleteAll];
    self.pNutModel              = nil;
    [self.pStartBodyMeasurementModel deleteAll];
    self.pStartBodyMeasurementModel  = nil;
    [self.pBodyMeasurementModel deleteAll];
    self.pBodyMeasurementModel  = nil;
    [self.pMobileSettingModel deleteAll];
    self.pMobileSettingModel    = nil;
    [self.pWeightModel deleteAll];
    self.pWeightModel    = nil;

}

- (void)setDietReasons:(NSMutableString *)value
{
    
}


@end


