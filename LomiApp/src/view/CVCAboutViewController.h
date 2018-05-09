//
//  CVCAboutViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 1/24/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CUIViewController.h"

@interface CVCAboutViewController : CUIViewController

@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;

- (IBAction)onClickFacebook:(id)sender;
- (IBAction)noClickTwitter:(id)sender;
- (IBAction)onClickLomi:(id)sender;
- (IBAction)onClickSnapchat:(id)sender;
- (IBAction)onClickInstagram:(id)sender;

@end
