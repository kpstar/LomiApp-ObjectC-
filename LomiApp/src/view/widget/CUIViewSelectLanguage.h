//
//  CUIViewSelectLanguage.h
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CUIViewSelectLanguageDelegate;

@interface CUIViewSelectLanguage : UIView

@property (nonatomic, weak) id<CUIViewSelectLanguageDelegate> delegate;

- (IBAction)onClickEnglish:(id)sender;
- (IBAction)onClickArabic:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end

@protocol CUIViewSelectLanguageDelegate <NSObject>

- (void)onLanguageSelected:(CUIViewSelectLanguage*)view type:(NSInteger)type
         didChooseLanguage:(NSInteger)value;

@end
