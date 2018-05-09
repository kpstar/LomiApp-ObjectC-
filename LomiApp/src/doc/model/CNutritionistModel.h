//
//  CNutritionistModel.h
//  LomiApp
//
//  Created by TwinkleStar on 10/31/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNutritionistModel : NSObject<NSCoding>

@property   float            fRateAVG;
@property   NSInteger        nCountVoters;
@property   NSInteger        nNutritionistId;
@property   NSInteger        nMemberCount;
@property   NSInteger        nViewCount;
@property   NSInteger        nOwnerId;
@property   BOOL             fullybooked;
@property   BOOL             recommended;

@property   NSString*        strTitle;
@property   NSString*        strDescription;
@property   NSString*        strOwnerName;
@property   NSString*        strThumbnail;
@property   NSString*        strGender;
@property   NSString*        strCountryFullName;
@property   NSString*        strCountryValue;
@property   NSString*        strBirthday;
@property   NSString*        strMobile;
@property   NSString*        strLanguage;

- (void)        inititalize;
- (void)        deleteAll;
@end
