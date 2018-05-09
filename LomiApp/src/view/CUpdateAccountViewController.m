//
//  CUpdateAccountViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/20/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUpdateAccountViewController.h"
#import "CPromotionCodeViewController.h"
#import "CPaymentPlanCollectionViewCell.h"
#import "CVCStripePaymentViewController.h"
#import "CGlobal.h"
#import "CPaymentPlanModel.h"
#import "CUIPopupExpire.h"
#import "CUIPopupPromotion.h"

@interface CUpdateAccountViewController ()

@property (nonatomic,strong) CUIPopupExpire* viewPopup;
@property (nonatomic, strong) CUIPopupPromotion* viewPromotion;

@end

@implementation CUpdateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray* views2 = [[NSBundle mainBundle] loadNibNamed:@"CUIPopupExpire" owner:self options:nil];
    self.viewPopup = views2[0];
    self.viewPopup.delegate = self;
    [self.viewPopup initView];
    
    NSArray* views3 = [[NSBundle mainBundle] loadNibNamed:@"CUIPopupPromotion" owner:self options:nil];
    self.viewPromotion.m_tvDesc.delegate = self;
    self.viewPromotion = views3[0];
    self.viewPromotion.delegate = self;
    [self.viewPromotion initView];

    [self.m_cvPlan registerNib:[UINib nibWithNibName:@"CPaymentPlanCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_PLAN"];
    
    
    self.m_lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    self.m_lblDescription.numberOfLines = 0;
    
    self.m_btnUpgrade.layer.cornerRadius = 10;
    self.m_btnUpgrade.hidden = TRUE;
    
//    if (g_nPrevState == TASKSTATE_SETTING_UPDATE_STRIPE || g_nPrevState == TASKSTATE_SETTING_UPDATE_PROMOTION)
//    {
//        self.m_arrPlans = g_arrPlans;
//        [self.m_cvPlan reloadData];
//    }
//    else
//    {
        self.m_arrPlans = [[NSMutableArray alloc] init];
    self.m_arrPromotionPlans = [[NSMutableArray alloc] init];
        [self refreshCollection];
//    }
  
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
    self.viewPopup.frame = rect;
    self.viewPromotion.frame = rect;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.m_timerNotification invalidate];
    self.m_timerNotification = nil;
    g_bIsPackageIdle = false;
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 0)
    {
        if (self.m_arrPlans != nil)
            [self.m_arrPlans removeAllObjects];
        [self.m_arrPlans addObjectsFromArray:result];
        g_arrPlans = self.m_arrPlans;
        [result removeAllObjects];
        result = nil;
        
        [self refreshUserPlan];
    }
    if (type == 1)
    {
        self.m_pCurrentModel = result;
        g_pUserModel.pPaymentModel = result;
        if ([g_strEmail isEqualToString:@"nnnn@test.com11"])
        {
            if (self.m_arrPlans != nil)
                [self.m_arrPlans removeAllObjects];
            [self.m_arrPlans addObject:self.m_pCurrentModel];
            g_arrPlans = self.m_arrPlans;
        }

        self.m_lblPlan.text = g_pUserModel.pPaymentModel.packageTitle;
        self.m_lblExpDate.text = g_pUserModel.pPaymentModel.packageExpirationDate;
        self.m_lblDescription.text = g_pUserModel.pPaymentModel.packageDescription;
        self.m_lblAmount.text = [NSString stringWithFormat:@"$ %g", g_pUserModel.pPaymentModel.packagePrice];
/*
        for (int i = 0; i < self.m_arrPlans.count; i++)
        {
            CPaymentPlanModel* model = [self.m_arrPlans objectAtIndex:i];
            if (self.m_pCurrentModel.packagePrice > model.packagePrice)
            {
                [self.m_arrPlans removeObject:model];
                i = i - 1;
            }
        }
*/
        [self.m_cvPlan reloadData];
 
        if (g_nPrevState == TASKSTATE_LOGIN || g_nPrevState == TASKSTATE_SETTING_CONTACTUS)
        {
            [self onTimer];
        }
    }
    
    if (type == 2)  //Log out
    {
        if (g_pUserModel != nil)
            [g_pUserModel deleteAll];
        g_pUserModel = nil;
        
        //[CPreferenceManager saveEmail:nil];
        //[CPreferenceManager savePassword:nil];
        [CGlobal setState:TASKSTATE_SETTING_UPDATE nextState:TASKSTATE_SIGN];
        [CPreferenceManager saveState:TASKSTATE_SIGN];
 
        [self performSegueWithIdentifier: @"UPDATEACCOUNT_TO_SIGN" sender: self];
    }
    if (type == 3) {
        NSLog(@"promotion result %@", result);
        if (self.m_arrPromotionPlans != nil)
            [self.m_arrPromotionPlans removeAllObjects];
        [self.m_arrPromotionPlans addObjectsFromArray:result];
        g_arrPromotionPlans = self.m_arrPromotionPlans;
        [result removeAllObjects];
        result = nil;
        
        [self refreshCollectionWithPromotion];
    }
}

