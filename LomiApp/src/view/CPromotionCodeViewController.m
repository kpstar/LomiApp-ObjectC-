//
//  CPromotionCodeViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/20/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CPromotionCodeViewController.h"
#import "CGlobal.h"
#import "CPromotionModel.h"

@interface CPromotionCodeViewController ()

@end

@implementation CPromotionCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_strGatewayName = @"HyperPay";
    self.m_tvDescription.text = NSLocalizedStringFromTable(@"fVF-LI-oal.text", @"Main", @"");
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"PROMOTION_TO_TABMESSAGE"])
    {
        [CGlobal setState:TASKSTATE_SETTING_UPDATE_PROMOTION nextState:TASKSTATE_TAB_MESSAGES];
        g_vcTabHome.selectedIndex = 3;
    }
    //[CGlobal setState:TASKSTATE_SETTING_UPDATE_PROMOTION nextState:TASKSTATE_SETTING_UPDATE];
}


- (void)setData:(NSInteger)index
{
    self.m_nIndex = index;
    

    self.m_tvDescription.text = NSLocalizedStringFromTable(@"fVF-LI-oal.text", @"Main", @"");
}

- (IBAction)onClickUpdate:(id)sender
{
    [[self view] endEditing:YES];
    
    if (self.m_tfCode.text.length < 1)
    {
        self.m_tfCode.textColor = [UIColor redColor];
        [self.m_tfCode becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_PROMOTION_INPUTERROR_INVALIDCODE", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onPostCouponCode:self type:0 code:self.m_tfCode.text];
}

- (IBAction)texfieldEditChanged:(id)sender
{
    UITextField*    textField = sender;
    textField.textColor = [UIColor blackColor];
}


- (void)onClickAlertOK
{
    if (g_nPrevState == TASKSTATE_LOGIN)
    {
        [self performSegueWithIdentifier: @"PROMOTION_TO_UPDATEACCOUNT"
                                  sender: self];
    }
    else
    {
        [self performSegueWithIdentifier: @"PROMOTION_TO_TABMESSAGE"
                                  sender: self];

    }
}


@end
