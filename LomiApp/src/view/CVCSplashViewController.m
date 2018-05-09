//
//  CVCSplashViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCSplashViewController.h"

@interface CVCSplashViewController ()

@end

@implementation CVCSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (g_nPrevState == TASKSTATE_SETTING_UPDATE)
    {
        [CGlobal showProgressHUD:self];
        [CServiceManager onGetUserNutritionist:self type:1];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onSplashScreenDone) userInfo:nil repeats:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
 
    if (type == 7)
        return;
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 0)          // onLoginUser
    {
        if (result == nil)
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onUserProfile:self type:6];
        }
        else
        {
            [CPreferenceManager saveEmail:g_strEmail];
            [CPreferenceManager savePassword:g_strPassword];
     
            [CGlobal showProgressHUD:self];
            [CServiceManager onSetLastLogin:self type:10];
        }
    }
    else if (type == 10)    // onSetLastLogin
    {
        
        if (result == nil)
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onGetUserNutritionist:self type:1];
            
            [CServiceManager onEditUserLan:self type:7];
        }
        else
        {
            [CGlobal showAlertWithIgnoreSure:self type:0 message:NSLocalizedString(@"ALERT_MESSAGE_UPDATE", @"") title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
            
        }

    }    else if (type == 5)
    {
//        [CPreferenceManager saveEmail:g_strEmail];
//        [CPreferenceManager savePassword:g_strPassword];
//
//        [CGlobal showProgressHUD:self];
//        [CServiceManager onGetUserNutritionist:self type:1];
    }
    else if (type == 6)
    {
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        [CGlobal setState:TASKSTATE_LOGIN nextState:TASKSTATE_SETTING_UPDATE];
        [self performSegueWithIdentifier: @"SPLASH_TO_UPDATEACCOUNT"
                                  sender: self];
    }
    else if (type == 1)     //onGetUserNutritionist
    {
        
        //[CGlobal showProgressHUD:self];
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        NSString *savedOffset = [CPreferenceManager objectForKey:PREF_TIMEZONE];
        if (savedOffset == nil || [savedOffset isEqualToString:@""] || ![savedOffset isEqualToString:utcOffset])
        {
            [CServiceManager onSetUserTimezone:nil type:3];
        }
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];

        [CServiceManager onGetMobileSettings:nil type:2];
 
//        [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_TAB_MESSAGES];
        [self performSegueWithIdentifier: @"SPLASH_TO_TABHOME"
                                  sender: self];
        
    }
    else if (type == 2)     //onGetMobileSettings
    {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        NSString *savedOffset = [CPreferenceManager objectForKey:PREF_TIMEZONE];
        if (savedOffset == nil || [savedOffset isEqualToString:@""] || ![savedOffset isEqualToString:utcOffset])
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onSetUserTimezone:self type:3];
        }
        else
        {
//            [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_TAB_MESSAGES];
            [self performSegueWithIdentifier: @"SPLASH_TO_TABHOME"
                                      sender: self];
        }
    }
    else if (type == 3)
    {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];
        
//        [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_TAB_MESSAGES];
        [self performSegueWithIdentifier: @"SPLASH_TO_TABHOME"
                                  sender: self];
    }
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
 
    if (type == 1 && result != nil)
    {
        [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [self performSegueWithIdentifier: @"SPLASH_TO_CHOOSENUT"
                                  sender: self];
        return;
    }else if (type == 3)
    {
//        [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_TAB_MESSAGES];
        [self performSegueWithIdentifier: @"SPLASH_TO_TABHOME"
                                  sender: self];
        return;
    }

    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }

}

- (void)onClickAlertOK
{
    [CServiceManager onLogout:nil type:6];

    [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_SIGN];
    [self performSegueWithIdentifier: @"SPLASH_TO_SIGN"
                              sender: self];
}

- (void)onSplashScreenDone
{
    if ([CPreferenceManager isFirstRun])
    {
        [self performSegueWithIdentifier: @"SPLASH_TO_LANGUAGE"
                              sender: self];
    }
    else
    {
        [CServiceManager onGetStoreURL];

        
        if (g_pUserModel != nil)
            [g_pUserModel deleteAll];
        g_pUserModel = nil;
        g_pUserModel = [CPreferenceManager loadUserModel];

        g_strEmail = [CPreferenceManager loadEmail];
        g_strPassword = [CPreferenceManager loadPassword];
        
        NSInteger state = [CPreferenceManager loadState];
     
        if (state == TASKSTATE_REG_QUESTIONARIES)
        {
            [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_REG_QUESTIONARIES];
            [self performSegueWithIdentifier: @"SPLASH_TO_DIETREASONS"
                                      sender: self];
        }
        else if (state == TASKSTATE_REG_BODYMEASUREMENTS)
        {
            [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_REG_BODYMEASUREMENTS];
            [self performSegueWithIdentifier: @"SPLASH_TO_BODYMEASUREMENT"
                                      sender: self];
        }
        else if (state == TASKSTATE_REG_CHOOSENUTRITIONIST)
        {
            [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
            [self performSegueWithIdentifier: @"SPLASH_TO_CHOOSENUT"
                                      sender: self];
        }
        else
        {
            g_strEmail = [CPreferenceManager loadEmail];
            g_strPassword = [CPreferenceManager loadPassword];
            
            if (g_strEmail != nil)
            {
                [CGlobal showProgressHUD:self];

                [CServiceManager onLoginUser:self type:0];
            }
            else
            {
                [CGlobal setState:TASKSTATE_NONE nextState:TASKSTATE_SIGN];

                [self performSegueWithIdentifier: @"SPLASH_TO_SIGN"
                                          sender: self];
            }
        }

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
