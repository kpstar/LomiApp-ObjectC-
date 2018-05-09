//
//  CVCRegist1ViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "BEMCheckBox.h"

@interface CVCRegist1ViewController : CUIViewController<UITextFieldDelegate, BEMCheckBoxDelegate>

@property (weak, nonatomic) IBOutlet UITextField *m_tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *m_tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *m_tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_tfEmailConfirm;
@property (weak, nonatomic) IBOutlet UITextField *m_tfPass;
@property (weak, nonatomic) IBOutlet UITextField *m_tfPassConfirm;
@property (weak, nonatomic) IBOutlet UIView *m_viewTerm;
@property (weak, nonatomic) IBOutlet BEMCheckBox *m_ctlTerm;
@property (weak, nonatomic) IBOutlet UIButton *m_btnNext;
@property (weak, nonatomic) IBOutlet UITextView *m_tvTerms;

- (IBAction)onClickTerm:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickNext:(id)sender;
- (IBAction)onClickView:(id)sender;
- (IBAction)texfieldEditChanged:(id)sender;
- (IBAction)onClickTermLabel:(id)sender;
- (IBAction)onClickAcceptofTerm:(id)sender;
- (IBAction)onClickCloseofTerm:(id)sender;

@end
