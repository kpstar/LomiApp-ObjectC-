//
//  CVCContactViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 3/10/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUIViewController.h"

@interface CVCContactViewController : CUIViewController

@property (weak, nonatomic) IBOutlet UITextView *m_tvBody;
@property (weak, nonatomic) IBOutlet UITextView *m_tvDescript;


- (IBAction)onClickSendMessage:(id)sender;
- (IBAction)onClickBack:(id)sender;

@end
