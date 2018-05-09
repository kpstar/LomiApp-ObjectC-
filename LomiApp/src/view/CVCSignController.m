//
//  CVCSignController.m
//  Yayyle
//
//  Created by TwinkleStar on 10/18/16.
//  Copyright © 2016 venus. All rights reserved.
//

#import "CVCSignController.h"
#import "CGlobal.h"

@interface CVCSignController ()


@end

// Type
// 0-email check
// 11-social signup
// 12-social signin


@implementation CVCSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"mOs-2g-XRd.text", @"Main", @"");
    self.m_lblVersion.text = [NSString stringWithFormat:@"Ver %.1f", APP_VERSION];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    CGFloat width = self.view.frame.size.width;
    CGFloat subViewWidth = width / 2;
    subViewWidth -= self.m_btnSignup.frame.size.width;
    width -= subViewWidth;
    
    CGRect frame;
    frame = self.m_viewFBLogin.frame;
    frame.origin = self.m_btnSignup.frame.origin;
    frame.origin.x = subViewWidth / 2;
    frame.size.width = width;
    loginButton.frame = frame;
//    loginButton.readPermissions = @[@"email", @"public_profile", @"user_birthday", @"user_location", @"user_hometown"];
    //loginButton.publishPermissions = @[@"publish_actions"];
    loginButton.delegate = self;
    loginButton.loginBehavior = FBSDKLoginBehaviorNative;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    if ([FBSDKAccessToken currentAccessToken]) {
        //Facebook User is logged in

        NSLog(@"facebook signed already");
    }
    [self.m_viewFBLogin addSubview:loginButton];

    //Twitter
    TWTRLogInButton *loginTwButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (session) {
            NSLog(@"Twitter signed in as %@", [session userName]);

            g_twUserDic = [[NSMutableDictionary alloc] initWithCapacity:10];
            [g_twUserDic setObject:[session authToken] forKey:@"authToken"];
            [g_twUserDic setObject:[session authTokenSecret] forKey:@"authTokenSecret"];
            [g_twUserDic setObject:[session userName] forKey:@"userName"];
            [g_twUserDic setObject:[session userID] forKey:@"userID"];
            
            TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
            [client requestEmailForCurrentUser:^(NSString *email, NSError *error) {
                if (email) {
                    NSLog(@"Twitter signed in as %@", email);
                    [g_twUserDic setObject:email forKey:@"email"];
                    g_socialTypeFB = false;
                    g_strEmail = email;
                    g_strPassword = @"adminadmin";
                    [CGlobal showProgressHUD:self];
                    [CServiceManager onEmailCheck:self];
                    
//                    [self fetchTwUserInfo];
                } else {
                    NSLog(@"error: %@", [error localizedDescription]);
                }
                
            }];
            
            
        } else {
            NSLog(@"Twitter error: %@", [error localizedDescription]);
            return ;
        }
    }];
    
    loginTwButton.frame = frame;
    [self.m_viewTWLogin addSubview:loginTwButton];
    

