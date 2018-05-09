//
//  CMobileSettingModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/6/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMobileSettingModel : NSObject<NSCoding>

@property   BOOL        bMusic;
@property   BOOL        bSoundEffect;
@property   BOOL        bVibration;
@property   BOOL        bPrivacyMode;
@property   BOOL        bChallengeNotification;
@property   BOOL        bChatNotification;
@property   BOOL        bFriendNotification;
@property   NSString*   strWeightUnit;
@property   NSString*   strHeightUnit;
@property   NSString*   strLanguage;

- (void)        inititalize;
- (void)        deleteAll;

@end
