//
//  CVCLoginController.m
//  Yayyle
//
//  Created by TwinkleStar on 10/18/16.
//  Copyright © 2016 venus. All rights reserved.
//

#import "CVCLoginController.h"
#import "AppDelegate.h"
#import "CServiceManager.h"
#import "MBProgressHUD.h"

@interface CVCLoginController ()

@end

@implementation CVCLoginController

@synthesize m_btnLogin, m_txtUsername, m_txtPassword, m_viewInput, m_viewContainer;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickView)];
    [m_viewContainer addGestureRecognizer:singleTap1];

    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (g_strEmail != nil)
    {
        m_txtUsername.text = g_strEmail;
        m_txtPassword.text = g_strPassword;
    }
    
    [CServiceManager onLogout:self type:99];
}
- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
 
    if (type == 7)
        return;
 
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 0)          //onLoginUser
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
    else if (type == 10)    //onSetLastLogin
    {

//        if (result == nil)
//        {
//            [CGlobal showProgressHUD:self];
//            [CServiceManager onGetUserNutritionist:self type:1];
//            
//            [CServiceManager onEditUserLan:self type:7];
//        }
//        else
//        {
//            [CGlobal showAlertWithIgnoreSure:self type:0 message:NSLocalizedString(@"ALERT_MESSAGE_UPDATE", @"") title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
//
//        }
        [CGlobal showProgressHUD:self];
        [CServiceManager onGetUserNutritionist:self type:1];
        
        [CServiceManager onEditUserLan:self type:7];
        
    }
    else if (type == 5)
    {
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
 
        [CGlobal showProgressHUD:self];
        [CServiceManager onGetUserNutritionist:self type:1];
    }
    else if (type == 6)
    {
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        [CGlobal setState:TASKSTATE_LOGIN nextState:TASKSTATE_SETTING_UPDATE];
        [self performSegueWithIdentifier: @"LOGIN_TO_UPDATEACCOUNT"
                                  sender: self];
    }
    else if (type == 1)
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
        
    
        [self performSegueWithIdentifier: @"LOGIN_TO_TABHOME"
                                  sender: self];

    }
    else if (type == 2)
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
            [self performSegueWithIdentifier: @"LOGIN_TO_TABHOME"
                                      sender: self];
        }
    }
    else if (type == 3)
    {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];
 
        [self performSegueWithIdentifier: @"LOGIN_TO_TABHOME"
                                  sender: self];
    }
}
// API Failed
- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
 
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
 

    if (type == 1 && result != nil)
    {
        [CGlobal setState:TASKSTATE_LOGIN nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [self performSegueWithIdentifier: @"LOGIN_TO_CHOOSENUT"
                                  sender: self];
        return;
    }
    else if (type == 3)
    {
        [self performSegueWithIdentifier: @"LOGIN_TO_TABHOME"
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

- (void) onClickView
{
    [[self view] endEditing:YES];
}


- (void)onClickAlertOK
{
    [CServiceManager onLogout:nil type:6];
}


- (IBAction)onClickBack:(id)sender
{
    [self performSegueWithIdentifier: @"LOGIN_TO_SIGN"
                              sender: self];
}

- (IBAction)onClickForgot:(id)sender {
    [self performSegueWithIdentifier: @"LOGIN_TO_FORGOT"
                              sender: self];
}

- (IBAction) onClickLogin:(id)sender forEvent:(UIEvent*)event
{
    [[self view] endEditing:YES];
    
    g_strEmail = m_txtUsername.text;
    g_strPassword = m_txtPassword.text;
    
    if ([g_strEmail isEqualToString:@""] || [g_strPassword isEqualToString:@""])
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_LOGIN_INPUTERROR", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    else
    {
        [CGlobal showProgressHUD:self];
        
        [CServiceManager onLoginUser:self type:0];
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
