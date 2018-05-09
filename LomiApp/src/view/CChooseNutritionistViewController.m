//
//  CChooseNutritionistViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CChooseNutritionistViewController.h"
#import "CNutritionistCollectionViewCell.h"
#import "CNutritionistTableViewCell.h"
#import "CServiceManager.h"
#import "CGlobal.h"
#import "CNutSearchModel.h"
#import "CIndividualNutritionistViewController.h"

#define MODE_ALL     0
#define MODE_SEARCH  1

@interface CChooseNutritionistViewController ()

@end

@implementation CChooseNutritionistViewController

@synthesize m_arrNutritionist, m_arrNutritionistSearch, m_pSelectedModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"m8I-8q-jeO.text", @"Main", @"");

    [self.m_cvNutritionist registerNib:[UINib nibWithNibName:@"CNutritionistCollectionView" bundle:nil] forCellWithReuseIdentifier:@"CELL_NUTRITIONIST"];
    
    [self.searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"CNutritionistTableCell" bundle:nil] forCellReuseIdentifier:@"CELL_NUT"];
    
    self.searchBar.delegate = self;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:(245.0f / 255) green:(245.0f / 255) blue:(245.0f / 255) alpha:1];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self refreshCollection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshCollection
{
    [CGlobal showProgressHUD:self];
    
    NSInteger nCountryIndex = [CGlobal countryIndexFromCode:g_pUserModel.strCountryCode];
    CNutSearchModel* model = [[CNutSearchModel alloc] init];
    model.offset = @"";
    model.pageID = @"";
    model.itemPerPage = @"";
    model.search_text = @"";
    model.order = @"";
    model.specialities = @"";

    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    if ([strLan isEqualToString:@"ar"])
    {
        model.language = @"483";
    }
    else
    {
        model.language = @"484";
    }
    
    if (nCountryIndex == 2) //if Canada
        model.countryValue = g_arrNutCountryCode[nCountryIndex];
    else
        model.countryValue = @"";

    [CServiceManager onGetAllNutritionists:self type:MODE_ALL model:model];
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [CGlobal hideProgressHUD:self];

    if (type == MODE_ALL)
    {
        [m_arrNutritionist removeAllObjects];
        m_arrNutritionist = nil;

        BOOL bHasFree = false;
        m_arrNutritionist = result;
     
        if (m_arrNutritionist != nil && m_arrNutritionist.count > 0)
        {
            m_arrNutritionist = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                CNutritionistModel* pFirst = (CNutritionistModel*)obj1;
                CNutritionistModel* pSecond = (CNutritionistModel*)obj2;
                if (pFirst.recommended == YES && pFirst.fullybooked == NO)
                    return false;
                else if (pSecond.recommended == YES && pSecond.fullybooked == NO)
                {
                    return true;
                }
                else if (pFirst.recommended == NO && pFirst.fullybooked == NO)
                    return false;
                else if (pFirst.recommended == NO && pSecond.fullybooked == NO)
                    return true;
                else
                    return false;
            }]];
            
            /*
            m_arrNutritionist = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
             
                CNutritionistModel* pFirst = (CNutritionistModel*)obj1;
                CNutritionistModel* pSecond = (CNutritionistModel*)obj2;
                
                if (pFirst.fullybooked == YES && pFirst.recommended == YES)
                    return true;
                else
                {
                    return false;
                }
                return 0;
            }]];
             */
            
            CNutritionistModel *temp = [m_arrNutritionist objectAtIndex:0];
            if (temp.fullybooked != TRUE)
                bHasFree = true;
        }
        [self.m_cvNutritionist reloadData];
        
        if (m_arrNutritionist == nil || m_arrNutritionist.count == 0 || bHasFree == false)
        {
            [self showCloseAlert];
        }
    }
    else if (type == MODE_SEARCH)
    {
        [m_arrNutritionistSearch removeAllObjects];
        m_arrNutritionistSearch = nil;
        
        m_arrNutritionistSearch = result;
        if (m_arrNutritionistSearch != nil || m_arrNutritionistSearch.count > 0)
        {
            m_arrNutritionistSearch = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
                CNutritionistModel* pFirst = (CNutritionistModel*)obj1;
                CNutritionistModel* pSecond = (CNutritionistModel*)obj2;
                if (pFirst.recommended == YES && pFirst.fullybooked == NO)
                    return false;
                else if (pSecond.recommended == YES && pSecond.fullybooked == NO)
                {
                    return true;
                }
                else if (pFirst.recommended == NO && pFirst.fullybooked == NO)
                    return false;
                else if (pFirst.recommended == NO && pSecond.fullybooked == NO)
                    return true;
                else
                    return false;
            }]];
            /*
            m_arrNutritionistSearch = [NSMutableArray arrayWithArray:[result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         
                CNutritionistModel* pFirst = (CNutritionistModel*)obj1;
                CNutritionistModel* pSecond = (CNutritionistModel*)obj2;
                if (pFirst.fullybooked == NO)
                    return false;
                else
                {
                    if(pSecond.fullybooked == NO)
                        return true;
                    else
                        return false;
                }
                return true;
            }]];
            */
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)showCloseAlert
{
    
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_SORRY", @"")
                                      message:NSLocalizedString(@"ALERT_MESSAGE_CHOOSENUT_NOFREE", @"")
                                      preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_CLOSE", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
         
            //do something when click button
            exit(0);

        }];
        [alert addAction:yesAction];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_TRY", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
            //do something when click button
            
        }];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [CGlobal hideProgressHUD:self];
    
    if (result == nil)
    {
        [CGlobal showNetworkErrorAlertWithYesNo:self type:type];
    }
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlertWithYesNo:self type:type message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

