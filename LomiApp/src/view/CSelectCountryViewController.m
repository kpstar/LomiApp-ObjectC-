//
//  CSelectCountryViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 11/30/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CSelectCountryViewController.h"
#import "CVCProfileEditViewController.h"
#import "CGlobal.h"

@interface CSelectCountryViewController ()

@end

@implementation CSelectCountryViewController

@synthesize m_arrCountry, m_arrCountryCode, m_nCurSelectedIndex, m_tblCountry;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Countries

    m_arrCountry = [NSArray arrayWithArray:g_arrCountryFullName];
  
//  @[NSLocalizedString(@"COUNTRY_Algeria", @""),
//                     NSLocalizedString(@"COUNTRY_Bahrain", @""),
//                     NSLocalizedString(@"COUNTRY_Canada", @""),
//                     NSLocalizedString(@"COUNTRY_Egypt", @""),
//                     NSLocalizedString(@"COUNTRY_Jordan", @""),
//                     NSLocalizedString(@"COUNTRY_Kuwait", @""),
//                     NSLocalizedString(@"COUNTRY_Lebanon", @""),
//                     NSLocalizedString(@"COUNTRY_Libya", @""),
//                     NSLocalizedString(@"COUNTRY_Morocco", @""),
//                     NSLocalizedString(@"COUNTRY_Oman", @""),
//                     NSLocalizedString(@"COUNTRY_Qatar", @""),
//                     NSLocalizedString(@"COUNTRY_SaudiArabia", @""),
//                     NSLocalizedString(@"COUNTRY_Sudan", @""),
//                     NSLocalizedString(@"COUNTRY_Syria", @""),
//                     NSLocalizedString(@"COUNTRY_Tunisia", @""),
//                     NSLocalizedString(@"COUNTRY_Turkey", @""),
//                     NSLocalizedString(@"COUNTRY_UnitedArabEmirates", @""),
//                     NSLocalizedString(@"COUNTRY_UnitedKingdom", @""),
//                     NSLocalizedString(@"COUNTRY_UnitedStates", @""),
//                     NSLocalizedString(@"COUNTRY_Yemen", @"")];
//        
    //m_nCurSelectedIndex = 0;
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

- (IBAction)onClickDone:(id)sender
{
    id<CSelectCountryViewControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onCountrySelected:didChooseIndex:didChooseCountry:)])
    {
        if (m_nCurSelectedIndex < 0)
            m_nCurSelectedIndex = 0;
        
        [strongDelegate onCountrySelected:self didChooseIndex:m_nCurSelectedIndex didChooseCountry:m_arrCountry[m_nCurSelectedIndex]];
    }
    if ([self.delegate isKindOfClass:[CVCProfileEditViewController class]])
    {
        [[self view] endEditing:YES];
        [self.view removeFromSuperview];
        return;
    }
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickCancel:(id)sender
{
    if ([self.delegate isKindOfClass:[CVCProfileEditViewController class]])
    {
        [[self view] endEditing:YES];
        [self.view removeFromSuperview];
        return;
    }
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    if (m_arrCountry != nil)
    {
        return m_arrCountry.count;
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
    static NSString *CellIdentifier = @"CELL_SELECTCOUNTRY";
    UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (m_ctlCell == nil)
    {
        m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *lblCountry = (UILabel*)[m_ctlCell viewWithTag:1];
    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];

    lblCountry.text = [m_arrCountry objectAtIndex:indexPath.row];
    ivChoose.hidden = YES;
    
    if (m_nCurSelectedIndex == indexPath.row)
        ivChoose.hidden = NO;
    
    return m_ctlCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_nCurSelectedIndex >= 0)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:m_nCurSelectedIndex inSection:0];
        UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:path];
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        ivChoose.hidden = YES;
    }
    
    UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
    [m_ctlCell setSelected:NO];
    
    //if (m_nCurSelectedIndex == indexPath.row)
    //    return;
    
    UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
    ivChoose.hidden = NO;
    m_nCurSelectedIndex = indexPath.row;

}


@end
