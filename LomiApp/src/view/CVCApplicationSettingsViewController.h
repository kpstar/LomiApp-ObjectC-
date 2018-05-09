//
//  CVCApplicationSettingsViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUIViewController.h"
#import "CUIViewSelectLanguage.h"

@interface CVCApplicationSettingsViewController : CUIViewController<CUIViewSelectLanguageDelegate>

@property (weak, nonatomic) IBOutlet UILabel *m_lblLanguage;
@property (weak, nonatomic) IBOutlet UISwitch *m_swMusic;
@property (weak, nonatomic) IBOutlet UISwitch *m_swSound;
@property (weak, nonatomic) IBOutlet UISwitch *m_swVibration;
@property (weak, nonatomic) IBOutlet UISwitch *m_swPrivacy;
@property (weak, nonatomic) IBOutlet UISwitch *m_swChallenge;
@property (weak, nonatomic) IBOutlet UISwitch *m_swChat;
@property (weak, nonatomic) IBOutlet UISwitch *m_swFriend;

@property NSInteger m_nLanguage;

- (IBAction)onClickLanguage:(id)sender;
- (IBAction)onClickBack:(id)sender;

@end
