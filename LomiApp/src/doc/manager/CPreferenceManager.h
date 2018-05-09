//
//  CPreferenceManager.h
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CConstant.h"
#import "CUserModel.h"

@interface CPreferenceManager : NSCoder

+ (void) setObject:(id) strValue  forKey:(NSString*) strKey;
+ (id) objectForKey:(NSString*) strKey;

+ (BOOL)        isFirstRun;

+ (void)        saveState:(NSInteger)value;
+ (NSInteger)   loadState;

+ (void)        saveLanguage:(NSString*)value;
+ (NSString*)   loadLanguage;

+ (void)        saveEmail:(NSString*)value;
+ (NSString*)   loadEmail;

+ (void)        savePassword:(NSString*)value;
+ (NSString*)   loadPassword;

+ (void)        saveUserModel:(CUserModel*)object;
+ (CUserModel*) loadUserModel;

+ (void)        saveExtendedMessageTime:(NSString*)value;
+ (NSString*)   loadExtendedMessageTime;

@end
