//
//  CMobileSettingModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/6/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CMobileSettingModel.h"

@implementation CMobileSettingModel

@synthesize bMusic,
            bSoundEffect,
            bVibration,
            bPrivacyMode,
            bChallengeNotification,
            bChatNotification,
            bFriendNotification,
            strLanguage,
            strWeightUnit,
            strHeightUnit;

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.bMusic     = [decoder decodeBoolForKey:@"MOBILESETTING_MUSIC"];
        self.bSoundEffect  = [decoder decodeBoolForKey:@"MOBILESETTING_SOUNDEFFECT"];
        self.bVibration    = [decoder decodeBoolForKey:@"MOBILESETTING_VIBRATION"];
        self.bPrivacyMode        = [decoder decodeBoolForKey:@"MOBILESETTING_PRIVACYMODE"];
        self.bChallengeNotification   = [decoder decodeBoolForKey:@"MOBILESETTING_CHALLENGENOTIFICATION"];
        self.bChatNotification    = [decoder decodeBoolForKey:@"MOBILESETTING_CHATNOTIFICATION"];
        self.bFriendNotification      = [decoder decodeBoolForKey:@"MOBILESETTING_FRIENDNOTIFICATION"];
        self.strWeightUnit  = [decoder decodeObjectForKey:@"MOBILESETTINGS_WEIGHTUNIT"];
        self.strHeightUnit  = [decoder decodeObjectForKey:@"MOBILESETTINGS_HEIGHTUNIT"];
        self.strLanguage      = [decoder decodeObjectForKey:@"MOBILESETTING_LANGUAGE"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeBool:bMusic forKey:@"MOBILESETTING_MUSIC"];
    [encoder encodeBool:bSoundEffect forKey:@"MOBILESETTING_SOUNDEFFECT"];
    [encoder encodeBool:bVibration forKey:@"MOBILESETTING_VIBRATION"];
    [encoder encodeBool:bPrivacyMode forKey:@"MOBILESETTING_PRIVACYMODE"];
    [encoder encodeBool:bChallengeNotification forKey:@"MOBILESETTING_CHALLENGENOTIFICATION"];
    [encoder encodeBool:bChatNotification forKey:@"MOBILESETTING_CHATNOTIFICATION"];
    [encoder encodeBool:bFriendNotification forKey:@"MOBILESETTING_FRIENDNOTIFICATION"];
    [encoder encodeObject:strWeightUnit forKey:@"MOBILESETTINGS_WEIGHTUNIT"];
    [encoder encodeObject:strHeightUnit forKey:@"MOBILESETTINGS_HEIGHTUNIT"];
    [encoder encodeObject:strLanguage forKey:@"MOBILESETTING_LANGUAGE"];
}

- (void) inititalize
{
    [self deleteAll];
    
    self.bMusic         = NO;
    self.bSoundEffect   = NO;
    self.bVibration     = NO;
    self.bPrivacyMode   = NO;
    self.bChallengeNotification = NO;
    self.bChatNotification      = NO;
    self.bFriendNotification    = NO;
    self.strLanguage            = @"en";
    self.strWeightUnit          = @"kg";
    self.strHeightUnit          = @"cm";
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
    self.bMusic         = NO;
    self.bSoundEffect   = NO;
    self.bVibration     = NO;
    self.bPrivacyMode   = NO;
    self.bChallengeNotification = NO;
    self.bChatNotification      = NO;
    self.bFriendNotification    = NO;
    self.strLanguage            = @"en";
    self.strWeightUnit          = @"kg";
    self.strHeightUnit          = @"cm";
}


@end
