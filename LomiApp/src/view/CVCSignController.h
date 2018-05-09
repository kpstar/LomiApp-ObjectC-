//
//  CVCSignController.h
//  Yayyle
//
//  Created by TwinkleStar on 10/18/16.
//  Copyright © 2016 venus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUIViewController.h"
#import "CGlobal.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TWTRKit.h>
#import <TwitterKit/TWTRLogInButton.h>

@interface CVCSignController : CUIViewController<FBSDKLoginButtonDelegate, TWTRTweetViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (weak, nonatomic) IBOutlet UIView *m_viewFBLogin;
@property (weak, nonatomic) IBOutlet UIView *m_viewTWLogin;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSignup;

@property (weak, nonatomic) IBOutlet UILabel *m_lblVersion;

@property bool m_signup;


@end
