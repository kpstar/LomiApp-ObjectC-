//
//  CQWorkViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CQWorkViewController.h"
#import "CGlobal.h"

@interface CQWorkViewController ()

@end

@implementation CQWorkViewController

@synthesize m_arrWork, m_arrSelected, m_nMode, m_nCurSelectedIndex;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.m_tvDesc.text = NSLocalizedStringFromTable(@"IP2-qc-dg6.text", @"Main", @"");

    m_arrWork = @[NSLocalizedString(@"QUESTIONARIES_WORK_Fieldwork", @""),
                  NSLocalizedString(@"QUESTIONARIES_WORK_Officework", @""),
                  NSLocalizedString(@"QUESTIONARIES_WORK_Wifehouse", @""),
                  NSLocalizedString(@"QUESTIONARIES_WORK_Dontwork", @""),
                  NSLocalizedString(@"QUESTIONARIES_WORK_Activitywork", @"")];
 
    m_arrSelected = [[NSMutableArray alloc] init];
    if (g_pUserModel.arrWork.count == m_arrWork.count)
    {
        [m_arrSelected addObjectsFromArray:g_pUserModel.arrWork];
    }
    else
    {
        for (int i = 0; i < m_arrWork.count; i++)
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

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
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
    if (m_arrWork != nil)
    {
        return m_arrWork.count;
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
    static NSString *CellIdentifier = @"CELL_QWORK";
    UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (m_ctlCell == nil)
    {
        m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    UILabel *lblCountry = (UILabel*)[m_ctlCell viewWithTag:1];
    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
    UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
    
    lblCountry.text = [m_arrWork objectAtIndex:indexPath.row];
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
    
    m_nCurSelectedIndex = indexPath.row;
}


- (IBAction)onClickBack:(id)sender
{
    [g_pUserModel.arrWork removeAllObjects];
    [g_pUserModel.arrWork addObjectsFromArray:m_arrSelected];

    [m_arrSelected removeAllObjects];
    m_arrSelected = nil;
    
    [self performSegueWithIdentifier: @"QWORK_TO_QSPORT"
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
    
    [g_pUserModel.arrWork removeAllObjects];
    [g_pUserModel.arrWork addObjectsFromArray:m_arrSelected];

    [m_arrSelected removeAllObjects];
    m_arrSelected = nil;
    
    [self performSegueWithIdentifier: @"QWORK_TO_QFOODKIND"
                              sender: self];

}
@end
