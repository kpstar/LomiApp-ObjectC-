//
//  CBodyMeasurementsViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CBodyMeasurementsViewController.h"
#import "CUtility.h"

@interface CBodyMeasurementsViewController ()

@property (nonatomic,strong) CUIViewSelectWeight* viewSelectWeight;
@property (nonatomic,strong) CUIViewSelectHeight* viewSelectHeight;
@property (nonatomic,strong) CUIViewSelectWUnit* viewSelectWUnit;
@property (nonatomic,strong) CUIViewSelectLUnit* viewSelectLUnit;
@property (nonatomic,strong) CUIViewSelectUnit* viewSelectUnit;

@end

@implementation CBodyMeasurementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSArray* views1 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectWeight" owner:self options:nil];
    self.viewSelectWeight = views1[0];
    self.viewSelectWeight.delegate = self;

    NSArray* views2 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectHeight" owner:self options:nil];
    self.viewSelectHeight = views2[0];
    self.viewSelectHeight.delegate = self;

    NSArray* views3 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectWUnit" owner:self options:nil];
    self.viewSelectWUnit = views3[0];
    self.viewSelectWUnit.delegate = self;

    NSArray* views4 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectLUnit" owner:self options:nil];
    self.viewSelectLUnit = views4[0];
    self.viewSelectLUnit.delegate = self;

    NSArray* views5 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectUnit" owner:self options:nil];
    self.viewSelectUnit = views5[0];
    self.viewSelectUnit.delegate = self;

    self.m_nWUnit = g_pUserModel.pBodyMeasurementModel.nWUnit;
    self.m_nLUnit = g_pUserModel.pBodyMeasurementModel.nLUnit;
    self.m_lblUnitWeight.text = g_arrWUnitString[self.m_nWUnit];
    self.m_lblUnitLength.text = g_arrLUnitString[self.m_nLUnit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.viewSelectWeight.frame = rect;
    self.viewSelectHeight.frame = rect;
    self.viewSelectWUnit.frame = rect;
    self.viewSelectLUnit.frame = rect;
    self.viewSelectUnit.frame = rect;

    if (g_nPrevState == TASKSTATE_REG_CHOOSENUTRITIONIST || g_nPrevState == TASKSTATE_NONE || g_nPrevState == TASKSTATE_LOGIN)
    {
        self.m_viewDone.hidden = NO;
        self.m_viewBack.hidden = YES;
        for (int i = 1; i < 11; i++) {
            UIView *view = [self.view viewWithTag:i];
            if (i <= 4)
            {
                /*
                CGRect rect = view.frame;
                rect.origin.y = rect.size.height * (i - 3) + 10 * (i - 1);
                [view setFrame:rect];
                */
                continue;
            }
            view.hidden = true;
        }
    }
    else
    {
//        self.m_viewBack.hidden = NO;
//        self.m_viewDone.hidden = YES;
        self.m_viewDone.hidden = NO;
        self.m_viewBack.hidden = NO;
    }

    
    self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", g_pUserModel.pBodyMeasurementModel.fWeight, g_pUserModel.pMobileSettingModel.strWeightUnit ];
    self.fWeight = g_pUserModel.pBodyMeasurementModel.fWeight;
    
    if ([g_pUserModel.pMobileSettingModel.strHeightUnit isEqualToString:@"in"])
    {
        self.m_lblHeight.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fHeight];
        self.fHeight = g_pUserModel.pBodyMeasurementModel.fHeight;
        self.m_lblUpperarm.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fUpperarm];
        self.fUpperarm = g_pUserModel.pBodyMeasurementModel.fUpperarm;
        self.m_lblChest.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fChest];
        self.fChest = g_pUserModel.pBodyMeasurementModel.fChest;
        self.m_lblWaist.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fWaist];
        self.fWaist = g_pUserModel.pBodyMeasurementModel.fWaist;
        self.m_lblHips.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fHips];
        self.fHips = g_pUserModel.pBodyMeasurementModel.fHips;
        self.m_lblThigh.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fThigh];
        self.fThigh = g_pUserModel.pBodyMeasurementModel.fThigh;
    }
    else
    {
        self.m_lblHeight.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fHeight, g_pUserModel.pMobileSettingModel.strHeightUnit];
        self.fHeight = g_pUserModel.pBodyMeasurementModel.fHeight;
        self.m_lblUpperarm.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fUpperarm, g_pUserModel.pMobileSettingModel.strHeightUnit ];
        self.fUpperarm = g_pUserModel.pBodyMeasurementModel.fUpperarm;
        self.m_lblChest.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fChest, g_pUserModel.pMobileSettingModel.strHeightUnit];
        self.fChest = g_pUserModel.pBodyMeasurementModel.fChest;
        self.m_lblWaist.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fWaist, g_pUserModel.pMobileSettingModel.strHeightUnit];
        self.fWaist = g_pUserModel.pBodyMeasurementModel.fWaist;
        self.m_lblHips.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fHips, g_pUserModel.pMobileSettingModel.strHeightUnit];
        self.fHips = g_pUserModel.pBodyMeasurementModel.fHips;
        self.m_lblThigh.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fThigh, g_pUserModel.pMobileSettingModel.strHeightUnit];
        self.fThigh = g_pUserModel.pBodyMeasurementModel.fThigh;
    }
    
    NSInteger value = [CGlobal wunitIndexFromValue:g_pUserModel.pMobileSettingModel.strWeightUnit];
    self.m_lblUnitWeight.text = g_arrWUnitString[value];
    self.m_nWUnit = value;
    value = [CGlobal lunitIndexFromValue:g_pUserModel.pMobileSettingModel.strHeightUnit];
    self.m_lblUnitLength.text = g_arrLUnitString[value];
    self.m_nLUnit = value;
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 0)
    {
    
        if (g_nPrevState == TASKSTATE_REG_CHOOSENUTRITIONIST || g_nPrevState == TASKSTATE_NONE || g_nPrevState == TASKSTATE_LOGIN)
        {
            [CGlobal showProgressHUD:self];
            [CGlobal setState:TASKSTATE_REG_BODYMEASUREMENTS nextState:TASKSTATE_TAB_MESSAGES];
            [CPreferenceManager saveEmail:g_strEmail];
            [CPreferenceManager savePassword:g_strPassword];
            [CPreferenceManager saveState:TASKSTATE_TAB_MESSAGES];
            [CPreferenceManager saveUserModel:g_pUserModel];
            [CServiceManager onGetMobileSettings:self type:5];
        }
        if (g_nPrevState == TASKSTATE_TAB_PROFILE)
        {
            [CGlobal setState:TASKSTATE_PROFILE_BODYMEASUREMENT nextState:TASKSTATE_TAB_PROFILE];
            [CPreferenceManager saveState:TASKSTATE_TAB_PROFILE];
            [CPreferenceManager saveUserModel:g_pUserModel];
            [self performSegueWithIdentifier: @"BODYMEASUREMENT_TO_TABPROFILE"
                                      sender: self];
        }
        
    } else if (type == 1)
    {
        if (g_nCurState != TASKSTATE_REG_BODYMEASUREMENTS)
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onGetLastMeasurement:self type:2];
            return;
        }
        [CPreferenceManager saveUserModel:g_pUserModel];
        
        self.fWeight = 0;
        self.fHeight = 0;
        self.fUpperarm = 0;
        self.fChest = 0;
        self.fWaist = 0;
        self.fHips = 0;
        self.fThigh = 0;

        if ([g_pUserModel.pMobileSettingModel.strHeightUnit isEqualToString:@"in"])
        {
            self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", self.fWeight, g_pUserModel.pMobileSettingModel.strWeightUnit ];
            self.m_lblHeight.text = [CUtility stringFromInch:self.fHeight];
            self.m_lblUpperarm.text = [CUtility stringFromInch:self.fUpperarm];
            self.m_lblChest.text = [CUtility stringFromInch:self.fChest];
            self.m_lblWaist.text = [CUtility stringFromInch:self.fWaist];
            self.m_lblHips.text = [CUtility stringFromInch:self.fHips];
            self.m_lblThigh.text = [CUtility stringFromInch:self.fThigh];
        }
        else
        {
            
            self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", self.fWeight, g_pUserModel.pMobileSettingModel.strWeightUnit ];
            
            self.m_lblHeight.text = [NSString stringWithFormat:@"%g %@", self.fHeight, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.m_lblUpperarm.text = [NSString stringWithFormat:@"%g %@", self.fUpperarm, g_pUserModel.pMobileSettingModel.strHeightUnit ];
            self.m_lblChest.text = [NSString stringWithFormat:@"%g %@", self.fChest, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.m_lblWaist.text = [NSString stringWithFormat:@"%g %@", self.fWaist, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.m_lblHips.text = [NSString stringWithFormat:@"%g %@", self.fHips, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.m_lblThigh.text = [NSString stringWithFormat:@"%g %@", self.fThigh, g_pUserModel.pMobileSettingModel.strHeightUnit];
        }

    }
    else if (type == 2)
    {
//        self.fWeight = 0;
//        self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", self.fWeight, g_pUserModel.pMobileSettingModel.strWeightUnit];
//        
//        self.fHeight = 0;
//        self.m_lblHeight.text = [NSString stringWithFormat:@"%g %@", self.fHeight, g_pUserModel.pMobileSettingModel.strHeightUnit];
//        self.fUpperarm = 0;
//        self.m_lblUpperarm.text = [NSString stringWithFormat:@"%g %@", self.fUpperarm, g_pUserModel.pMobileSettingModel.strHeightUnit];
//        self.fChest = 0;
//        self.m_lblChest.text = [NSString stringWithFormat:@"%g %@", self.fChest, g_pUserModel.pMobileSettingModel.strHeightUnit];
//        self.fWaist = 0;
//        self.m_lblWaist.text = [NSString stringWithFormat:@"%g %@", self.fWaist, g_pUserModel.pMobileSettingModel.strHeightUnit];
//        self.fHips = 0;
//        self.m_lblHips.text = [NSString stringWithFormat:@"%g %@", self.fHips, g_pUserModel.pMobileSettingModel.strHeightUnit];
//        self.fThigh = 0;
//        self.m_lblThigh.text = [NSString stringWithFormat:@"%g %@", self.fThigh, g_pUserModel.pMobileSettingModel.strHeightUnit];
        if ([g_pUserModel.pMobileSettingModel.strHeightUnit isEqualToString:@"in"])
        {
            self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", g_pUserModel.pBodyMeasurementModel.fWeight, g_pUserModel.pMobileSettingModel.strWeightUnit ];
            self.fWeight = g_pUserModel.pBodyMeasurementModel.fWeight;
            self.m_lblHeight.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fHeight];
            self.fHeight = g_pUserModel.pBodyMeasurementModel.fHeight;
            self.m_lblUpperarm.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fUpperarm];
            self.fUpperarm = g_pUserModel.pBodyMeasurementModel.fUpperarm;
            self.m_lblChest.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fChest];
            self.fChest = g_pUserModel.pBodyMeasurementModel.fChest;
            self.m_lblWaist.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fWaist];
            self.fWaist = g_pUserModel.pBodyMeasurementModel.fWaist;
            self.m_lblHips.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fHips];
            self.fHips = g_pUserModel.pBodyMeasurementModel.fHips;
            self.m_lblThigh.text = [CUtility stringFromInch:g_pUserModel.pBodyMeasurementModel.fThigh];
            self.fThigh = g_pUserModel.pBodyMeasurementModel.fThigh;
        }
        else
        {

            self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", g_pUserModel.pBodyMeasurementModel.fWeight, g_pUserModel.pMobileSettingModel.strWeightUnit ];
            self.fWeight = g_pUserModel.pBodyMeasurementModel.fWeight;
            
            self.m_lblHeight.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fHeight, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.fHeight = g_pUserModel.pBodyMeasurementModel.fHeight;
            self.m_lblUpperarm.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fUpperarm, g_pUserModel.pMobileSettingModel.strHeightUnit ];
            self.fUpperarm = g_pUserModel.pBodyMeasurementModel.fUpperarm;
            self.m_lblChest.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fChest, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.fChest = g_pUserModel.pBodyMeasurementModel.fChest;
            self.m_lblWaist.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fWaist, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.fWaist = g_pUserModel.pBodyMeasurementModel.fWaist;
            self.m_lblHips.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fHips, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.fHips = g_pUserModel.pBodyMeasurementModel.fHips;
            self.m_lblThigh.text = [NSString stringWithFormat:@"%g %@", g_pUserModel.pBodyMeasurementModel.fThigh, g_pUserModel.pMobileSettingModel.strHeightUnit];
            self.fThigh = g_pUserModel.pBodyMeasurementModel.fThigh;
        }
    }
    
    else if (type == 5)     //onGetMobileSettings
    {
        [CGlobal showProgressHUD:self];
        [CServiceManager onUserProfile:self type:6];
    }
    else if (type == 6)     //onUserProfile
    {
        [self performSegueWithIdentifier: @"BODYMEASUREMENT_TO_TABMESSAGE"
                              sender: self];
    }
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"BODYMEASUREMENT_TO_TABPROFILE"])
    {
        [CGlobal setState:TASKSTATE_PROFILE_BODYMEASUREMENT nextState:TASKSTATE_TAB_PROFILE];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Profile" object:nil];
    }
}


