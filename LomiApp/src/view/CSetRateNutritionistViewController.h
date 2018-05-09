//
//  CSetRateNutritionistViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CNutritionistModel.h"
#import "CUIViewStarRate.h"

@interface CSetRateNutritionistViewController : CUIViewController<CUIViewStarRateDelegate>

@property (strong, nonatomic) CNutritionistModel* m_pModel;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSex;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar1;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar2;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar3;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar4;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivStar5;
@property (weak, nonatomic) IBOutlet UITextView *m_tvDescript;
@property (weak, nonatomic) IBOutlet UILabel *m_lblVote;
@property (weak, nonatomic) IBOutlet UILabel *m_lblFullyBooked;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLan;


- (IBAction)onClickRate:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickChat:(id)sender;
- (void)setData:(CNutritionistModel*)model;
- (void)initModel:(CNutritionistModel*)model;

@end
