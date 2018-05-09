//
//  CQOtherViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CUIViewSelectWeight.h"

@interface CQOtherViewController : CUIViewController<CUIViewSelectWeightDelegate>

@property (weak, nonatomic) IBOutlet UITextView *m_tvDescDisease;
@property (weak, nonatomic) IBOutlet UITextView *m_tvDescWeight;

@property (weak, nonatomic) IBOutlet UITextView *m_tvDisease;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWeight;
@property float fWeight;

- (IBAction)onClickWeight:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickNext:(id)sender;

@end