- (void)onTimer
{
    if (g_bPaid == false && g_nPrevState == TASKSTATE_SETTING_CONTACTUS)
        g_bIsPackageIdle = true;
  
    if (g_bIsPackageIdle == true)
    {
        [self.view addSubview:self.viewPopup];
        [self.view bringSubviewToFront:self.viewPopup];
        self.m_timerNotification = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
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
        if (type == 1)
        {
            self.m_pCurrentModel = nil;
            [self.m_cvPlan reloadData];
 
            self.m_lblPlan.text = @"";
            self.m_lblExpDate.text = @"";
        }

        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    g_bIsPackageIdle = false;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"segue name : %@", [segue identifier]);
    if ([[segue identifier] isEqualToString:@"UPDATEACCOUNT_TO_PROMOTIONCODE"])
    {
        //[CGlobal setState:TASKSTATE_SETTING_UPDATE nextState:TASKSTATE_SETTING_UPDATE_PROMOTION];
        //CPromotionCodeViewController* destController = [segue destinationViewController];
        //[destController setData:self.m_nSelectedIndex];
        [self.view addSubview:self.viewPromotion];
        [self.view bringSubviewToFront:self.viewPromotion];
    } else if ([[segue identifier] isEqualToString:@"UPDATEACCOUNT_TO_STRIPEPAYMENT"])
    {
        //[CGlobal setState:TASKSTATE_SETTING_UPDATE nextState:TASKSTATE_SETTING_UPDATE_STRIPE];
        CVCStripePaymentViewController* destController = [segue destinationViewController];
        [destController setData:self.m_pSelectedModel];
    } else if ([[segue identifier] isEqualToString:@"UPDATEACCOUNT_TO_CONTACTUS"])
    {
        [CGlobal setState:TASKSTATE_SETTING_UPDATE nextState:TASKSTATE_SETTING_CONTACTUS];
    }
}

- (void)refreshCollection
{
    if ([g_strEmail isEqualToString:@"nnnn@test.com11"])
    {
        [self refreshUserPlan];
        return;
    }
    [CGlobal showProgressHUD:self];
    [CServiceManager onGetSubscriptionPlans:self type:0];
}

- (void)refreshUserPlan
{
    [CGlobal showProgressHUD:self];
    [CServiceManager onGetUserPlan:self type:1];
}

- (void)refreshCollectionWithPromotion
{
    CPromotionInfoModel* model = [self.m_arrPromotionPlans objectAtIndex:0];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:model.message preferredStyle:UIAlertControllerStyleAlert];

    [self presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(dismissPopup) userInfo:nil repeats:NO];
    
    
    if (self.m_arrPlans != nil)
        [self.m_arrPlans removeAllObjects];
    
    for (int i = 0; i < self.m_arrPromotionPlans.count; i++)
    {
        CPaymentPlanModel* model = [[CPaymentPlanModel alloc] init];
        CPromotionInfoModel* promotion = [self.m_arrPromotionPlans objectAtIndex:i];
        model.packageID = promotion.packageID;
        model.packageDuration = promotion.packageDuration;
        model.packagePrice = promotion.packagePrice;
        model.packageTitle = promotion.packageTitle;
        model.packageDescription = promotion.packageDescription;
        model.packageDurationType = promotion.packageDurationType;
        model.promotionStatus = promotion.promotionStatus;
        model.promotionCode = promotion.promotionCode;

        [self.m_arrPlans addObject:model];
    }
    g_arrPlans = self.m_arrPlans;
    [self.m_cvPlan reloadData];
}

