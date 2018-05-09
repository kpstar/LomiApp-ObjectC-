//
//  CUIViewCongrate.h
//  LomiApp
//
//  Created by TwinkleStar on 1/16/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUIViewCongrate : UIView

@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
- (IBAction)onClickClose:(id)sender;
- (void)initView;

@end
