//
//  CFilterNutritionistViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CFilterNutritionistViewController.h"
#import "CGlobal.h"

@interface CFilterNutritionistViewController ()

@end

@implementation CFilterNutritionistViewController

@synthesize m_arrCountry, m_arrSelected, m_nCurSelectedIndex, m_arrSpeciality;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    m_arrCountry = @[NSLocalizedString(@"COUNTRY_ALL", @""),
//                     NSLocalizedString(@"COUNTRY_Algeria", @""),
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

    m_arrCountry = [NSMutableArray arrayWithArray:g_arrCountryFullName];
    [m_arrCountry insertObject:NSLocalizedString(@"COUNTRY_ALL", @"") atIndex:0];
    
    NSArray *arrSelected = @[@YES,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO,
                             @NO];
    
    m_arrSpeciality = @[NSLocalizedString(@"SPECIALITY_ALL", @""),
                        NSLocalizedString(@"SPECIALITY_PEDIATRIC", @""),
                        NSLocalizedString(@"SPECIALITY_DIABETIC", @""),
                        NSLocalizedString(@"SPECIALITY_CLINICAL", @""),
                        NSLocalizedString(@"SPECIALITY_SPORTS", @""),
                        NSLocalizedString(@"SPECIALITY_THERAPEUTIC", @""),
                        NSLocalizedString(@"SPECIALITY_HOLISTIC", @"")];

    m_arrSelected = [[NSMutableArray alloc] init];
    if (g_arrSpecialityFilter.count == m_arrSpeciality.count)
    {
        [m_arrSelected addObjectsFromArray:g_arrSpecialityFilter];
    }
    else
    {

        for (int i = 0; i < m_arrSpeciality.count; i++)
            [m_arrSelected addObject:@NO];
        m_arrSelected[0] = @YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
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
    if (tableView.tag == 1)
    {
        if (m_arrCountry != nil)
        {
            return m_arrCountry.count;
        }
        else
            return 0;
    }
    else
    {
        if (m_arrSpeciality != nil)
        {
            return m_arrSpeciality.count;
        }
        else
            return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelected:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        static NSString *CellIdentifier = @"CELL_FILTERNUT";
        UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
        if (m_ctlCell == nil)
        {
            m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel *lblCountry = (UILabel*)[m_ctlCell viewWithTag:1];
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];

        lblCountry.text = [m_arrCountry objectAtIndex:indexPath.row];

        if (m_nCurSelectedIndex == indexPath.row)
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
    else
    {
        static NSString *CellIdentifier = @"CELL_FILTERNUT";
        UITableViewCell *m_ctlCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (m_ctlCell == nil)
        {
            m_ctlCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        UILabel *lblCountry = (UILabel*)[m_ctlCell viewWithTag:1];
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];

        lblCountry.text = [m_arrSpeciality objectAtIndex:indexPath.row];
        
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
    if (tableView.tag == 1)
    {
        if (m_nCurSelectedIndex >= 0)
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:m_nCurSelectedIndex inSection:0];
            UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:path];
            UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
            UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
            viewMask.hidden = YES;
            ivChoose.hidden = YES;
     
        }

        UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
        [m_ctlCell setSelected:NO];

        //if (m_nCurSelectedIndex == indexPath.row)
        //    return;
 
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
        viewMask.hidden = NO;
        ivChoose.hidden = NO;
        m_nCurSelectedIndex = indexPath.row;
    }
    else
    {
        UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
        [m_ctlCell setSelected:NO];
     
        UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
        UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
        
        ivChoose.hidden = [[m_arrSelected objectAtIndex:indexPath.row] boolValue];
        viewMask.hidden = [[m_arrSelected objectAtIndex:indexPath.row] boolValue];
        m_arrSelected[indexPath.row]= @(![[m_arrSelected objectAtIndex:indexPath.row] boolValue]);
        
        if (indexPath.row == 0)
        {
            for (int i = 1; i < m_arrSelected.count; i++)
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:path];
                UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
                UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
                viewMask.hidden = YES;
                ivChoose.hidden = YES;
                m_arrSelected[i] = @NO;
            }
        }
        else
        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:path];
            UIImageView *ivChoose = (UIImageView*)[m_ctlCell viewWithTag:2];
            UIView *viewMask = (UIView*)[m_ctlCell viewWithTag:3];
            viewMask.hidden = YES;
            ivChoose.hidden = YES;
            m_arrSelected[0] = @NO;
        }
    }
}

- (IBAction)onClickCancel:(id)sender
{
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)onClickApply:(id)sender
{
    [g_arrSpecialityFilter removeAllObjects];
    [g_arrSpecialityFilter addObjectsFromArray:m_arrSelected];

    [m_arrSelected removeAllObjects];
    m_arrSelected = nil;

    
    id<CFilterNutritionistViewControllerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(onCountrySelected:didChooseIndex:didChooseCountry:)])
    {
        if (self.m_nCurSelectedIndex < 0)
            self.m_nCurSelectedIndex = 0;
        
        [strongDelegate onCountrySelected:self didChooseIndex:self.m_nCurSelectedIndex didChooseCountry:m_arrCountry[self.m_nCurSelectedIndex]];
    }


    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
