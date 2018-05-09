//
//  CVCApplicationSettingsViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCApplicationSettingsViewController.h"
#import "CUIViewSelectLanguage.h"
#import "CConstant.h"
#import "CGlobal.h"
#import <Google/Analytics.h>

@interface CVCApplicationSettingsViewController ()

@property (nonatomic,strong) CUIViewSelectLanguage* viewSelectLanguage;


@end

@implementation CVCApplicationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray* views1 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectLanguage" owner:self options:nil];
    self.viewSelectLanguage = views1[0];
    self.viewSelectLanguage.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Application Settings"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.viewSelectLanguage.frame = rect;
    self.viewSelectLanguage.frame = rect;
    
    self.m_swChat.on = g_pUserModel.pMobileSettingModel.bChatNotification;
    self.m_swPrivacy.on = g_pUserModel.pMobileSettingModel.bPrivacyMode;
    self.m_swSound.on = g_pUserModel.pMobileSettingModel.bSoundEffect;
    self.m_swVibration.on = g_pUserModel.pMobileSettingModel.bVibration;
    self.m_swChallenge.on = g_pUserModel.pMobileSettingModel.bChallengeNotification;
    self.m_swChat.on = g_pUserModel.pMobileSettingModel.bChatNotification;
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    if ([strLan isEqualToString:@"en"])
    {
        self.m_lblLanguage.text = NSLocalizedString(@"LAN_ENGLISH", @"");
        self.m_nLanguage = LAN_ENGLISH;
    }
    else {
        self.m_lblLanguage.text = NSLocalizedString(@"LAN_ARABIC", @"");
        self.m_nLanguage = LAN_ARABIC;
    }
    
}
- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
//    if ([result isKindOfClass:[NSString class]])
//    {
//        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
//    }

    [self performSegueWithIdentifier: @"APPLICATIONSETTING_TO_SETTING"
                              sender: self];
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

- (void)onLanguageSelected:(CUIViewSelectLanguage*)view type:(NSInteger)type
         didChooseLanguage:(NSInteger)value
{
    if (self.m_nLanguage == value)
        return;
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")
                                  message:NSLocalizedString(@"ALERT_MESSAGE_CHOOSELANGUAGE", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_YES", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        self.m_nLanguage = value;
        
        if (value == LAN_ENGLISH)
        {
            self.m_lblLanguage.text = NSLocalizedString(@"LAN_ENGLISH", @"");
            [CPreferenceManager saveLanguage:@"en"];
            [CGlobal setLanguage:@"en"];
        }
        else if (value == LAN_ARABIC)
        {
            self.m_lblLanguage.text = NSLocalizedString(@"LAN_ARABIC", @"");
            [CPreferenceManager saveLanguage:@"ar"];
            [CGlobal setLanguage:@"ar"];
        }

        exit(0);
        
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_NO", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
    }];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickLanguage:(id)sender
{
    [self.view addSubview:self.viewSelectLanguage];
    [self.view bringSubviewToFront:self.viewSelectLanguage];
    
    CGRect destFrame = self.viewSelectLanguage.frame;
    destFrame.origin.y = self.viewSelectLanguage.frame.size.height;
    self.viewSelectLanguage.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectLanguage.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickBack:(id)sender {
    
    g_pUserModel.pMobileSettingModel.bChatNotification = self.m_swChat.isOn;
    g_pUserModel.pMobileSettingModel.bPrivacyMode = self.m_swPrivacy.isOn;
    g_pUserModel.pMobileSettingModel.bSoundEffect = self.m_swSound.isOn;
    g_pUserModel.pMobileSettingModel.bVibration = self.m_swVibration.isOn;
    g_pUserModel.pMobileSettingModel.bChallengeNotification = self.m_swChallenge.isOn;
    g_pUserModel.pMobileSettingModel.bChatNotification = self.m_swChat.isOn;
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onEditMobileSettings:self type:0];
}
@end
