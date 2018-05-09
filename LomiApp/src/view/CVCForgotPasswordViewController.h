//
//  CVCForgotPasswordViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 11/24/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUIViewController.h"

@interface CVCForgotPasswordViewController : CUIViewController<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickReset:(id)sender;
- (IBAction)onClickView:(id)sender;

@end
