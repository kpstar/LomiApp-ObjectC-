//
//  CDietReasonsViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CDietReasonsViewController.h"
#import "CGlobal.h"

@interface CDietReasonsViewController ()

@end

@implementation CDietReasonsViewController

@synthesize m_arrDietReasons, m_arrSelected, m_nMode, m_nCurSelectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.m_tvDesc.text = NSLocalizedStringFromTable(@"afS-yz-zff.text", @"Main", @"");
    
    m_arrDietReasons = @[NSLocalizedString(@"QUESTIONARIES_DIETREASONS_WEIGHT", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_PREGNANT", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_DETOX", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_SPORTS", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_HIGH", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_BARIATRIC", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_DIABETES", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_HYPOTHYROIDISM", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_IRRITABLE", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_CANCER", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_URIC", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_HYPERTENSION", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_PEDIATRIC", @""),
                         NSLocalizedString(@"QUESTIONARIES_DIETREASONS_OTHER", @"")];

    m_arrSelected = [[NSMutableArray alloc] init];
    if (g_pUserModel.arrDietReasons.count == m_arrDietReasons.count)
    {
        [m_arrSelected addObjectsFromArray:g_pUserModel.arrDietReasons];
    }
    else
    {
        for (int i = 0; i < m_arrDietReasons.count; i++)
            [m_arrSelected addObject:@NO];
    }

    for (int i = 0; i < m_arrSelected.count; i++)
        if ([[m_arrSelected objectAtIndex:i] boolValue] == YES)
            m_nCurSelectedIndex = i;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (g_nPrevState == TASKSTATE_TAB_PROFILE)
    {
        self.m_viewBack.hidden = NO;
    }
    else
    {
        NSString* replacedStr = [self.m_lblTitle.text stringByReplacingOccurrencesOfString:@"(1/4)" withString:@""];
        CGRect frame = self.m_viewProgress.frame;
        frame.size.width = self.view.frame.size.width;
        
        [self.m_viewProgress setFrame:frame];
        self.m_lblTitle.text = replacedStr;
        self.m_viewBack.hidden = YES;
    }
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    if(g_nPrevState == TASKSTATE_TAB_PROFILE) {
        [self performSegueWithIdentifier: @"QDIETREASONS_TO_QSPORT"
                                  sender: self];
    }
    else {
        [self performSegueWithIdentifier: @"DIEDREASEON_TO_CHOOSENUT"
                                  sender: self];
    }
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"DIETREASONS_TO_PROFILE"])
    {
        [CGlobal setState:TASKSTATE_PROFILE_QUESTIONNAIRE nextState:TASKSTATE_TAB_PROFILE];
    }
    else if([[segue identifier] isEqualToString:@"DIEDREASEON_TO_CHOOSENUT"])
    {
        [CGlobal setState:TASKSTATE_REG_QUESTIONARIES nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        [CPreferenceManager saveUserModel:g_pUserModel];
    }
}



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
    if (m_arrDietReasons != nil)
    {
        if (m_nCurSelectedIndex == m_arrDietReasons.count - 1)
            return m_arrDietReasons.count + 1;
        else
            return m_arrDietReasons.count;
    }
    else
        return 0;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == m_arrDietReasons.count)
        return 130;
    else
        return 50;
}


- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelected:NO];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == m_arrDietReasons.count)
    {
        static NSString *CellIdentifier = @"CELL_DIETOTHER";
        UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (m_ctlCell == nil)
        {
            m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UITextView *tvDisease = (UITextView*)[m_ctlCell viewWithTag:2];
        if (g_pUserModel.strDiseases == nil || [g_pUserModel.strDiseases isEqual:[NSNull null]])
            tvDisease.text = @"";
        else
            tvDisease.text = g_pUserModel.strDiseases;
        UITextView *tvDiseaseText = (UITextView*)[m_ctlCell viewWithTag:1];
        tvDiseaseText.text = NSLocalizedString(@"TEXT_QUESTIONARIES_DIETREASONS_DISEASE", @"");
        
        return m_ctlCell;

    }
    else
    {
        static NSString *CellIdentifier = @"CELL_DIETREASONS";
        UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (m_ctlCell == nil)
        {
            m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
      
        UILabel *lblCountry = (UILabel*)[m_ctlCell viewWithTag:1];
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
        
        lblCountry.text = [m_arrDietReasons objectAtIndex:indexPath.row];
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
    [m_ctlCell setSelected:NO];

    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
    UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
    
    ivChoose.hidden = [[m_arrSelected objectAtIndex:indexPath.row] boolValue];
    viewMask.hidden = [[m_arrSelected objectAtIndex:indexPath.row] boolValue];
    m_arrSelected[indexPath.row]= @(![[m_arrSelected objectAtIndex:indexPath.row] boolValue]);
    */
    
    if (indexPath.row == m_arrDietReasons.count)
        return;
    
    if (m_nCurSelectedIndex >= 0)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:m_nCurSelectedIndex inSection:0];
        UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:path];
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
        ivChoose.hidden = YES;
        viewMask.hidden = YES;
        
        m_arrSelected[m_nCurSelectedIndex] = @NO;
    }
    
    UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
    [m_ctlCell setSelected:NO];
    
    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
    ivChoose.hidden = NO;
    UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
    viewMask.hidden = NO;
    m_arrSelected[indexPath.row] = @YES;
    
    if (m_nCurSelectedIndex == m_arrDietReasons.count - 1)
    {
        m_nCurSelectedIndex = indexPath.row;
        [tableView reloadData];
        return;
    }
    
    m_nCurSelectedIndex = indexPath.row;
    
    if (m_nCurSelectedIndex == m_arrDietReasons.count - 1)
    {
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:m_arrDietReasons.count inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
    
    [g_pUserModel.arrDietReasons removeAllObjects];
    [g_pUserModel.arrDietReasons addObjectsFromArray:m_arrSelected];
    if (m_nCurSelectedIndex == m_arrSelected.count - 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:m_arrSelected.count inSection:0];
        UITableViewCell *m_ctlCell = [self.m_tableDiet cellForRowAtIndexPath:indexPath];
        UITextView *tvDisease = (UITextView*)[m_ctlCell viewWithTag:2];
        g_pUserModel.strDiseases = tvDisease.text;
    }
    
    [m_arrSelected removeAllObjects];
    m_arrSelected = nil;

    [CGlobal showProgressHUD:self];
    [CServiceManager onQuestioners:self type:0];
}
@end