- (void)onWeightSelected:(CUIViewSelectWeight*)viewWeight type:(NSInteger)type
         didChooseWeight:(float)value;
{
    self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", value, g_arrWUnitValue[self.m_nWUnit] ];
    self.fWeight = value;
}


- (void)onHeightSelected:(CUIViewSelectHeight*)viewWeight type:(NSInteger)type didChooseHeight:(float)value
{
    if (type == 0)
    {
        self.m_lblHeight.text = [NSString stringWithFormat:@"%g %@", value, g_arrLUnitValue[self.m_nLUnit] ];
        if (self.m_nLUnit == LUNIT_INCHES)
        {
            self.m_lblHeight.text = [CUtility stringFromInch:value];
        }

        self.fHeight = value;
    }
    else if (type == 1)
    {
        self.m_lblUpperarm.text = [NSString stringWithFormat:@"%g %@", value, g_arrLUnitValue[self.m_nLUnit] ];
        if (self.m_nLUnit == LUNIT_INCHES)
        {
            self.m_lblUpperarm.text = [CUtility stringFromInch:value];
        }
        self.fUpperarm = value;
    }
    else if (type == 2)
    {
        self.m_lblChest.text = [NSString stringWithFormat:@"%g %@", value, g_arrLUnitValue[self.m_nLUnit]];
        if (self.m_nLUnit == LUNIT_INCHES)
        {
            self.m_lblChest.text = [CUtility stringFromInch:value];
        }
        self.fChest = value;
    }
    else if (type == 3)
    {
        self.m_lblWaist.text = [NSString stringWithFormat:@"%g %@", value, g_arrLUnitValue[self.m_nLUnit]];
        if (self.m_nLUnit == LUNIT_INCHES)
        {
            self.m_lblWaist.text = [CUtility stringFromInch:value];
        }
        self.fWaist = value;
    }
    else if (type == 4)
    {
        self.m_lblHips.text = [NSString stringWithFormat:@"%g %@", value, g_arrLUnitValue[self.m_nLUnit]];
        if (self.m_nLUnit == LUNIT_INCHES)
        {
            self.m_lblHips.text = [CUtility stringFromInch:value];
        }
        self.fHips = value;
    }
    else if (type == 5)
    {
        self.m_lblThigh.text = [NSString stringWithFormat:@"%g %@", value, g_arrLUnitValue[self.m_nLUnit]];
        if (self.m_nLUnit == LUNIT_INCHES)
        {
            self.m_lblThigh.text = [CUtility stringFromInch:value];
        }
        self.fThigh = value;
    }
}

