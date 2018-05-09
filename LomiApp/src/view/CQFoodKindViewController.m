//
//  CQFoodKindViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CQFoodKindViewController.h"
#import "CGlobal.h"

@interface CQFoodKindViewController ()

@end

@implementation CQFoodKindViewController

@synthesize m_arrFoodKind, m_arrSelected, m_nMode;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"891-Oh-pF4.text", @"Main", @"");

    
    m_arrFoodKind = @[NSLocalizedString(@"QUESTIONARIES_FOODKIND_Vegetables", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Fishorotherseafood", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Chicken", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Redmeat", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Breadorothergrain", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Peanutsnuts", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Egg", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_MilkandDairy", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_FruitsVegetables", @""),
                      NSLocalizedString(@"QUESTIONARIES_FOODKIND_Nothing", @"")];
    
    m_arrSelected = [[NSMutableArray alloc] init];
    if (g_pUserModel.arrFoodKind.count == m_arrFoodKind.count)
    {
        [m_arrSelected addObjectsFromArray:g_pUserModel.arrFoodKind];
    }
    else
    {
        for (int i = 0; i < m_arrFoodKind.count; i++)
            [m_arrSelected addObject:@NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    for (int i = 0; i < g_arrNotificationForQuestionnaire.count; i++)
    {
        CNotificationModel* model = (CNotificationModel*)[g_arrNotificationForQuestionnaire objectAtIndex:i];
        [CServiceManager onSetReadNotification:nil type:1 notificationId:model.notificationId];
        model.bIsNew = false;
        
    }
    
    if (g_nPrevState == TASKSTATE_SIGNUP || g_nPrevState == TASKSTATE_NONE)
    {
        [CGlobal setState:TASKSTATE_REG_QUESTIONARIES nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveUserModel:g_pUserModel];
        [self performSegueWithIdentifier: @"QFOODKIND_TO_CHOOSENUT"
                                  sender: self];
    }
    else if (g_nPrevState == TASKSTATE_TAB_PROFILE)
    {
        [CGlobal setState:TASKSTATE_PROFILE_QUESTIONNAIRE nextState:TASKSTATE_TAB_PROFILE];
        [CPreferenceManager saveState:TASKSTATE_TAB_PROFILE];
        [CPreferenceManager saveUserModel:g_pUserModel];
        [self performSegueWithIdentifier: @"QFOODKIND_TO_TABPROFILE"
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


#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_arrFoodKind != nil)
    {
        return m_arrFoodKind.count;
    }
    else
        return 0;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelected:NO];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CELL_QFOODKIND";
    UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (m_ctlCell == nil)
    {
        m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UILabel *lblCountry = (UILabel*)[m_ctlCell viewWithTag:1];
    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
    UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
    
    lblCountry.text = [m_arrFoodKind objectAtIndex:indexPath.row];
    ivChoose.hidden = NO;
    
    if ([[m_arrSelected objectAtIndex:indexPath.row] boolValue]== YES)
    {
        viewMask.hidden = NO;
        ivChoose.hidden = NO;
    }
    else
    {
        viewMask.hidden = YES;
        ivChoose.hidden = YES;
    }
    return m_ctlCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
    [m_ctlCell setSelected:NO];

    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
    UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
    
    ivChoose.hidden = [[m_arrSelected objectAtIndex:indexPath.row] boolValue];
    viewMask.hidden = [[m_arrSelected objectAtIndex:indexPath.row] boolValue];
    m_arrSelected[indexPath.row]= @(![[m_arrSelected objectAtIndex:indexPath.row] boolValue]);
}

- (IBAction)onClickBack:(id)sender
{
    [g_pUserModel.arrFoodKind removeAllObjects];
    [g_pUserModel.arrFoodKind addObjectsFromArray:m_arrSelected];
    
    [m_arrSelected removeAllObjects];
    m_arrSelected = nil;
    
    [self performSegueWithIdentifier: @"QFOODKIND_TO_QWORK"
                              sender: self];
}

- (IBAction)onClickNext:(id)sender
{
    BOOL bHasOption = false;
    for (int i = 0; i < m_arrSelected.count; i++)
        if ([[m_arrSelected objectAtIndex:i] boolValue] == YES)
            bHasOption = true;
    if (bHasOption == false)
    {
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_CHOOSE_OPTION", @"") title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
        return;
    }
    
    [g_pUserModel.arrFoodKind removeAllObjects];
    [g_pUserModel.arrFoodKind addObjectsFromArray:m_arrSelected];
    
    [m_arrSelected removeAllObjects];
    m_arrSelected = nil;
    
    [CGlobal showProgressHUD:self];
    
    [CServiceManager onQuestioners:self type:0];

    /*
    [self performSegueWithIdentifier: @"QFOODKIND_TO_QOTHER"
                              sender: self];
     */
}
@end
