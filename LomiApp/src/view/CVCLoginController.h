//
//  CVCLoginController.h
//  Yayyle
//
//  Created by TwinkleStar on 10/18/16.
//  Copyright © 2016 venus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUIViewController.h"

@interface CVCLoginController : CUIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton*  m_btnLogin;
@property (weak, nonatomic) IBOutlet UITextField*  m_txtUsername;
@property (weak, nonatomic) IBOutlet UITextField*  m_txtPassword;
@property (weak, nonatomic) IBOutlet UIView*  m_viewInput;
@property (weak, nonatomic) IBOutlet UIView*  m_viewContainer;

@property (weak, nonatomic) IBOutlet UIView *m_vbtnForgotPass;
@property (weak, nonatomic) IBOutlet UIView *m_vbtnBack;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickForgot:(id)sender;

- (IBAction) onClickLogin:(id)sender forEvent:(UIEvent*)event;

- (void)onClickAlertOK;

@end
