//
//  CIndividualNutritionistViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CIndividualNutritionistViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CGlobal.h"
#import <Google/Analytics.h>

@interface CIndividualNutritionistViewController ()

@end

@implementation CIndividualNutritionistViewController

@synthesize m_ivAvatar, m_lblName, m_lblSex, m_lblFullyBooked, m_lblTitle, m_lblVote, m_tvDescript, m_ivStar1, m_ivStar2,m_ivStar3, m_ivStar4, m_ivStar5, m_pModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self.m_tvDescript setContentOffset:CGPointZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Nutritionist"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
 
    if (m_pModel != nil)
        [self setData:m_pModel];
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 0)          // onNutritionistMembership
    {
        g_strEmail = g_pUserModel.strEmail;
        g_strPassword = g_pUserModel.strPassword;
        
        if (g_strEmail != nil)
        {
            [CGlobal setState:TASKSTATE_REG_CHOOSENUTRITIONIST nextState:TASKSTATE_REG_BODYMEASUREMENTS];
            [CPreferenceManager saveState:TASKSTATE_REG_BODYMEASUREMENTS];
            [CPreferenceManager saveUserModel:g_pUserModel];
            [self performSegueWithIdentifier: @"CHOOSENUT_TO_BODYMEASUREMENT"
                                      sender: self];
        }
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

- (void)initModel:(CNutritionistModel*)model
{
    m_pModel = model;
}

- (void)setData:(CNutritionistModel*)model
{
    
    [m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:model.strThumbnail]
                  placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    if (m_pModel.fullybooked == YES)
    {
        self.m_viewNext.hidden = YES;
        //m_lblName.text = [NSString stringWithFormat:@"(Fully Booked) %@", model.strTitle];
        m_lblName.text = model.strTitle;
        self.m_lblFullyBooked.text = NSLocalizedString(@"STR_FULLYBOOKED", @"");
    }
    else
    {
        self.m_viewNext.hidden = NO;
        m_lblName.text = model.strTitle;
        self.m_lblFullyBooked.text = @"";
    }

    m_lblTitle.text = model.strTitle;
    m_lblSex.text = model.strGender;
    m_tvDescript.text = model.strDescription;
    self.m_lblCountry.text = model.strCountryFullName;
    self.m_lblLan.text = model.strLanguage;
    
    NSString *strVote = @"";
    if (model.nCountVoters > 1)
        strVote = NSLocalizedString(@"STR_VOTES", @"");//@"votes";
    else
        strVote = NSLocalizedString(@"STR_VOTE", @"");//@"vote";
    m_lblVote.text = [NSString stringWithFormat:@"%.0f / 5 (%ld %@)", model.fRateAVG, (long)model.nCountVoters, strVote];
    
    [m_ivStar1 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar2 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_red"]];
    [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_red"]];
    
    if (model.fRateAVG < 1)
    {
        [m_ivStar1 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar2 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 2)
    {
        [m_ivStar2 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 3)
    {
        [m_ivStar3 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 4)
    {
        [m_ivStar4 setImage:[UIImage imageNamed:@"icon_star_white"]];
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
    if (model.fRateAVG < 4.5)
    {
        [m_ivStar5 setImage:[UIImage imageNamed:@"icon_star_white"]];
    }
}

- (IBAction)onClickBack:(id)sender
{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickNext:(id)sender
{
    g_pUserModel.pNutModel = m_pModel;
    
    [CGlobal showProgressHUD:self];
    
    [CServiceManager onNutritionistMembership:self type:0 model:m_pModel isSelect:YES];
}
@end
