//
//  CQOtherViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CQOtherViewController.h"
#import "CUIViewSelectWeight.h"
#import "CGlobal.h"

@interface CQOtherViewController ()
@property (nonatomic,strong) CUIViewSelectWeight* viewSelectWeight;

@end

@implementation CQOtherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDescDisease.text = NSLocalizedStringFromTable(@"Q5y-qD-pou.text", @"Main", @"");
    self.m_tvDescWeight.text = NSLocalizedStringFromTable(@"f8D-Vf-BFO.text", @"Main", @"");

    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"CUIViewSelectWeight" owner:self options:nil];
    self.viewSelectWeight = views[0];
    self.viewSelectWeight.delegate = self;
    
    self.fWeight = g_pUserModel.fWeight;
    
    if (self.fWeight != 0)
        self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", self.fWeight, g_arrWUnitValue[WUNIT_KILOGRAMS]];

//        self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", self.fWeight, g_arrWUnitValue[g_pUserModel.pBodyMeasurementModel.nWUnit] ];

    self.m_tvDisease.text = g_pUserModel.strDiseases;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.viewSelectWeight.frame = rect;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];


    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];

    if (g_nPrevState == TASKSTATE_SIGNUP || g_nPrevState == TASKSTATE_NONE)
    {
        [CGlobal setState:TASKSTATE_REG_QUESTIONARIES nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveUserModel:g_pUserModel];
        [self performSegueWithIdentifier: @"QOTHER_TO_CHOOSENUT"
                                  sender: self];
    }
    else if (g_nPrevState == TASKSTATE_TAB_PROFILE)
    {
        [CGlobal setState:TASKSTATE_PROFILE_QUESTIONNAIRE nextState:TASKSTATE_TAB_PROFILE];
        [CPreferenceManager saveState:TASKSTATE_TAB_PROFILE];
        [CPreferenceManager saveUserModel:g_pUserModel];
        [self performSegueWithIdentifier: @"QOTHER_TO_TABPROFILE"
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickWeight:(id)sender
{
    [[self view] endEditing:YES];

    [self.view addSubview:self.viewSelectWeight];
    [self.view bringSubviewToFront:self.viewSelectWeight];

    float fDefault = 80;
    if (self.fWeight != 0)
        fDefault = self.fWeight;

    [self.viewSelectWeight initData:0 title:NSLocalizedString(@"STR_WEIGHT", @"") wunit:WUNIT_KILOGRAMS defaultValue:fDefault maxValue:300 minValue:40 fGap:0.1f];

    CGRect destFrame = self.viewSelectWeight .frame;
    destFrame.origin.y = self.viewSelectWeight.frame.size.height;
    self.viewSelectWeight.frame = destFrame;

    destFrame.origin.y = 0;

    [UIView animateWithDuration:0.3
                     animations:^{
                         self.viewSelectWeight.frame = destFrame;
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (IBAction)onClickBack:(id)sender
{
    [[self view] endEditing:YES];
    
    g_pUserModel.fWeight = self.fWeight;
    g_pUserModel.strDiseases = self.m_tvDisease.text;

    [self performSegueWithIdentifier: @"QOTHER_TO_QFOODKIND"
                              sender: self];

}

- (IBAction)onClickNext:(id)sender
{
    [[self view] endEditing:YES];

    g_pUserModel.fWeight = self.fWeight;
    g_pUserModel.strDiseases = self.m_tvDisease.text;

    [CGlobal showProgressHUD:self];

    [CServiceManager onQuestioners:self type:0];
 
}

- (void)onWeightSelected:(CUIViewSelectWeight *)viewWeight type:(NSInteger)type didChooseWeight:(float)value
{
    self.m_lblWeight.text = [NSString stringWithFormat:@"%.1f %@", value, g_arrWUnitValue[g_pUserModel.pBodyMeasurementModel.nWUnit] ];
    self.fWeight = value;
}
@end