//    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
//        if (session) {
//              NSLog(@"Twitter1 signed in as %@", [session userName]);
//        } else {
//            NSLog(@"Twitter1 error: %@", [error localizedDescription]);
//        }
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    [CGlobal hideProgressHUD:self];
    
    if (type == 0) {
        if (result != nil) {
//            [CGlobal showProgressHUD:self];
            [self socialSignUp];
        }
    }else if (type == 30) {
        if (result != nil) {
            if (g_socialTypeFB == true) {
                if ([result isEqualToString:@"selected email address has a facebook login"]) {
                    [CGlobal showProgressHUD:self];
                    [self socialSignIn];
                } else {
                    NSInteger fb_uid = [[g_fbResult objectForKey:@"id"] integerValue];
                    NSString * fb_uidStr = [NSString stringWithFormat:@"%ld", (long)fb_uid];
                    
                    [CServiceManager onSocialSync:self type:30 fbid:fb_uidStr userid:[NSString stringWithFormat:@"%ld", (long)g_pUserModel.nUserID]];
                }
            } else {
                if ([result isEqualToString:@"selected email address has a twitter login"]) {
                    [CGlobal showProgressHUD:self];
                    [self socialSignIn];
                    
                } else {
                    NSString * tw_uidStr = [g_twUserDic objectForKey:@"userID"];
                    
                    [CServiceManager onSocialSync:self type:30 fbid:tw_uidStr userid:[NSString stringWithFormat:@"%ld", (long)g_pUserModel.nUserID]];
                }
            }
            
        }
 
    }else if (type == 1) {
        [CServiceManager onSetUserTimezone:self type:2];
        return;
    }else if (type == 2) {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];
    }else if (type == 3) {
        return;
    }else if (type == 4) {
        if (result == nil)
        {
            [[self view] endEditing:YES];
            [CGlobal hideProgressHUD:self];
            [self performSegueWithIdentifier: @"SIGNIN_TO_DIETREASONS"
                                      sender: self];
            return;
        }
        else
        {
            [CGlobal showAlertWithIgnoreSure:self type:0 message:NSLocalizedString(@"ALERT_MESSAGE_UPDATE", @"") title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
        }
    }else if (type == 11) { //Social Signup
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];

        [CServiceManager onEditUserLan:self type:3];
        [CServiceManager onSendOSVersion:self type:4];

        if (g_pUserModel.imgAvatar != nil)
        {
            [CServiceManager onSetUserProfilePhoto:self type:1];
            return;
        }
        else
        {
            [CServiceManager onSetUserTimezone:self type:2];
            return;
        }
    }else if (type == 12){  //Social Signin
        if (result == nil)
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onUserProfile:self type:106];
        }
        else
        {
            [CPreferenceManager saveEmail:g_strEmail];
            [CPreferenceManager savePassword:g_strPassword];

            [CGlobal showProgressHUD:self];
            [CServiceManager onSetLastLogin:self type:110];
        }
    }else if (type == 107) {
        return;
    }else if (type == 110)    // onSetLastLogin
    {
        if (result == nil)
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onGetUserNutritionist:self type:101];
            
            [CServiceManager onEditUserLan:self type:107];
        }
        else
        {
            [CGlobal showAlertWithIgnoreSure:self type:0 message:NSLocalizedString(@"ALERT_MESSAGE_UPDATE", @"") title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
            
        }
        
    }else if (type == 105) {
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        
        [CGlobal showProgressHUD:self];
        [CServiceManager onGetUserNutritionist:self type:101];
    }else if (type == 106) {
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        [CGlobal setState:TASKSTATE_LOGIN nextState:TASKSTATE_SETTING_UPDATE];
        [self performSegueWithIdentifier: @"SIGNIN_TO_UPDATEACCOUNT"
                                  sender: self];
    }else if (type == 101) {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        NSString *savedOffset = [CPreferenceManager objectForKey:PREF_TIMEZONE];
        if (savedOffset == nil || [savedOffset isEqualToString:@""] || ![savedOffset isEqualToString:utcOffset])
        {
            [CServiceManager onSetUserTimezone:nil type:103];
        }
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];
        
        [CServiceManager onGetMobileSettings:nil type:102];

        [self performSegueWithIdentifier: @"SIGNIN_TO_TABHOME"
                                  sender: self];
        
    } else if (type == 102) {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        NSString *savedOffset = [CPreferenceManager objectForKey:PREF_TIMEZONE];
        if (savedOffset == nil || [savedOffset isEqualToString:@""] || ![savedOffset isEqualToString:utcOffset])
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onSetUserTimezone:self type:103];
        }
        else
        {
            [self performSegueWithIdentifier: @"SIGNIN_TO_TABHOME"
                                      sender: self];
        }
    }
    else if (type == 103)
    {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];
        
        [self performSegueWithIdentifier: @"SIGNIN_TO_TABHOME"
                                  sender: self];
    }

    
    
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    [CGlobal hideProgressHUD:self];
    if (type == 0) {
        if (result != nil) {
            [CGlobal showProgressHUD:self];
            [CServiceManager onSocialExistCheck:self];
            return;
        }
    }else if (type == 30) {
        
        
    }else if (type == 2) {
        [self performSegueWithIdentifier: @"SIGNIN_TO_CHOOSENUT"
                                  sender: self];
        
        return;
    }else if (type == 101 && result != nil)
    {
        [CGlobal setState:TASKSTATE_LOGIN nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [self performSegueWithIdentifier: @"SIGNIN_TO_CHOOSENUT"
                                  sender: self];
        return;
    }
    else if (type == 103)
    {
        [self performSegueWithIdentifier: @"SIGNIN_TO_TABHOME"
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

- (void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@", [[FBSDKAccessToken currentAccessToken] tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"name, gender, first_name, last_name, picture.type(large), email, birthday, location, address"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                NSLog(@"fetchUserInfo result is : %@", result);
                g_socialTypeFB = true;
                g_fbResult = result;

                g_strEmail = [result objectForKey:@"email"];
                g_strPassword = @"adminadmin";
                [CGlobal showProgressHUD:self];
                [CServiceManager onEmailCheck:self];

            }
            else
            {
                NSLog(@"fetchUserInfo Error %@", error);
            }
        }];
    }
}