- (void)onUnitSelected:(CUIViewSelectWUnit *)view type:(NSInteger)type didChooseUnit:(NSInteger)value
{
    self.m_lblUnitWeight.text = g_arrWUnitString[value];
    self.m_nWUnit = value;
    g_pUserModel.pMobileSettingModel.strWeightUnit = g_arrWUnitValue[value];
    
    value = (value + 1) % 2;
    self.m_lblUnitLength.text = g_arrLUnitString[value];
    self.m_nLUnit = value;
    g_pUserModel.pMobileSettingModel.strHeightUnit = g_arrLUnitValue[value];
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onEditMobileSettings:self type:1];
}

- (void)onWUnitSelected:(CUIViewSelectWUnit *)view type:(NSInteger)type didChooseUnit:(NSInteger)value
{
    self.m_lblUnitWeight.text = g_arrWUnitString[value];
    self.m_nWUnit = value;
    g_pUserModel.pMobileSettingModel.strWeightUnit = g_arrWUnitValue[value];
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onEditMobileSettings:self type:1];
}

- (void)onLUnitSelected:(CUIViewSelectLUnit *)view type:(NSInteger)type didChooseUnit:(NSInteger)value
{
    self.m_lblUnitLength.text = g_arrLUnitString[value];
    self.m_nLUnit = value;
    g_pUserModel.pMobileSettingModel.strHeightUnit = g_arrLUnitValue[value];
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onEditMobileSettings:self type:2];
    
}

