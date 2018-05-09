//
//  CPromotionCodeViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/20/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"

@interface CPromotionCodeViewController : CUIViewController

@property (weak, nonatomic) IBOutlet UITextView *m_tvDescription;
@property (weak, nonatomic) IBOutlet UITextField *m_tfCode;

@property   NSInteger   m_nIndex;
@property   NSString*   m_strGatewayName;

- (void)setData:(NSInteger)index;
- (IBAction)onClickUpdate:(id)sender;
- (IBAction)texfieldEditChanged:(id)sender;

- (void)onClickAlertOK;

@end
