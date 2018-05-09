//
//  CVCSettingsViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"

@interface CVCSettingsViewController : CUIViewController
    
@property (weak, nonatomic) IBOutlet UITextView *m_tvUpdateAccount;
    
- (IBAction)onClickBack:(id)sender;

@end