- (IBAction)onClickWeight:(id)sender
{
    
    [self.view addSubview:self.viewSelectWeight];
    [self.view bringSubviewToFront:self.viewSelectWeight];
    
    float fDefault = 80;
    float fMinValue = 40;
    if (self.m_nWUnit == WUNIT_POUNDS)
    {
        fMinValue = 88;
        fDefault = 176;
    }
    if (self.fWeight != 0)
        fDefault = self.fWeight;
    
    [self.viewSelectWeight initData:0 title:NSLocalizedString(@"STR_WEIGHT", @"") wunit:self.m_nWUnit defaultValue:fDefault maxValue:300 minValue:fMinValue fGap:0.1f];
    
    CGRect destFrame = self.viewSelectWeight .frame;
    destFrame.origin.y = self.viewSelectWeight.frame.size.height;
    self.viewSelectWeight.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectWeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (IBAction)onClickHeight:(id)sender
{
    [self.view addSubview:self.viewSelectHeight];
    [self.view bringSubviewToFront:self.viewSelectHeight];
    
    float fDefault = 170;
    if (self.m_nLUnit == LUNIT_INCHES)
        fDefault = 65;
    if (self.fHeight != 0)
        fDefault = self.fHeight;
    float fMinValue = 140;
    float fMaxValue = 195;
    if (self.m_nLUnit == LUNIT_INCHES)
    {
        fMinValue = 55;
        fMaxValue = 77;
    }
    [self.viewSelectHeight initData:0 title:NSLocalizedString(@"STR_HEIGHT", @"") lunit:self.m_nLUnit defaultValue:fDefault maxValue:fMaxValue minValue:fMinValue fGap:1.0f];

    CGRect destFrame = self.viewSelectHeight .frame;
    destFrame.origin.y = self.viewSelectHeight.frame.size.height;
    self.viewSelectHeight.frame = destFrame;
 
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectHeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickUpperarm:(id)sender
{
    [self.view addSubview:self.viewSelectHeight];
    [self.view bringSubviewToFront:self.viewSelectHeight];
    
    float fDefault = 50;
    if (self.fUpperarm != 0)
        fDefault = self.fUpperarm;
    [self.viewSelectHeight initData:1 title:@"Upper arm" lunit:self.m_nLUnit defaultValue:fDefault maxValue:200 minValue:0 fGap:1.0f];

    CGRect destFrame = self.viewSelectHeight .frame;
    destFrame.origin.y = self.viewSelectHeight.frame.size.height;
    self.viewSelectHeight.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectHeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                      
                     }];
}

