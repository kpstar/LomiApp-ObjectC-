//
//  AppDelegate.m
//  LomiApp
//
//  Created by TwinkleStar on 10/22/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityLoggerProtocol.h"
#import "AFNetworkActivityConsoleLogger.h"
#import "TWMessageBarManager.h"
#import <Google/Analytics.h>
#import "Flurry.h"
#import <PayPalMobile.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <TwitterKit/TWTRKit.h>

@import Stripe;

// define macro
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface TWAppDelegateDemoStyleSheet : NSObject <TWMessageBarStyleSheet>

+ (TWAppDelegateDemoStyleSheet *)styleSheet;

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    AFNetworkActivityConsoleLogger *consoleLogger = [AFNetworkActivityConsoleLogger new];
    consoleLogger.level = AFLoggerLevelDebug;
    [[AFNetworkActivityLogger sharedLogger] addLogger:consoleLogger];
    [[AFNetworkActivityLogger sharedLogger] startLogging];

    //  Initialize Global Variables
    [CGlobal initAppConstantVariables];
    

//  Set Settings of Local Notification
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    [TWMessageBarManager sharedInstance].styleSheet = [TWAppDelegateDemoStyleSheet styleSheet];

    //pk_live_hA8ylv7hCttgVmBol9gsGOxV
    //pk_test_f2vMjeoXaA6r7bXgsciQqYs7
//  Init Strip.com
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_live_hA8ylv7hCttgVmBol9gsGOxV"];//@"pk_live_hA8ylv7hCttgVmBol9gsGOxV"];


//  Initialize Google Analytics
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.logger.logLevel = kGAILogLevelVerbose;

//  Initialize Flurry SDK
    [Flurry startSession:@"DQJHZHDPWBBQCNBTDJV2"];


//  Initialize APN for Push Notification
    [self registerForRemoteNotifications];
    
//  Initialize PayPal 
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction: @"AUp_bB-nDCnrVtKGDt3GmgSSEVDQyeODOSNq2vaOFc3rrY1LtOzHLSqHsDUle_ObhLh9VdDfc73bX0Oe", PayPalEnvironmentSandbox:@"AfOzdWdM1QH247NSXLRG8AVDFFN9EF8bp5Wv4bgPCM9ELyZFlbMijScpxsoNnDlUHIZvr26NuZ4CTQxW"}];
    
//  Initialize Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

//  Initialize TWitter SDK
    [[Twitter sharedInstance] startWithConsumerKey:@"0QE9eY8c9yI4TpoLBZyGdl3xl" consumerSecret:@"dbFi29EC08K0Se37RBnE2IX8ePBUda6fRIy30a2S31wRnDA1NR"];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (g_vcTabHome != nil)
        [g_vcTabHome refreshTab];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)registerForRemoteNotifications
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){

        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

        center.delegate = self;

        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){

            if(!error){

                [[UIApplication sharedApplication] registerForRemoteNotifications];

            }
            
        }];

    }
    
    else {

        // Code for old versions

        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |

                                                        UIUserNotificationTypeBadge |
          
                                                        UIUserNotificationTypeSound);

        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes

                                                                                 categories:nil];

        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

        [[UIApplication sharedApplication] registerForRemoteNotifications];

    }

}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{

    NSString *tokenString = [deviceToken description];

    tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Push Notification tokenstring is %@",tokenString);

    g_strDeviceToken = tokenString;

    [[NSUserDefaults standardUserDefaults]setObject:tokenString forKey:@"DeviceTokenFinal"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

//Called when a notification is delivered to a foreground app.

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);

    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);

//    [self handleRemoteNotification:[UIApplication sharedApplication] userInfo:notification.request.content.userInfo];
    
    if (g_vcTabHome != nil)
        [g_vcTabHome refreshTab];

}

//Called to let your app know which action was selected by the user for a given notification.

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{

    NSLog(@"User Info : %@",response.notification.request.content.userInfo);

    completionHandler();

    [self handleRemoteNotification:[UIApplication sharedApplication] userInfo:response.notification.request.content.userInfo];

}

