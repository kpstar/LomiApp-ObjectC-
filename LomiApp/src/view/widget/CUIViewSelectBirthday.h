//
//  CUIViewSelectBirthday.h
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUIViewSelectBirthday : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *m_ctlDatePicker;
- (IBAction)onSelectDone:(id)sender;
- (IBAction)onSelectCancel:(id)sender;

@end