- (void)dismissPopup
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.m_arrPlans.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPaymentPlanCollectionViewCell *mCell = (CPaymentPlanCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_PLAN" forIndexPath:indexPath];
    
    CPaymentPlanModel* model = [self.m_arrPlans objectAtIndex:indexPath.row];
    [mCell setData:model];
    
    if ([model.promotionStatus isEqualToString:@"valid"])
    {
        mCell.m_lblPrice.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0f];
        mCell.m_lblPrice.font = [UIFont fontWithName:@"system-bold" size:13.0f];
    }
    
    mCell.m_viewCell.layer.borderWidth = 0.0;
    return mCell;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int nWidth = (self.m_cvPlan.frame.size.width - 8) / 2;
    int nHeight = (self.m_cvPlan.frame.size.height - 8) / 2;
    CGSize mElementSize = CGSizeMake(nWidth, nHeight);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPaymentPlanCollectionViewCell *datasetCell = (CPaymentPlanCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CPaymentPlanModel* model = [self.m_arrPlans objectAtIndex:indexPath.row];
    
    self.m_pSelectedModel = [self.m_arrPlans objectAtIndex:indexPath.row];
    
    if ([model.promotionStatus isEqualToString:@"valid"])
    {
        datasetCell.m_lblPrice.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0f];
        datasetCell.m_lblPrice.font = [UIFont fontWithName:@"system-bold" size:13.0f];
    }
    datasetCell.m_viewCell.layer.borderWidth = 4.0;
    datasetCell.m_viewCell.layer.borderColor = [UIColor colorWithRed:1.0 green:0.78 blue:0.6 alpha:1.0f].CGColor;
    
    self.m_btnUpgrade.hidden = FALSE;
    g_pUserModel.pSelectedPaymentModel = model;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CPaymentPlanCollectionViewCell *dataCell = (CPaymentPlanCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    CPaymentPlanModel* model = [self.m_arrPlans objectAtIndex:indexPath.row];
    
    dataCell.m_viewCell.layer.borderWidth = 0.0;
}

- (IBAction)onClickPromotionCode:(id)sender {

    [self.view addSubview:self.viewPromotion];
    [self.viewPromotion showInView:self.view animated:TRUE];
}


- (IBAction)onClickBack:(id)sender {
    
    if (g_nPrevState == TASKSTATE_LOGIN || g_nPrevState == TASKSTATE_SETTING_CONTACTUS)
    {        
        if (g_bPaid == true)
        {
            [CGlobal setState:TASKSTATE_SETTING_UPDATE nextState:TASKSTATE_LOGIN];
            [CPreferenceManager saveState:TASKSTATE_LOGIN];

            [self performSegueWithIdentifier: @"UPDATEACCOUNT_TO_SPLASH"
                                      sender: self];
        }
        else
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onLogout:self type:2];
        }
    }
    else
    {
        [self performSegueWithIdentifier: @"UPDATEACCOUNT_TO_SETTING"
                                  sender: self];
    }
}

- (IBAction)onClickUpgradeAccount:(id)sender {
    
}

- (void) onClickContactUs
{
    [CGlobal setState:TASKSTATE_SETTING_UPDATE nextState:TASKSTATE_SETTING_CONTACTUS];

    [self performSegueWithIdentifier: @"UPDATEACCOUNT_TO_CONTACTUS"
                              sender: self];
}

- (void)onClickPromotionCode
{
    [CGlobal showProgressHUD:self];
    NSString* code = self.viewPromotion.m_txtPromotionCode.text;
    [CServiceManager onGetPromotionCodeCheck:self type:3 code: code];
}

@end