-(void) handleRemoteNotification:(UIApplication *) application   userInfo:(NSDictionary *) remoteNotif {

    NSLog(@"handleRemoteNotification");

    NSLog(@"Handle Remote Notification Dictionary: %@", remoteNotif);
    
    NSDictionary *aps = [remoteNotif objectForKey:@"aps"];
    NSString *metaData = [aps objectForKey:@"metaData"];
    
    NSData *data = [metaData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
    if (jsonResponse == nil)
        return;
    
    NSString* type = [jsonResponse objectForKey:@"type"];
    g_strPushType = type;
    
    int nShowTabIndex = -1;
    
    if ([type isEqualToString:NOTIFICATION_MESSAGENEW])
    {
        nShowTabIndex = 3;
    }
    else if ([type isEqualToString:NOTIFICATION_PHOTOAPPROVED] || [type isEqualToString:NOTIFICATION_PHOTOCOMMENT])
    {
        nShowTabIndex = 0;
        
    }
    else if ([type isEqualToString:NOTIFICATION_SHCEDULECREATED] || [type isEqualToString:NOTIFICATION_SCHEDULEEDITED])
    {
        nShowTabIndex = 1;
        
    }
    else if ([type isEqualToString:NOTIFICATION_EXPIRATIONNOTICE])
    {
        nShowTabIndex = 4;
    }
    else if ([type isEqualToString:NOTIFICATION_MEASUREMENTSWEEKLYNOTICE])
    {
        nShowTabIndex = 2;
    }
    else if ([type isEqualToString:NOTIFICATION_QUESTIONNAIRE])
    {
        nShowTabIndex = 4;
    }

    if (g_vcTabHome != nil)
    {
        if (nShowTabIndex != -1)
            g_vcTabHome.selectedIndex = nShowTabIndex;
        [g_vcTabHome refreshTab];
    }
    
    

    // Handle Click of the Push Notification From Here…
    // You can write a code to redirect user to specific screen of the app here….

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        // Application was in the background when notification was delivered.
    } else {
 
//
//        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"Lomi Notification"
//                                                       description:notification.alertBody
//                                                              type:TWMessageBarMessageTypeSuccess
//                                                          duration:5.0];
 
        if (notification.hasAction == YES)
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:NSLocalizedString(@"STR_NOTIFICATION", @"")
                                                           description:notification.alertBody
                                                                  type:TWMessageBarMessageTypeSuccess
                                                              duration:5.0
                                                        statusBarStyle:UIStatusBarStyleDefault
                                                              callback:^{
                                                                  [g_vcTabHome onClickNotification];
                                                              }];

        }
        else
        {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:NSLocalizedString(@"STR_NOTIFICATION", @"")
                                                           description:notification.alertBody
                                                                  type:TWMessageBarMessageTypeSuccess
                                                              duration:5.0
                                                        statusBarStyle:UIStatusBarStyleDefault
                                                              callback:nil];
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL fb_handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    BOOL tw_handled = [[Twitter sharedInstance] application:app openURL:url options:options];
    return fb_handled || tw_handled;
}

@end



@implementation TWAppDelegateDemoStyleSheet

#pragma mark - Alloc/Init

+ (TWAppDelegateDemoStyleSheet *)styleSheet
{
    return [[TWAppDelegateDemoStyleSheet alloc] init];
}


#pragma mark - TWMessageBarStyleSheet

- (UIColor *)backgroundColorForMessageType:(TWMessageBarMessageType)type
{
    UIColor *backgroundColor = nil;
    switch (type)
    {
        case TWMessageBarMessageTypeError:
            backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75];
            break;
        case TWMessageBarMessageTypeSuccess:
            backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
            break;
        case TWMessageBarMessageTypeInfo:
            backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.75];
            break;
        default:
            break;
    }
    return backgroundColor;
}

- (UIColor *)strokeColorForMessageType:(TWMessageBarMessageType)type
{
    UIColor *strokeColor = nil;
    switch (type)
    {
        case TWMessageBarMessageTypeError:
            strokeColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            break;
        case TWMessageBarMessageTypeSuccess:
            strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            break;
        case TWMessageBarMessageTypeInfo:
            strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
            break;
        default:
            break;
    }
    return strokeColor;
}

- (UIImage *)iconImageForMessageType:(TWMessageBarMessageType)type
{
    UIImage *iconImage = nil;
    switch (type)
    {
        case TWMessageBarMessageTypeError:
            iconImage = [UIImage imageNamed:@""];
            break;
        case TWMessageBarMessageTypeSuccess:
            iconImage = [UIImage imageNamed:@"80x80"];
            break;
        case TWMessageBarMessageTypeInfo:
            iconImage = [UIImage imageNamed:@""];
            break;
        default:
            break;
    }
    return iconImage;
}

- (UIColor *)titleColorForMessageType:(TWMessageBarMessageType)type
{
    return [UIColor whiteColor];
}

- (UIColor *)descriptionColorForMessageType:(TWMessageBarMessageType)type
{
    return [UIColor whiteColor];
}
@end
