//
//  CPreferenceManager.m
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CPreferenceManager.h"

@implementation CPreferenceManager

+ (void) setObject:(id) strValue  forKey:(NSString*) strKey {
    
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:strValue forKey:strKey];
    [preference synchronize];
}

+ (id) objectForKey:(NSString*) strKey {

    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    id ret = [preference objectForKey:strKey];
    return ret;
}

+ (BOOL) isFirstRun {
    
    NSString* strIsFirstRun = [CPreferenceManager objectForKey:PREF_ISFIRSTRUN];
    
    if (strIsFirstRun == nil)
        return true;
    else
        return false;
}

+ (void) saveState:(NSInteger)value {
    
    NSString *strValue = [NSString stringWithFormat:@"%ld", (long)value];
    [CPreferenceManager setObject:strValue forKey:PREF_CURSTATE];
}
+ (NSInteger) loadState {
    
    NSInteger nRet = 0;
    NSString *strValue = [CPreferenceManager objectForKey:PREF_CURSTATE];
    nRet = [strValue integerValue];
    return nRet;
}

+ (void) saveLanguage:(NSString*)value {
    
    [CPreferenceManager setObject:value forKey:PREF_LANGUAGE];
}
+ (NSString*) loadLanguage {

    NSString* strValue = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    return strValue;
}

+ (void) saveEmail:(NSString*)value {
    
    [CPreferenceManager setObject:value forKey:PREF_EMAIL];
}
+ (NSString*) loadEmail {
    
    NSString* strValue = [CPreferenceManager objectForKey:PREF_EMAIL];
    return strValue;
}

+ (void) savePassword:(NSString*)value {
    
    [CPreferenceManager setObject:value forKey:PREF_PASSWORD];
}
+ (NSString*) loadPassword {
    
    NSString* strValue = [CPreferenceManager objectForKey:PREF_PASSWORD];
    return strValue;
}

+ (void) saveUserModel:(CUserModel*)object {

    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [CPreferenceManager setObject:encodedObject forKey:PREF_USERMODEL];
}
+ (CUserModel*) loadUserModel {
    
    NSData *encodedObject = [CPreferenceManager objectForKey:PREF_USERMODEL];
    CUserModel *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

+ (void) saveExtendedMessageTime:(NSString*)value {
    
    [CPreferenceManager setObject:value forKey:PREF_EXTENDEDMESSAGETIME];
}
+ (NSString*) loadExtendedMessageTime {
    
    NSString* strValue = [CPreferenceManager objectForKey:PREF_EXTENDEDMESSAGETIME];
    return strValue;
}
@end
