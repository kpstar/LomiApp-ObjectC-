//
//  CVCMyProgressViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/12/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCMyProgressViewController.h"
#import "CUIViewCongrate.h"
#import <Google/Analytics.h>

@interface CVCMyProgressViewController ()

@property (nonatomic,strong) CUIViewSelectWeight* viewSelectWeight;
@property (nonatomic,strong) CUIViewCongrate* viewCongrate;

@end

@implementation CVCMyProgressViewController

@synthesize m_lblCurWeight,m_lblChangeWeight,m_lblGoalWeight,m_ivUpDown,m_lblBMI,m_viewGraph,
            fStartingWeight,
            fGoalWeight,
            fChangeWeight,
            fCurrentWeight,
            unitWeight,
            fBMI,
            strMeaning;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSArray* views1 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectWeight" owner:self options:nil];
    self.viewSelectWeight = views1[0];
    self.viewSelectWeight.delegate = self;
    
    NSArray* views2 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewCongrate" owner:self options:nil];
    self.viewCongrate = views2[0];
    [self.viewCongrate initView];

    
    self.m_viewGraph.layer.borderColor = [[UIColor colorWithRed:(210.0f / 255) green:(210.0f / 255) blue:(210.0f / 255) alpha:1] CGColor];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"My Progress"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.viewSelectWeight.frame = rect;
    self.viewCongrate.frame = rect;
    
    self.unitWeight = [CGlobal wunitIndexFromValue:g_pUserModel.pMobileSettingModel.strWeightUnit];
    self.m_lblCurWeightUnit.text = g_pUserModel.pMobileSettingModel.strWeightUnit;
    self.m_lblChangeWeightUnit.text = g_pUserModel.pMobileSettingModel.strWeightUnit;
    self.m_lblGoalWeightUnit.text = g_pUserModel.pMobileSettingModel.strWeightUnit;
    
    //[CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onGetWeights:self type:0];
}

