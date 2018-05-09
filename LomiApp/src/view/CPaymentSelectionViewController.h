//
//  CPaymentSelectionViewController.h
//  LomiApp
//
//  Created by Aquari on 07/03/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "CUIViewController.h"
#import <PayPalMobile.h>
#import <PayPalConfiguration.h>
#import <PayPalPaymentViewController.h>
#import <PassKit/PassKit.h>


@interface CPaymentSelectionViewController : CUIViewController<PayPalPaymentDelegate, PKPaymentAuthorizationViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property NSInteger m_idxSelected;
@property NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (weak, nonatomic) IBOutlet UITableView *m_tblPayment;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPayment;


@property UIImage *m_imgPaypal;
@property UIImage *m_imgApplePay;
@property UIImage *m_imgBankPay;
@property UIImage *m_imgCreditPay;


//- (IBAction)onClickPaypal:(id)sender;   // Paypal Integration  Show paypal image
//- (IBAction)onClickCC:(id)sender;       // Disabled
//- (IBAction)onClickApple:(id)sender;    // Apple Pay Integration Show Apple image
//- (IBAction)onClickBank:(id)sender;     // Disabled
//- (IBAction)onClickPayment:(id)sender;
- (IBAction)onClickNext:(id)sender;
@end
