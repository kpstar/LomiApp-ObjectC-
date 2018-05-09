//
//  CVCForgotPasswordViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 11/24/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "CServiceManager.h"
#import "MBProgressHUD.h"

@interface CVCForgotPasswordViewController ()

@end

@implementation CVCForgotPasswordViewController

@synthesize m_txtEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"DUa-23-LbL.text", @"Main", @"");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)onClickBack:(id)sender {
    
    [self performSegueWithIdentifier: @"FORGOT_TO_LOGIN"
                              sender: self];
}

- (IBAction)onClickReset:(id)sender {
    
    [[self view] endEditing:YES];
    
    
    g_strEmail = m_txtEmail.text;
    
    if ([g_strEmail isEqualToString:@""])
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_FORGOTPASS_INPUTERRROR", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    else
    {
        [CGlobal showProgressHUD:self];
        
        [CServiceManager onForgotPass:self];
    }
    
    
}

- (IBAction)onClickView:(id)sender {
    
    [[self view] endEditing:YES];
}
@end