- (IBAction)onClickChest:(id)sender
{
    [self.view addSubview:self.viewSelectHeight];
    [self.view bringSubviewToFront:self.viewSelectHeight];
    
    float fDefault = 50;
    if (self.fChest != 0)
        fDefault = self.fChest;
    [self.viewSelectHeight initData:2 title:@"Chest" lunit:self.m_nLUnit defaultValue:fDefault maxValue:200 minValue:0 fGap:1.0f];

    CGRect destFrame = self.viewSelectHeight .frame;
    destFrame.origin.y = self.viewSelectHeight.frame.size.height;
    self.viewSelectHeight.frame = destFrame;
    
    destFrame.origin.y = 0;

    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectHeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickWaist:(id)sender
{
    [self.view addSubview:self.viewSelectHeight];
    [self.view bringSubviewToFront:self.viewSelectHeight];
    
    float fDefault = 50;
    if (self.fWaist != 0)
        fDefault = self.fWaist;
    [self.viewSelectHeight initData:3 title:@"Waist" lunit:self.m_nLUnit defaultValue:fDefault maxValue:200 minValue:0 fGap:1.0f];

    CGRect destFrame = self.viewSelectHeight .frame;
    destFrame.origin.y = self.viewSelectHeight.frame.size.height;
    self.viewSelectHeight.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectHeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickHips:(id)sender
{
    [self.view addSubview:self.viewSelectHeight];
    [self.view bringSubviewToFront:self.viewSelectHeight];
    
    float fDefault = 50;
    if (self.fHips != 0)
        fDefault = self.fHips;
    [self.viewSelectHeight initData:4 title:@"Hips" lunit:self.m_nLUnit defaultValue:fDefault maxValue:200 minValue:0 fGap:1.0f];

    CGRect destFrame = self.viewSelectHeight .frame;
    destFrame.origin.y = self.viewSelectHeight.frame.size.height;
    self.viewSelectHeight.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectHeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
 
                     }];
}