- (void)refreshMyProgress
{
    [CServiceManager onGetWeights:self type:0];
    [CServiceManager onGetLastMeasurement:self type:2];
    [CServiceManager onGetUserMeasurements:self type:3];
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (type == 0)
    {
        //self.unitWeight = g_pUserModel.pWeightModel.unitWeight;
        self.fCurrentWeight = g_pUserModel.pWeightModel.fCurrentWeight;
        self.fChangeWeight = g_pUserModel.pWeightModel.fChangeWeight;
        self.fStartingWeight = g_pUserModel.pWeightModel.fStartingWeight;
        self.fBMI = g_pUserModel.pWeightModel.fBMI;
        
        NSString* strUpdateDate = NSLocalizedString(@"STR_LASTUPDATEON", @"");//@"Last update on: ";
        
        self.m_lblLastUpdate.text = [NSString stringWithFormat:@"%@%@", strUpdateDate, g_pUserModel.pBodyMeasurementModel.strModifiedDate];
        self.m_lblCurWeight.text = [NSString stringWithFormat:@"%.1f", g_pUserModel.pWeightModel.fCurrentWeight];
        self.m_lblChangeWeight.text = [NSString stringWithFormat:@"%.1f", fabs(g_pUserModel.pWeightModel.fChangeWeight)];
        self.m_lblBMI.text = [NSString stringWithFormat:@"%.1f", g_pUserModel.pWeightModel.fBMI];
        
        if (g_pUserModel.pWeightModel.fBMI < 18.5)
        {
            self.m_lblBMIString.text = NSLocalizedString(@"STR_UNDERWIEGHT", @"");//@"Underweight";
        }
        else if (g_pUserModel.pWeightModel.fBMI >= 18.5 && g_pUserModel.pWeightModel.fBMI < 25)
        {
            self.m_lblBMIString.text = NSLocalizedString(@"STR_NORMALWEIGHT", @"");//@"Normal weight";
        }
        else if (g_pUserModel.pWeightModel.fBMI >= 25 && g_pUserModel.pWeightModel.fBMI < 30)
        {
            self.m_lblBMIString.text = NSLocalizedString(@"STR_OVERWEIGHT", @"");//@"Overweight";
        }
        else
        {
            self.m_lblBMIString.text = NSLocalizedString(@"STR_OBESE", @"");//@"Obese";
        }

        self.fGoalWeight = 0;
        if (g_pUserModel.pWeightModel.pGoalWeight == nil || g_pUserModel.pWeightModel.pGoalWeight.fWeight == 0)
        {
            self.m_lblGoalWeight.text = @"---";
        }
        else
        {
            self.fGoalWeight = g_pUserModel.pWeightModel.pGoalWeight.fWeight;
            self.m_lblGoalWeight.text = [NSString stringWithFormat:@"%.1f", g_pUserModel.pWeightModel.pGoalWeight.fWeight];
            
            if (self.fCurrentWeight <= self.fGoalWeight && self.fStartingWeight > self.fGoalWeight)
            {
                [self.viewCongrate initView];
                [self.view addSubview:self.viewCongrate];
                [self.view bringSubviewToFront:self.viewCongrate];
            }
        }
        
        if (self.fChangeWeight > 0 && g_pUserModel.pWeightModel.fStartingWeight > g_pUserModel.pWeightModel.fCurrentWeight)
            [self.m_ivUpDown setImage:[UIImage imageNamed:@"icon_arrow_down"]];
        else
        {
            [self.m_ivUpDown setImage:[UIImage imageNamed:@"icon_arrow_up"]];
        }
        
        [self.m_viewGraph setNeedsDisplay];
        
        //if (g_pUserModel.pBodyMeasurementModel.strCreationDate == nil)
        {
            //[CGlobal showProgressHUD:g_vcTabHome];
            [CServiceManager onGetLastMeasurement:self type:2];
        }
        
    }
    if (type == 1)
    {
        //[CGlobal showProgressHUD:g_vcTabHome];
        
        NSDate *mDate = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormat stringFromDate:mDate];
        g_pUserModel.pBodyMeasurementModel.strModifiedDate = strDate;
        g_pUserModel.pBodyMeasurementModel.strCreationDate = strDate;
        
        [CServiceManager onGetWeights:self type:0];
    }
    if (type == 2)
    {
        NSString* strUpdateDate = NSLocalizedString(@"STR_LASTUPDATEON", @"");//@"Last update on: ";
        
        self.m_lblLastUpdate.text = [NSString stringWithFormat:@"%@%@", strUpdateDate, g_pUserModel.pBodyMeasurementModel.strModifiedDate];
        
        [self.m_viewGraph setNeedsDisplay];
    }
    if (type == 3)
    {
        NSMutableArray* arrMeasurement = result;

        if (arrMeasurement.count > 0)
        {
            g_pUserModel.pStartBodyMeasurementModel = [arrMeasurement objectAtIndex:0];
        }
        [self.m_viewGraph setNeedsDisplay];
    }
    
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)onWeightSelected:(CUIViewSelectWeight*)viewWeight type:(NSInteger)type
         didChooseWeight:(float)value;
{
    g_pUserModel.fWeight = value;
    g_pUserModel.pBodyMeasurementModel.fWeight = value;
    
    [CGlobal showProgressHUD:g_vcTabHome];
    
    [CServiceManager onAddNewMeasurement:self type:1];
}

- (IBAction)onClickAddNewWeight:(id)sender
{
    [self.view addSubview:self.viewSelectWeight];
    [self.view bringSubviewToFront:self.viewSelectWeight];
    
    
    float fDefault = 80;
    float fMinValue = 40;
    if (self.unitWeight == WUNIT_POUNDS)
    {
        fMinValue = 88;
        fDefault = 176;
    }
    if (self.fCurrentWeight != 0)
        fDefault = self.fCurrentWeight;
    [self.viewSelectWeight initData:0 title:NSLocalizedString(@"STR_WEIGHT", @"") wunit:self.unitWeight defaultValue:fDefault maxValue:300 minValue:fMinValue fGap:0.1f];
    
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
@end