- (void)fetchTwUserInfo {
    NSString* userId = [g_twUserDic objectForKey:@"userID"];
    if (userId != nil) {
        TWTRAPIClient* client = [[TWTRAPIClient alloc] initWithUserID:userId];
        NSString* url = @"https://api.twitter.com/1.1/users/show.json";
        NSDictionary* params = @{@"screen_name":@"twitter"};
        NSError* clientError;
        NSURLRequest *request = [client URLRequestWithMethod:@"GET" URLString:url parameters:params error:&clientError];
        if (request) {
            [client sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                if (data) {
                    // handle the response data e.g.
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                    NSLog(@"%@", json);
                }
                else {
                    NSLog(@"Error: %@", connectionError);
                }
            }];
        }else {
            NSLog(@"Error: %@", clientError);
        }
        
        
        
        
    }
}


- (void)socialSignUp {
    if (g_socialTypeFB == true) {
        //Social Facebook SignUp
        NSInteger fb_uid = [[g_fbResult objectForKey:@"id"] integerValue];
        NSString * fb_uidStr = [NSString stringWithFormat:@"%ld", (long)fb_uid];
        
        [CGlobal setState:TASKSTATE_SIGNUP nextState:TASKSTATE_SIGNUP];
        
        if (g_pUserModel != nil)
            [g_pUserModel deleteAll];
        g_pUserModel = nil;
        g_pUserModel = [[CUserModel alloc] init];
        
        g_pUserModel.strFirstName = [g_fbResult objectForKey:@"first_name"];
        g_pUserModel.strLastName = [g_fbResult objectForKey:@"last_name"];
        g_pUserModel.strEmail = [g_fbResult objectForKey:@"email"];
        g_pUserModel.strPassword = @"adminadmin";
        
        g_pUserModel.strCountryCode = g_arrCountryCode[0];
        g_pUserModel.strBirthday = @"1990-1-1";
        
        NSString *genderStr = [g_fbResult objectForKey:@"gender"];
        if ([genderStr isEqualToString:@"male"]) {
            g_pUserModel.strGenderMale = @"411";
        }else {
            g_pUserModel.strGenderMale = @"412";
        }
        
        NSString * imgUrl = [[[g_fbResult objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
        
        NSURL *url = [NSURL URLWithString:imgUrl];
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage * img = [[UIImage alloc] initWithData:data];
        g_pUserModel.imgAvatar = img;
        
//        g_pUserModel.strTelephone = @"442";
        
        NSArray* arrString = [g_pUserModel.strEmail componentsSeparatedByString:@"@"];
        int rndValue = 1000 + arc4random() % 9999;
        g_pUserModel.strProfileAddress = [NSString stringWithFormat:@"%@%d", arrString[0], rndValue];
        
        [CGlobal showProgressHUD:self];
        
        [CServiceManager onSocialSignup:self type:11 fb_uid:fb_uidStr];
    } else {

        //Social Twitter SignUp
        NSString * tw_uidStr = [g_twUserDic objectForKey:@"userID"];
        
        [CGlobal setState:TASKSTATE_SIGNUP nextState:TASKSTATE_SIGNUP];
        
        if (g_pUserModel != nil)
            [g_pUserModel deleteAll];
        g_pUserModel = nil;
        g_pUserModel = [[CUserModel alloc] init];
        
        g_pUserModel.strFirstName = [g_twUserDic objectForKey:@"userName"];
        g_pUserModel.strLastName = @"";
        g_pUserModel.strEmail = [g_twUserDic objectForKey:@"email"];
        g_pUserModel.strPassword = @"adminadmin";
        
        g_pUserModel.strCountryCode = g_arrCountryCode[0];
        g_pUserModel.strBirthday = @"1990-1-1";
        
//        NSString *genderStr = [g_fbResult objectForKey:@"gender"];
//        if ([genderStr isEqualToString:@"male"]) {
            g_pUserModel.strGenderMale = @"411";
//        }else {
//            g_pUserModel.strGenderMale = @"412";
//        }

//        NSString * imgUrl = [[[g_fbResult objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
//
//        NSURL *url = [NSURL URLWithString:imgUrl];
//        NSData * data = [NSData dataWithContentsOfURL:url];
//        UIImage * img = [[UIImage alloc] initWithData:data];
//        g_pUserModel.imgAvatar = img;

//        g_pUserModel.strTelephone = @"442";
        
        NSArray* arrString = [g_pUserModel.strEmail componentsSeparatedByString:@"@"];
        int rndValue = 1000 + arc4random() % 9999;
        g_pUserModel.strProfileAddress = [NSString stringWithFormat:@"%@%d", arrString[0], rndValue];
        
        [CGlobal showProgressHUD:self];
        
        [CServiceManager onSocialSignup:self type:11 fb_uid:tw_uidStr];
    }
}

- (void)socialSignIn {
    
    if (g_socialTypeFB == true) {
        //Social Facebook SignIn
        NSInteger fb_uid = [[g_fbResult objectForKey:@"id"] integerValue];
        NSString * fb_uidStr = [NSString stringWithFormat:@"%ld", (long)fb_uid];
        [CServiceManager onSocialSignin:self type:12 id:fb_uidStr];
    }else {
        //Social Twitter SignIn
        NSString * tw_uidStr = [g_twUserDic objectForKey:@"userID"];
//        NSInteger fb_uid = [[g_fbResult objectForKey:@"id"] integerValue];
//        NSString * fb_uidStr = [NSString stringWithFormat:@"%ld", (long)fb_uid];
        [CServiceManager onSocialSignin:self type:12 id:tw_uidStr];
    }
}



- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    NSLog(@"FBLoginResult %@", result);
    if (error)
    {
        // process error
    }
    else if (result.isCancelled)
    {
        // Handle cancellations
    }
    else
    {
        if ([result.grantedPermissions containsObject:@"email"])
        {
            NSLog(@"result is %@", result);
            [self fetchUserInfo];
        }
    }
}




- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"SIGN_TO_LOGIN"])
    {
        [CGlobal setState:TASKSTATE_SIGN nextState:TASKSTATE_LOGIN];
        [CPreferenceManager saveState:TASKSTATE_LOGIN];
    }
    else if ([[segue identifier] isEqualToString:@"SIGN_TO_REGIST1"])
    {
        [CGlobal setState:TASKSTATE_SIGN nextState:TASKSTATE_SIGNUP];
        [CPreferenceManager saveState:TASKSTATE_SIGNUP];
    }
}


@end
