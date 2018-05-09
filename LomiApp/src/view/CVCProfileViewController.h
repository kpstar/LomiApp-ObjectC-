//
//  CVCProfileViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/9/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CPaymentPlanModel.h"
#import "CUIViewController.h"
#import "CVCProfileEditViewController.h"

@interface CVCProfileViewController : CUIViewController

@property (weak, nonatomic) IBOutlet UIImageView *m_ivAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCountry;
@property (weak, nonatomic) IBOutlet UILabel *m_lblHeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblHeightUnit;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWeightUnit;
@property (weak, nonatomic) IBOutlet UILabel *m_lblAge;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivNutAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblNutName;
@property (weak, nonatomic) IBOutlet UIView *m_viewContainer;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPremium;

@property   Boolean          bIsLoaded;
@property   CVCProfileEditViewController* m_vcEdit;

- (IBAction)onClickLogout:(id)sender;

- (void)refreshProfile;

@end
