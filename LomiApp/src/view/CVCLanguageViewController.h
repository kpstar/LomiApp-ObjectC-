//
//  CVCLanguageViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 11/22/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUIViewController.h"
#import "CPreferenceManager.h"

@interface CVCLanguageViewController : CUIViewController

@property (weak, nonatomic) IBOutlet UIButton*  m_btnEngish;
@property (weak, nonatomic) IBOutlet UIButton*  m_btnArabic;
- (IBAction)onClickBtnEnglish:(id)sender;
- (IBAction)onClickBtnArabic:(id)sender;

@end
