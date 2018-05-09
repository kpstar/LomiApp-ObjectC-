//
//  CVCProfileViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/9/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CSetRateNutritionistViewController.h"
#import "CVCProfileEditViewController.h"

#import "CGlobal.h"
#import <Google/Analytics.h>

@interface CVCProfileViewController ()

@end

@implementation CVCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadData)
                                                 name:@"Notification_Profile"
                                               object:nil];
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
    [tracker set:kGAIScreenName value:@"Profile"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
    
    if (g_nCurState == TASKSTATE_PROFILE_EDIT)
    {
        return;
    }
    
    if (self.bIsLoaded)
        return;
    self.bIsLoaded = YES;

    [self reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.bIsLoaded = NO;
}

- (void)reloadData {
 
    //[CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onUserProfile:self type:1];
}

- (void)refreshProfile {
    //[CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onUserProfile:self type:1];
}

- (void)refreshView {
    
    [self.m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:g_pUserModel.strThumbnail]
                       placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    self.m_lblTitle.text = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
    //self.m_lblCountry.text = g_arrCountryFullName[[CGlobal countryIndexFromCode:g_pUserModel.strCountryCode]];
    if (g_arrCountryFullName == nil) {
        self.m_lblCountry.text = @"Country";
    } else {
        self.m_lblCountry.text = g_arrCountryFullName[[CGlobal countryIndexFromCode:g_pUserModel.strCountryCode]];
    }
    self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fWeight ];
    self.m_lblHeight.text = [NSString stringWithFormat:@"%.1f", g_pUserModel.pBodyMeasurementModel.fHeight ];
    if ([g_pUserModel.pMobileSettingModel.strHeightUnit isEqualToString:@"in"])
    {
        self.m_lblHeight.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fHeight];
    }

 
    [self.m_ivNutAvatar sd_setImageWithURL:[NSURL URLWithString:g_pUserModel.pNutModel.strThumbnail]
                          placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    self.m_lblNutName.text = g_pUserModel.pNutModel.strTitle;
    self.m_lblAge.text = [NSString stringWithFormat:@"%ld", (long)[CUtility age:g_pUserModel.strBirthday]];
    
    self.m_lblWeightUnit.text = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"STR_WEIGHT", @""), g_pUserModel.pMobileSettingModel.strWeightUnit];
    self.m_lblHeightUnit.text = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"STR_HEIGHT", @""), g_pUserModel.pMobileSettingModel.strHeightUnit];
    if ([g_pUserModel.pMobileSettingModel.strHeightUnit isEqualToString:@"in"])
    {
        self.m_lblHeightUnit.text = NSLocalizedString(@"STR_HEIGHT", @"");
    }
    
    if (g_pUserModel.pPaymentModel == nil || g_pUserModel.pPaymentModel.packagePrice == 0)
        self.m_lblPremium.hidden = YES;
    else
        self.m_lblPremium.hidden = NO;
    
    
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (type == 0)  //Log out
    {
        if (g_pUserModel != nil)
            [g_pUserModel deleteAll];
        g_pUserModel = nil;
        
        //[CPreferenceManager saveEmail:nil];
        //[CPreferenceManager savePassword:nil];
        [CPreferenceManager setObject:nil forKey:PREF_TIMEZONE];
        [CGlobal setState:TASKSTATE_TAB_PROFILE nextState:TASKSTATE_SIGN];
        [CPreferenceManager saveState:TASKSTATE_SIGN];
        
        [self performSegueWithIdentifier: @"PROFILE_TO_SIGN" sender: self];
    }
    if (type == 1) //user profile
    {
//        if (g_pUserModel.pBodyMeasurementModel.strCreationDate == nil)
//        {
            //[CGlobal showProgressHUD:g_vcTabHome];
            [CServiceManager onGetLastMeasurement:self type:2];
//        }
//        else
            [self refreshView];
    }
    if (type == 2) //Last Measurement
    {
//        if (g_pUserModel.pPaymentModel == nil)
//        {
            //[CGlobal showProgressHUD:g_vcTabHome];
            [CServiceManager onGetUserPlan:self type:3];
//        }
//        else
            [self refreshView];
    }
    if (type == 3) //Payment Plan
    {
        g_pUserModel.pPaymentModel = result;
        [self refreshView];
    }
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"PROFILE_TO_SETTING"])
    {
        [CGlobal setState:TASKSTATE_TAB_PROFILE nextState:TASKSTATE_SETTING];
    }
    else if ([[segue identifier] isEqualToString:@"PROFILE_TO_NUT"])
    {
        [CGlobal setState:TASKSTATE_TAB_PROFILE nextState:TASKSTATE_PROFILE_NUT];
        CSetRateNutritionistViewController* destController = [segue destinationViewController];
        if (g_pUserModel.pNutModel != nil)
            [destController initModel:g_pUserModel.pNutModel];
    }
    else if ([[segue identifier] isEqualToString:@"PROFILE_TO_DIETREASONS"])
    {
        [CGlobal setState:TASKSTATE_TAB_PROFILE nextState:TASKSTATE_PROFILE_QUESTIONNAIRE];
    }
    else if ([[segue identifier] isEqualToString:@"PROFILE_TO_BODYMEASUREMENT"])
    {
        [CGlobal setState:TASKSTATE_TAB_PROFILE nextState:TASKSTATE_PROFILE_BODYMEASUREMENT];
    }
    else if ([[segue identifier] isEqualToString:@"PROFILE_TO_EDITPROFILE"])
    {
        [CGlobal setState:TASKSTATE_TAB_PROFILE nextState:TASKSTATE_PROFILE_EDIT];
        self.m_vcEdit = [segue destinationViewController];;
    }
}

- (IBAction)onClickLogout:(id)sender
{
    [CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onLogout:self type:0];
}

- (void)showEdit
{
    
    CVCProfileViewController *tabBarController = self;
    UIViewController *destinationController = self.m_vcEdit;
    
    // Add view to placeholder view
    [tabBarController.m_viewContainer addSubview: destinationController.view];
    
    // Set autoresizing
    [tabBarController.m_viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *childview = destinationController.view;
    [childview setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // fill horizontal
    [tabBarController.m_viewContainer addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[childview]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
    // fill vertical
    [tabBarController.m_viewContainer addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[childview]-0-|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
    [tabBarController.m_viewContainer layoutIfNeeded];
    
    [tabBarController addChildViewController:destinationController];
    // notify did move
    [destinationController didMoveToParentViewController: tabBarController];
}

@end
