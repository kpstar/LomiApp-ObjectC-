//
//  CPaymentSelectionViewController.m
//  LomiApp
//
//  Created by Aquari on 07/03/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import "CPaymentSelectionViewController.h"
#import "CPaymentTableCell.h"
#import "CGlobal.h"
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"


@interface CPaymentSelectionViewController()
@property(nonatomic, strong)PayPalConfiguration *payPalconfig;
@end

@implementation CPaymentSelectionViewController

NSString *clientToken = @"sandbox_3p8nbh69_48gt6tgyzmhnmbc9";

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.m_imgCC.layer.masksToBounds = YES;
    
    self.m_idxSelected = 0;
    
    self.m_imgPaypal = [UIImage imageNamed:@"icon_paypal"];
    self.m_imgApplePay = [UIImage imageNamed:@"icon_applepay"];
    self.m_imgBankPay = [UIImage imageNamed:@"icon_banktransfer"];
    self.m_imgCreditPay = [UIImage imageNamed:@"icon_creditcard"];
    
    self.m_tblPayment.delegate = self;
    self.m_tblPayment.dataSource = self;
    
    self.m_lblPrice.text = [NSString stringWithFormat:@"$%.2f",g_pUserModel.pSelectedPaymentModel.packagePrice];
    
    self.dict = [NSDictionary dictionaryWithObjects:@[@"PayPal", @"Stripe", @"ApplePay", @"GoogleWallet"] forKeys:@[@"1", @"2", @"3", @"4"]];
    
    self.payPalconfig = [[PayPalConfiguration alloc]init];
    self.payPalconfig.acceptCreditCards = YES;
    self.payPalconfig.merchantName = @"Lomi";
    self.payPalconfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];       
    self.payPalconfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    self.payPalconfig.languageOrLocale = [NSLocale preferredLanguages][0];
    self.payPalconfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.m_btnPayment.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)paymentWithPaypal
{
    PayPalItem *item1 = [PayPalItem itemWithName:g_pUserModel.pSelectedPaymentModel.packageTitle withQuantity:1 withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", g_pUserModel.pSelectedPaymentModel.packagePrice]] withCurrency:@"USD" withSku:nil];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc]initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc]initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal withShipping:shipping withTax:tax];
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping]decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc]init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = g_pUserModel.pSelectedPaymentModel.packageTitle;
    payment.items = items;
    payment.paymentDetails = paymentDetails;
    if (!payment.processable)
    {
        
    }
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalconfig delegate:self];
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"ERROR");
        } else if (result.cancelled) {
            NSLog(@"CANCELLED");
        } else {
            // Use the BTDropInResult properties to update your UI
            // result.paymentOptionType
            // result.paymentMethod
            // result.paymentIcon
            // result.paymentDescription
            
            NSString *identificationID = result.paymentMethod.nonce;
            NSString *amount = [NSString stringWithFormat:@"%.2f", g_pUserModel.pSelectedPaymentModel.packagePrice];
            NSDecimalNumber *decAmount = [NSDecimalNumber decimalNumberWithString:amount];
            [CGlobal showProgressHUD:self];
            [CServiceManager onAddNewPayment:self type:1 identificationID:identificationID amount:decAmount status:@"okey"];
        }
        
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:dropIn animated:YES completion:nil];
}

- (void)paymentWithApplePay
{
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    request.merchantIdentifier = @"merchant.com.lomi";//canada
 
    request.countryCode = @"CA";
    request.currencyCode = @"USD";
    
    request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    request.merchantCapabilities = PKMerchantCapability3DS;
    
    NSArray *items = @[[PKPaymentSummaryItem summaryItemWithLabel:@"Sub-Total" amount:[[NSDecimalNumber alloc]initWithString:[NSString stringWithFormat:@"%.2f", g_pUserModel.pSelectedPaymentModel.packagePrice]]]];
    request.paymentSummaryItems = items;
    request.requiredShippingAddressFields = PKAddressFieldPostalAddress;
    
    NSLog(@"request %@", request);
    PKPaymentAuthorizationViewController *viewController = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    viewController.delegate = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)onAPISuccess:(int)type result:(id)result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    /*
    if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
        NSLog
    }
    */
    
    if (type == 8) {
        if ([result isKindOfClass:[NSString class]])
        {
            [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
        }
        return;
    }
    if (type == 0)
    {
        if (self.m_idxSelected == 1) {
            [self paymentWithPaypal];
        } else if (self.m_idxSelected == 2) {
            [self showDropIn:clientToken];
        } else if (self.m_idxSelected == 3) {
            [self paymentWithApplePay];
        }
    }
    if (type == 1)
    {
        [self performSegueWithIdentifier:@"PAYMENT_TO_TABPROFILE" sender:self];
    }
}

- (void)onAPIFail:(int)type result:(id)result
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

- (IBAction)onClickNext:(id)sender {
    NSString *gateWay = [self.dict objectForKey:[NSString stringWithFormat:@"%ld", (long)self.m_idxSelected]];
    [CGlobal showProgressHUD:self];
    
    if ((long)self.m_idxSelected == 4) {
        [CServiceManager onPostWirePayment:self type:8];
        return;
    }
    
    //  API Call for payment
    [CServiceManager onStartPaymentProcess:self type:0 gateway:gateWay];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 0.0;
    }
    return 10.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPaymentTableCell *cell = (CPaymentTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cpaymentcell"];
    if ([indexPath section] == 0) {
        cell.m_imgPayment.image = self.m_imgPaypal;
        cell.m_lblPayment.text = @"Paypal";
    } else if ([indexPath section] == 1) {
        cell.m_imgPayment.image = self.m_imgApplePay;
        cell.m_lblPayment.text = @"ApplePay";
    } else if ([indexPath section] == 2) {
        cell.m_imgPayment.image = self.m_imgCreditPay;
        cell.m_lblPayment.text = @"CreditCard";
    } else {
        cell.m_imgPayment.image = self.m_imgBankPay;
        cell.m_lblPayment.text = @"Bank Transfer";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0 ) {
        self.m_idxSelected = 1;
    } else if ([indexPath section] == 1) {
        self.m_idxSelected = 3;
    } else if ([indexPath section] ==  2) {
//        self.m_idxSelected = 2;
        self.m_idxSelected = 2;
    } else {
        self.m_idxSelected = 4;
    }
    self.m_btnPayment.enabled = YES;
}

#pragma mark - PaypalSDKDelegate Methods
-(void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSDictionary *response = [completedPayment.confirmation objectForKey:@"response"];
    
    NSString *identifyID = [response objectForKey:@"id"];
    NSLog(@"payPalPaymentViewController %@", completedPayment);
    [self dismissViewControllerAnimated:YES completion:nil];
    [CGlobal showProgressHUD:self];
    [CServiceManager onAddNewPayment:self type:1 identificationID:identifyID amount:completedPayment.amount status:@"okey"];
}

#pragma mark - PKPaymentAuthorizationVeiwControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(nonnull void (^)(PKPaymentAuthorizationStatus))completion
{
    NSLog(@"paymentAuthorizationViewController %@", completion);
    
    NSString *identifyID = payment.shippingMethod.identifier;
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDecimalNumber *m_amount = [[NSDecimalNumber alloc] initWithFloat:g_pUserModel.pSelectedPaymentModel.packagePrice];
    [CGlobal showProgressHUD:self];
    [CServiceManager onAddNewPayment:self type:1 identificationID:identifyID amount:m_amount status:@"okey"];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"paymentAuthorizationViewControllerDidFinish called");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
