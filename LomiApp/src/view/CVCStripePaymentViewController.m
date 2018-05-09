//
//  CVCStripePaymentViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/25/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCStripePaymentViewController.h"
#import "CGlobal.h"
@import Stripe;

@interface CVCStripePaymentViewController ()
@property (nonatomic, strong) CUIViewSelectExpYear* viewSelectExpYear;
@property (nonatomic, strong) CUIViewSelectExpMonth* viewSelectExpMonth;
@end

@implementation CVCStripePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray* views1 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectExpYear" owner:self options:nil];
    self.viewSelectExpYear = views1[0];
    self.viewSelectExpYear.delegate = self;
    
    NSArray* views2 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectExpMonth" owner:self options:nil];
    self.viewSelectExpMonth = views2[0];
    self.viewSelectExpMonth.delegate = self;
    
    self.m_tvWiretransfer.text = NSLocalizedStringFromTable(@"zYS-Sd-HY6.text", @"Main", @"");
    self.m_pSelectedModel = g_pUserModel.pSelectedPaymentModel;
    NSString *strTitle = [NSString stringWithFormat:@"%@ $%g", self.m_pSelectedModel.packageTitle, self.m_pSelectedModel.packagePrice];
    self.m_lblTitle.text = strTitle;

    [self.m_ctlTelephone.formatter setDefaultOutputPattern:@"+# ### ### #### ###"];
    [self.m_ctlTelephone.formatter addOutputPattern:@"+# ### ### ## ##" forRegExp:@"^7[0-689]\\d*$" imagePath:nil];
    [self.m_ctlTelephone.formatter addOutputPattern:@"+### ## ### ###" forRegExp:@"^374\\d*$" imagePath:nil];
    
    self.m_ctlTelephone.text = g_pUserModel.strTelephone;
    
    [self.m_tfCreditCardNumber.formatter setDefaultOutputPattern:@"#### #### #### ####"];
    [self.m_tfCreditCardNumber.formatter addOutputPattern:@"#### #### #### ####" forRegExp:@"^7[0-689]\\d*$" imagePath:nil];
    [self.m_tfCreditCardNumber.formatter addOutputPattern:@"#### #### #### ####" forRegExp:@"^374\\d*$" imagePath:nil];
    
    /*
    NSLog(@"key: %@   value:%@", key, [self.m_dicMonth objectForKey:key]);
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.viewSelectExpYear.frame = rect;
    self.viewSelectExpMonth.frame = rect;
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    if (type == 9)
        return;
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 8)
    {
        if ([result isKindOfClass:[NSString class]])
        {
            [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
        }
        return;
    }

    g_bPaid = true;
    
    if ([result isKindOfClass:[NSString class]])
    {
        NSString* strMessage = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"ALERT_PAYMENT_YOURECEIVE", @""), self.m_pSelectedModel.packageTitle, NSLocalizedString(@"ALERT_PAYMENT_PREMIUM", @"")];
        [CGlobal showAlert:self message:strMessage title:NSLocalizedString(@"ALERT_TITLE_CONGAT", @"")];
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
    //[CGlobal setState:TASKSTATE_SETTING_UPDATE_STRIPE nextState:TASKSTATE_SETTING_UPDATE];

}

- (void)onExpYearSelected:(CUIViewSelectExpYear *)viewExpYear type:(NSInteger)type didChooseExpYear:(NSInteger)value
{
    self.m_lblExpYear.text = [NSString stringWithFormat:@"%ld", (long)value];
    self.m_nExpYear = value;
}

-(void)onExpMonthSelected:(CUIViewSelectExpMonth *)viewExpYear type:(NSInteger)type didChooseExpYear:(NSInteger)value
{
    self.m_lblExpMonth.text = [NSString stringWithFormat:@"%ld", (long)value];
    self.m_nExpMonth = value;
}

- (void)setData:(CPaymentPlanModel*)model {
    
    self.m_pSelectedModel = model;
}

- (IBAction)onClickUpdate:(id)sender {
    if (![g_pUserModel.strTelephone isEqualToString:self.m_ctlTelephone.text] && ![self.m_ctlTelephone.text isEqualToString:@""])
    {
        [CServiceManager onEditTelephone:self type:9 model:self.m_ctlTelephone.text];
    }
    
    [[self view] endEditing:YES];
    [CGlobal showProgressHUD:self];
    
    STPCardParams *cardParams = [[STPCardParams alloc] init];
    cardParams.number = self.m_tfCreditCardNumber.phoneNumber;
    cardParams.expMonth = [self.m_lblExpMonth.text integerValue];
    cardParams.expYear = [self.m_lblExpYear.text integerValue];
    cardParams.cvc = self.m_tfCVV.text;
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            // show the error, maybe by presenting an alert to the user
            [CGlobal hideProgressHUD:self];
            [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_PAYMENT_INVALIDCARD", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        } else {
            //sk_test_oTuCxmqKEvAVbooaO47dDl2t
            //sk_live_tvg0WKHmXPb6GKqZkylayIg7
            
            NSDictionary *headers = @{ @"authorization": @"Bearer sk_live_tvg0WKHmXPb6GKqZkylayIg7",
                                       @"cache-control": @"no-cache"};
            NSString* strURL = [NSString stringWithFormat:@"https://api.stripe.com/v1/customers?email=%@&source=%@", g_strEmail, token.tokenId];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:10.0];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:headers];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if (error) {
                                                                //NSLog(@"%@", error);
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [self paymentFailed];
                                                                });
                                                            } else {
                                                                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                NSInteger status = httpResponse.statusCode;
                                                                if (status == 200)
                                                                {
                                                                    NSError* error1;
                                                                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                         options:kNilOptions
                                                                                                                           error:&error1];
                                                                    
                                                                    NSString* curID = [json objectForKey:@"id"];

                                                                        
                                                                    [self doCharge:curID token:token.tokenId];
                                                                }
                                                                else
                                                                {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [self paymentFailed];
                                                                    });
                                                                }
                                                                //NSLog(@"%@", httpResponse);
                                                            }
                                                        }];
            [dataTask resume];
        }
    }];
}

- (IBAction)onClickWiretransfer:(id)sender
{
    [[self view] endEditing:YES];
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onPostWirePayment:self type:8];
}

-(void)doCharge:(NSString*)curId token:(NSString*)tokenId
{
    NSDictionary *headers = @{ @"authorization": @"Bearer sk_live_tvg0WKHmXPb6GKqZkylayIg7",
                               @"cache-control": @"no-cache"};
    int amount = (int)self.m_pSelectedModel.packagePrice * 100;
    //NSString* strURL = [NSString stringWithFormat:@"https://api.stripe.com/v1/charges?amount=%d&currency=usd&description=%@&source=%@", amount, tokenId, tokenId];
    NSString* strURL = [NSString stringWithFormat:@"https://api.stripe.com/v1/charges?amount=%d&currency=usd&customer=%@", amount, curId];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        //NSLog(@"%@", error);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self paymentFailed];
                                                        });
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSInteger status = httpResponse.statusCode;
                                                        if (status == 200)
                                                        {
                                                            [self paymentDone:tokenId];
                                                        }
                                                        else
                                                        {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self paymentFailed];
                                                            });
                                                        }
                                                        //NSLog(@"%@", httpResponse);
                                                    }
                                                }];
    [dataTask resume];
}

-(void)paymentDone:(NSString*)token
{
    CPromotionModel* model = [[CPromotionModel alloc] init];
    model.gatewayName = @"Stripe";
    model.identificationUniqID = token;
    model.packageID = [NSString stringWithFormat:@"%ld", (long)self.m_pSelectedModel.packageID];
    model.presentationAmount = [NSString stringWithFormat:@"%.2f", self.m_pSelectedModel.packagePrice];
    //[CGlobal showProgressHUD:self];
    [CServiceManager onAddUserPayment:self type:0 model:model];
}
-(void)paymentFailed
{
    [CGlobal hideProgressHUD:self];
    [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_PAYMENT_FAILED", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
}
- (IBAction)onClickExpYear:(id)sender {
    [self.view endEditing:YES];
    [self.view addSubview:self.viewSelectExpYear];
    [self.view bringSubviewToFront:self.viewSelectExpYear];
    
    NSDate *now = [NSDate date];
    
    unsigned units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    NSInteger curYear = [components year];
    NSInteger defaultValue = self.m_nExpYear;
    if (defaultValue == 0)
        defaultValue = curYear;
    
    [self.viewSelectExpYear initData:0 title:NSLocalizedString(@"STR_EXPYEAR", @"") lunit:0 defaultValue:defaultValue maxValue:curYear + 5 minValue:curYear - 5 Gap:1];
    
    CGRect destFrame = self.viewSelectExpYear.frame;
    destFrame.origin.y = self.viewSelectExpYear.frame.size.height;
    self.viewSelectExpYear.frame = destFrame;
    
    destFrame.origin.y = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.viewSelectExpYear.frame = destFrame;
    }completion:^(BOOL finished) {
        
    }];
}

- (IBAction)onClickExpMonth:(id)sender {
    [self.view endEditing:YES];
    [self.view addSubview:self.viewSelectExpMonth];
    [self.view bringSubviewToFront:self.viewSelectExpMonth];
    
    NSDate *now = [NSDate date];
    
    unsigned units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:units fromDate:now];
    
    NSInteger curMonth = [components month];
    NSInteger defaultValue = self.m_nExpMonth;
    if (defaultValue == 0) {
        defaultValue = curMonth;
    }
    [self.viewSelectExpMonth initData:0 title:@"" defaultValue:defaultValue maxValue:12 minValue:1 Gap:1];
    
    CGRect destFrame = self.viewSelectExpMonth.frame;
    destFrame.origin.y = self.viewSelectExpMonth.frame.size.height;
    self.viewSelectExpMonth.frame = destFrame;
    
    destFrame.origin.y = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.viewSelectExpMonth.frame = destFrame;
    }completion:^(BOOL finished){
        
    }];
}
@end
