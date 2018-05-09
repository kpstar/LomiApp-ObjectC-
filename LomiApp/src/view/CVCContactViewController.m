//
//  CVCContactViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 3/10/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CVCContactViewController.h"
#import "CConstant.h"
#import "CGlobal.h"
#import <Google/Analytics.h>
#import "CUtility.h"

@interface CVCContactViewController ()

@end

@implementation CVCContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDescript.text = NSLocalizedStringFromTable(@"iFp-p4-5kk.text", @"Main", @"");

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
    [tracker set:kGAIScreenName value:@"Contact Us"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    //  End
    
    self.m_tvBody.text = @"";
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
    }
    
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

- (IBAction)onClickSendMessage:(id)sender
{
    NSString* message = self.m_tvBody.text;
    NSString* meta = [CUtility metaString];
    
    if (![message isEqualToString:@""])
    {
        [[self view] endEditing:YES];
        
        [CGlobal showProgressHUD:self];
        [CServiceManager onPostContact:self type:1 body:message meta:meta];
    }
}

- (IBAction)onClickBack:(id)sender
{
    if (g_nPrevState == TASKSTATE_SETTING)
    {
        [CGlobal setState:TASKSTATE_SETTING_CONTACTUS nextState:TASKSTATE_SETTING];
        [self performSegueWithIdentifier: @"CONTACTUS_TO_SETTINGS"
                                      sender: self];
    }
    else
    {
        [CGlobal setState:TASKSTATE_SETTING_CONTACTUS nextState:TASKSTATE_SETTING_UPDATE];
        [self performSegueWithIdentifier: @"CONTACTUS_TO_UPDATEACCOUNT"
                                  sender: self];
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
