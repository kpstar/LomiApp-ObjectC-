//
//  CSetRateNutritionistViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CSetRateNutritionistViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CUIViewStarRate.h"
#import "CGlobal.h"

@interface CSetRateNutritionistViewController ()

@property (nonatomic,strong) CUIViewStarRate* viewRate;


@end

@implementation CSetRateNutritionistViewController

@synthesize m_ivAvatar, m_lblName, m_lblSex, m_lblFullyBooked, m_lblTitle, m_lblVote, m_tvDescript, m_ivStar1, m_ivStar2,m_ivStar3, m_ivStar4, m_ivStar5, m_pModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray* views1 = [[NSBundle mainBundle] loadNibNamed:@"CUIViewStarRate" owner:self options:nil];
    self.viewRate = views1[0];
    self.viewRate.delegate = self;
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
    
    if (m_pModel != nil)
        [self setData:m_pModel];
    
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.viewRate.frame = rect;
}


- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 0)
    {
        [self setData:g_pUserModel.pNutModel];
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
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_SORRY", @"")];
    }
}

- (void)onRateSelected:(CUIViewStarRate*)view type:(NSInteger)type
         didChooseRate:(CGFloat)value
{
    [CGlobal showProgressHUD:self];
    
    [CServiceManager onRateNutritionist:self type:0 rate:(int)value];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"NUT_TO_PROFILE"])
    {
        [CGlobal setState:TASKSTATE_PROFILE_NUT nextState:TASKSTATE_TAB_PROFILE];
    }
    if ([[segue identifier] isEqualToString:@"NUT_TO_TABMESSAGE"])
    {
        [CGlobal setState:TASKSTATE_PROFILE_NUT nextState:TASKSTATE_TAB_MESSAGES];
        g_vcTabHome.selectedIndex = 3;
    }
}


- (void)initModel:(CNutritionistModel*)model
{
    m_pModel = model;
}

- (IBAction)onClickRate:(id)sender
{
    [self.view addSubview:self.viewRate];
    [self.view bringSubviewToFront:self.viewRate];
    
    NSString* strTitle = [NSString stringWithFormat:@"How do you rate %@", m_pModel.strTitle];
    [self.viewRate initData:0 title:strTitle defaultValue:self.m_pModel.fRateAVG];
    
    CGRect destFrame = self.viewRate .frame;
    destFrame.origin.y = self.viewRate.frame.size.height;
    self.viewRate.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.viewRate.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickBack:(id)sender
{
//    if(self.navigationController){
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (IBAction)onClickChat:(id)sender
{
//    if(self.navigationController){
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (void)setData:(CNutritionistModel*)model
{
    self.m_pModel = model;
    
    [m_ivAvatar sd_setImageWithURL:[NSURL URLWithString:model.strThumbnail]
                  placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    m_lblName.text = model.strTitle;
    m_lblTitle.text = model.strTitle;
    
    if (m_pModel.fullybooked == YES)
    {
        self.m_lblFullyBooked.text = NSLocalizedString(@"STR_FULLYBOOKED", @"");
    }
    else
    {
        self.m_lblFullyBooked.text = @"";
    }

    
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

@end
