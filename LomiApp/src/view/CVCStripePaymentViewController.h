//
//  CVCStripePaymentViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/25/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CUIViewController.h"
#import "CPaymentPlanModel.h"
#import "SHSPhoneTextField.h"
#import "CUIViewSelectExpYear.h"
#import "CUIViewSelectExpMonth.h"

@interface CVCStripePaymentViewController : CUIViewController<CUIViewSelectExpYearDelegate, CUIViewSelectExpMonthDelegate>

- (IBAction)onClickExpYear:(id)sender;
- (IBAction)onClickExpMonth:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet SHSPhoneTextField *m_tfCreditCardNumber;
//@property (weak, nonatomic) IBOutlet UITextField *m_tfExpYear;
//@property (weak, nonatomic) IBOutlet UITextField *m_tfExpMonth;
@property (weak, nonatomic) IBOutlet UITextField *m_tfCVV;
@property (weak, nonatomic) IBOutlet UITextView *m_tvWiretransfer;
@property (weak, nonatomic) IBOutlet UILabel *m_lblExpYear;
@property (weak, nonatomic) IBOutlet UILabel *m_lblExpMonth;

@property (strong, nonatomic) CPaymentPlanModel* m_pSelectedModel;
@property (weak, nonatomic) IBOutlet SHSPhoneTextField *m_ctlTelephone;

- (IBAction)onClickUpdate:(id)sender;
- (IBAction)onClickWiretransfer:(id)sender;
- (void)setData:(CPaymentPlanModel*)model;

@property NSInteger m_nExpYear;
@property NSInteger m_nExpMonth;

@end
