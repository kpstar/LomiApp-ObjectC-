//
//  CVCMyProgressViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/12/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CUIViewSelectWeight.h"
#import "MBProgressHUD.h"
#import "CGlobal.h"
#import "CProgressGraphView.h"

@interface CVCMyProgressViewController : CUIViewController<CUIViewSelectWeightDelegate>

@property (weak, nonatomic) IBOutlet UILabel *m_lblCurWeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblChangeWeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblGoalWeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCurWeightUnit;
@property (weak, nonatomic) IBOutlet UILabel *m_lblChangeWeightUnit;
@property (weak, nonatomic) IBOutlet UILabel *m_lblGoalWeightUnit;

@property (weak, nonatomic) IBOutlet UIImageView *m_ivUpDown;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBMI;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBMIString;
@property (weak, nonatomic) IBOutlet CProgressGraphView *m_viewGraph;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLastUpdate;

- (IBAction)onClickAddNewWeight:(id)sender;

@property   float            fStartingWeight;
@property   float            fGoalWeight;
@property   float            fChangeWeight;
@property   float            fCurrentWeight;
@property   NSInteger        unitWeight;
@property   float            fBMI;
@property   NSString*        strMeaning;

- (void)refreshMyProgress;

@end