- (void)onAlertYES:(int)type
{
    
    if (type == MODE_ALL)
    {
        [self refreshCollection];
    }
    else if (type == MODE_SEARCH)
    {
        [self searchTableList];
    }
}

- (void)onAlertNO:(int)type
{
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"CHOOSENUT_TO_INDIVNUT"])
    {
        CIndividualNutritionistViewController* destController = [segue destinationViewController];
        if (m_pSelectedModel != nil)
            [destController initModel:m_pSelectedModel];
    }
    else if ([[segue identifier] isEqualToString:@"CHOOSENUT_TO_FILTERNUT"])
    {
        [self.searchDisplayController setActive:NO];
        CFilterNutritionistViewController* destController = [segue destinationViewController];
        //destController.m_nCurSelectedIndex = m_nCurCountry;
        destController.delegate = self;
    }
}

- (void)onCountrySelected:(CFilterNutritionistViewController*)viewController
           didChooseIndex:(NSInteger)index didChooseCountry:(NSString*)strValue
{
    [CGlobal showProgressHUD:self];
 
    NSInteger nCountryIndex = index - 1;
    CNutSearchModel* model = [[CNutSearchModel alloc] init];
    model.offset = @"";
    model.pageID = @"";
    model.itemPerPage = @"";
    model.search_text = @"";
    model.order = @"";
    
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    if ([strLan isEqualToString:@"ar"])
    {
        model.language = @"483";
    }
    else
    {
        model.language = @"484";
    }
 
    if (g_arrSpecialityFilter.count != 0 && [g_arrSpecialityFilter[0] boolValue] != YES)
    {
        NSMutableArray *arrSpecialities = [NSMutableArray array];
        for (int i = 1; i < g_arrSpecialityFilter.count; i++)
        {
            if ([g_arrSpecialityFilter[i] boolValue] == YES)
            {
                [arrSpecialities addObject:g_arrSpecialityFilterValue[i - 1]];
            }
        }
        NSString* strSpecialities = [arrSpecialities componentsJoinedByString:@","];
        model.specialities = strSpecialities;
    }
    else
        model.specialities = @"";
    
    NSInteger nUserCountryIndex = [CGlobal countryIndexFromCode:g_pUserModel.strCountryCode];
    if (nUserCountryIndex == 2) //if Canada
        model.countryValue = g_arrNutCountryCode[nUserCountryIndex];
    else
    {
        if (nCountryIndex != -1) //if not All Country
        {
            model.countryValue = g_arrNutCountryCode[nCountryIndex];
        }
        else
            model.countryValue = @"";
    }
    [CServiceManager onGetAllNutritionists:self type:MODE_ALL model:model];
}


#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return m_arrNutritionist.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CNutritionistCollectionViewCell *mCell = (CNutritionistCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_NUTRITIONIST" forIndexPath:indexPath];
    
    CNutritionistModel* model = [m_arrNutritionist objectAtIndex:indexPath.row];
    [mCell setData:model];
 
    if (indexPath.row % 3 == 1)
        [mCell setTopConstraint:40];
    else
        [mCell setTopConstraint:0];
    
    mCell.backgroundColor = [UIColor lightGrayColor];

    return mCell;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    int nWidth = (self.m_cvNutritionist.frame.size.width - 48) / 3;
    CGSize mElementSize = CGSizeMake(nWidth, nWidth * 2);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8,8,8,8);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    m_pSelectedModel = [m_arrNutritionist objectAtIndex:indexPath.row];

    [self performSegueWithIdentifier: @"CHOOSENUT_TO_INDIVNUT"
                              sender: self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return m_arrNutritionistSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CELL_NUT";
 
    CNutritionistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CNutritionistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.backgroundColor = [UIColor colorWithRed:(245.0f / 255) green:(245.0f / 255) blue:(245.0f / 255) alpha:1];
    
    CNutritionistModel* model = [m_arrNutritionistSearch objectAtIndex:indexPath.row];
    [cell setData:model];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *m_ctlCell = [tableView cellForRowAtIndexPath:indexPath];
    [m_ctlCell setSelected:NO];
    
    m_pSelectedModel = [m_arrNutritionistSearch objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"CHOOSENUT_TO_INDIVNUT"
                              sender: self];
//    [self.searchDisplayController setActive:NO];
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelected:NO];
}

- (void)searchTableList
{
    [CGlobal showProgressHUD:self];
    
    //NSInteger nCountryIndex = [CGlobal countryIndexFromCode:g_pUserModel.strCountryCode];
 
    CNutSearchModel* model = [[CNutSearchModel alloc] init];
    model.offset = @"";
    model.pageID = @"";
    model.itemPerPage = @"";
    model.search_text = self.searchBar.text;
    model.order = @"";
    model.specialities = @"";
    
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    if ([strLan isEqualToString:@"ar"])
    {
        model.language = @"483";
    }
    else
    {
        model.language = @"484";
    }
//    if (nCountryIndex == 2) //if Canada
//        model.countryValue = g_arrNutCountryCode[nCountryIndex];
//    else
        model.countryValue = @"";
    //model.countryValue = g_arrNutCountryCode[nCountryIndex];

    [CServiceManager onGetAllNutritionists:self type:MODE_SEARCH model:model];
}

#pragma mark - Search Implementation

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [m_arrNutritionistSearch removeAllObjects];
    m_arrNutritionistSearch = nil;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchTableList];
}
@end
