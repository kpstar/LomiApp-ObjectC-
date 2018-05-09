//
//  main.m
//  LomiApp
//
//  Created by TwinkleStar on 10/22/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        if ([CPreferenceManager isFirstRun] == false)
        {
            NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:strLan, nil] forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize];

//            if ([strLan isEqualToString:@"ar"])
//                [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//            else
//                [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
