//
//  CNutritionistModel.m
//  LomiApp
//
//  Created by TwinkleStar on 10/31/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CNutritionistModel.h"

@implementation CNutritionistModel

@synthesize fRateAVG,
            nCountVoters,
            nNutritionistId,
            nMemberCount,
            nViewCount,
            nOwnerId,
            fullybooked,
            recommended,
            strTitle,
            strDescription,
            strOwnerName,
            strThumbnail,
            strGender,
            strCountryFullName,
            strCountryValue,
            strBirthday,
            strMobile,
            strLanguage;


- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.fRateAVG           = [decoder decodeDoubleForKey:@"NUTRITIONIST_RATEAVG"];
        self.nCountVoters       = [decoder decodeIntegerForKey:@"NUTRITIONIST_COUNTVOTERS"];
        self.nNutritionistId    = [decoder decodeIntegerForKey:@"NUTRITIONIST_NUTRITIONISTID"];
        self.nMemberCount       = [decoder decodeIntegerForKey:@"NUTRITIONIST_MEMBERCOUNT"];
        self.nViewCount         = [decoder decodeIntegerForKey:@"NUTRITIONIST_VIEWCOUNT"];
        self.nOwnerId           = [decoder decodeIntegerForKey:@"NUTRITIONIST_OWNERID"];
        self.fullybooked        = [decoder decodeBoolForKey:@"NUTRITIONIST_FULLYBOOKED"];
        self.recommended        = [decoder decodeBoolForKey:@"NUTRITIONIST_RECOMMENDED"];
        self.strTitle           = [decoder decodeObjectForKey:@"NUTRITIONIST_TITLE"];
        self.strDescription     = [decoder decodeObjectForKey:@"NUTRITIONIST_DESCRIPTION"];
        self.strOwnerName       = [decoder decodeObjectForKey:@"NUTRITIONIST_OWNERNAME"];
        self.strThumbnail       = [decoder decodeObjectForKey:@"NUTRITIONIST_THUMBNAIL"];
        self.strGender          = [decoder decodeObjectForKey:@"NUTRITIONIST_GENDER"];
        self.strCountryFullName = [decoder decodeObjectForKey:@"NUTRITIONIST_COUNTRYFULLNAME"];
        self.strCountryValue    = [decoder decodeObjectForKey:@"NUTRITIONIST_COUNTRYVALUE"];
        self.strBirthday        = [decoder decodeObjectForKey:@"NUTRITIONIST_BIRTHDAY"];
        self.strMobile          = [decoder decodeObjectForKey:@"NUTRITIONIST_MOBILE"];
        self.strLanguage        = [decoder decodeObjectForKey:@"NUTRITIONIST_LANGUAGE"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeDouble:fRateAVG forKey:@"NUTRITIONIST_RATEAVG"];
    [encoder encodeInteger:nCountVoters forKey:@"NUTRITIONIST_COUNTVOTERS"];
    [encoder encodeInteger:nNutritionistId forKey:@"NUTRITIONIST_NUTRITIONISTID"];
    [encoder encodeInteger:nMemberCount forKey:@"NUTRITIONIST_MEMBERCOUNT"];
    [encoder encodeInteger:nViewCount forKey:@"NUTRITIONIST_VIEWCOUNT"];
    [encoder encodeInteger:nOwnerId forKey:@"NUTRITIONIST_OWNERID"];
    [encoder encodeBool:fullybooked forKey:@"NUTRITIONIST_FULLYBOOKED"];
    [encoder encodeBool:recommended forKey:@"NUTRITIONIST_RECOMMENDED"];
    [encoder encodeObject:strTitle forKey:@"NUTRITIONIST_TITLE"];
    [encoder encodeObject:strDescription forKey:@"NUTRITIONIST_DESCRIPTION"];
    [encoder encodeObject:strOwnerName forKey:@"NUTRITIONIST_OWNERNAME"];
    [encoder encodeObject:strThumbnail forKey:@"NUTRITIONIST_THUMBNAIL"];
    [encoder encodeObject:strGender forKey:@"NUTRITIONIST_GENDER"];
    [encoder encodeObject:strCountryFullName forKey:@"NUTRITIONIST_COUNTRYFULLNAME"];
    [encoder encodeObject:strCountryValue forKey:@"NUTRITIONIST_COUNTRYVALUE"];
    [encoder encodeObject:strBirthday forKey:@"NUTRITIONIST_BIRTHDAY"];
    [encoder encodeObject:strMobile forKey:@"NUTRITIONIST_MOBILE"];
    [encoder encodeObject:strLanguage forKey:@"NUTRITIONIST_LANGUAGE"];

}

- (void) inititalize
{
    [self deleteAll];
    
    self.fRateAVG           = 0;
    self.nCountVoters       = 0;
    self.nNutritionistId    = 0;
    self.nMemberCount       = 0;
    self.nViewCount         = 0;
    self.nOwnerId           = 0;
    self.fullybooked        = false;
    self.recommended        = false;
    self.strTitle           = nil;
    self.strDescription     = nil;
    self.strOwnerName       = nil;
    self.strThumbnail       = nil;
    self.strGender          = nil;
    self.strCountryFullName = nil;
    self.strCountryValue    = nil;
    self.strBirthday        = nil;
    self.strMobile          = nil;
    self.strLanguage        = @"";
}

- (id)init
{
    
    if ((self = [super init]))
    {
        [self inititalize];
    }
    
    return self;
}

- (void) deleteAll
{
    self.fRateAVG           = 0;
    self.nCountVoters       = 0;
    self.nNutritionistId    = 0;
    self.nMemberCount       = 0;
    self.nViewCount         = 0;
    self.nOwnerId           = 0;
    self.fullybooked        = false;
    self.recommended        = false;
    self.strTitle           = nil;
    self.strDescription     = nil;
    self.strOwnerName       = nil;
    self.strThumbnail       = nil;
    self.strGender          = nil;
    self.strCountryFullName = nil;
    self.strCountryValue    = nil;
    self.strBirthday        = nil;
    self.strMobile          = nil;
    self.strLanguage        = @"";
}
@end