- (IBAction)onClickThigh:(id)sender
{
    [self.view addSubview:self.viewSelectHeight];
    [self.view bringSubviewToFront:self.viewSelectHeight];
    
    float fDefault = 50;
    if (self.fThigh != 0)
        fDefault = self.fThigh;
    [self.viewSelectHeight initData:5 title:@"Thigh" lunit:self.m_nLUnit defaultValue:fDefault maxValue:200 minValue:0 fGap:1.0f];

    CGRect destFrame = self.viewSelectHeight .frame;
    destFrame.origin.y = self.viewSelectHeight.frame.size.height;
    self.viewSelectHeight.frame = destFrame;
    
    destFrame.origin.y = 0;
 
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectHeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickUnitWeight:(id)sender
{
    [self.view addSubview:self.viewSelectUnit];
    [self.view bringSubviewToFront:self.viewSelectUnit];
    
    CGRect destFrame = self.viewSelectUnit.frame;
    destFrame.origin.y = self.viewSelectUnit.frame.size.height;
    self.viewSelectUnit.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectUnit.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
      
                     }];
}

- (IBAction)onClickUnitLength:(id)sender
{
    [self.view addSubview:self.viewSelectLUnit];
    [self.view bringSubviewToFront:self.viewSelectLUnit];
    
    CGRect destFrame = self.viewSelectLUnit .frame;
    destFrame.origin.y = self.viewSelectLUnit.frame.size.height;
    self.viewSelectLUnit.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewSelectLUnit.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickBack:(id)sender
{
//    g_pUserModel.fWeight = self.fWeight;
//    g_pUserModel.pBodyMeasurementModel.fWeight = self.fWeight;
//    g_pUserModel.pBodyMeasurementModel.fHeight = self.fHeight;
//    g_pUserModel.pBodyMeasurementModel.fUpperarm = self.fUpperarm;
//    g_pUserModel.pBodyMeasurementModel.fChest = self.fChest;
//    g_pUserModel.pBodyMeasurementModel.fWaist = self.fWaist;
//    g_pUserModel.pBodyMeasurementModel.fHips = self.fHips;
//    g_pUserModel.pBodyMeasurementModel.fThigh = self.fThigh;
//
//    [CGlobal showProgressHUD:self];
//    
//    [CServiceManager onAddNewMeasurement:self type:0];

    if (g_nPrevState == TASKSTATE_TAB_PROFILE)
    {
        [CGlobal setState:TASKSTATE_PROFILE_BODYMEASUREMENT nextState:TASKSTATE_TAB_PROFILE];
        [CPreferenceManager saveState:TASKSTATE_TAB_PROFILE];
        [CPreferenceManager saveUserModel:g_pUserModel];
        [self performSegueWithIdentifier: @"BODYMEASUREMENT_TO_TABPROFILE"
                                  sender: self];
    }
}

- (IBAction)onClickDone:(id)sender
{
    g_pUserModel.fWeight = self.fWeight;
    g_pUserModel.pBodyMeasurementModel.fWeight = self.fWeight;
    g_pUserModel.pBodyMeasurementModel.fHeight = self.fHeight;
    g_pUserModel.pBodyMeasurementModel.fUpperarm = self.fUpperarm;
    g_pUserModel.pBodyMeasurementModel.fChest = self.fChest;
    g_pUserModel.pBodyMeasurementModel.fWaist = self.fWaist;
    g_pUserModel.pBodyMeasurementModel.fHips = self.fHips;
    g_pUserModel.pBodyMeasurementModel.fThigh = self.fThigh;

    [CGlobal showProgressHUD:self];
    
    [CServiceManager onAddNewMeasurement:self type:0];
}
@end
