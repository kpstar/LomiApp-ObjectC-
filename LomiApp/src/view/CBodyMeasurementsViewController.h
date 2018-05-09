//
//  CBodyMeasurementsViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CUIViewSelectWeight.h"
#import "CUIViewSelectHeight.h"
#import "CUIViewSelectUnit.h"
#import "CUIViewSelectWUnit.h"
#import "CUIViewSelectLUnit.h"
#import "CGlobal.h"

@interface CBodyMeasurementsViewController : CUIViewController<CUIViewSelectWeightDelegate, CUIViewSelectHeightDelegate, CUIViewSelectWUnitDelegate, CUIViewSelectLUnitDelegate, CUIViewSelectUnitDelegate>

- (IBAction)onClickWeight:(id)sender;
- (IBAction)onClickHeight:(id)sender;
- (IBAction)onClickUpperarm:(id)sender;
- (IBAction)onClickChest:(id)sender;
- (IBAction)onClickWaist:(id)sender;
- (IBAction)onClickHips:(id)sender;
- (IBAction)onClickThigh:(id)sender;
- (IBAction)onClickUnitWeight:(id)sender;
- (IBAction)onClickUnitLength:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickDone:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *m_lblWeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblHeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUpperarm;
@property (weak, nonatomic) IBOutlet UILabel *m_lblChest;
@property (weak, nonatomic) IBOutlet UILabel *m_lblWaist;
@property (weak, nonatomic) IBOutlet UILabel *m_lblHips;
@property (weak, nonatomic) IBOutlet UILabel *m_lblThigh;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUnitWeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUnitLength;
@property (weak, nonatomic) IBOutlet UIView *m_viewBack;
@property (weak, nonatomic) IBOutlet UIView *m_viewDone;
@property (weak, nonatomic) IBOutlet UIView *m_viewContent;

@property NSInteger m_nWUnit;
@property NSInteger m_nLUnit;
@property float fWeight;
@property float fHeight;
@property float fUpperarm;
@property float fChest;
@property float fWaist;
@property float fHips;
@property float fThigh;
@end
