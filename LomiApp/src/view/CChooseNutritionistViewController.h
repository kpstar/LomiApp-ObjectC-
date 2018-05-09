//
//  CChooseNutritionistViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CNutritionistModel.h"
#import "CFilterNutritionistViewController.h"

@interface CChooseNutritionistViewController : CUIViewController<UICollectionViewDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, CFilterNutritionistViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *m_cvNutritionist;


@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (strong, nonatomic) NSMutableArray *m_arrNutritionist;
@property (strong, nonatomic) NSMutableArray *m_arrNutritionistSearch;
@property (strong, nonatomic) CNutritionistModel* m_pSelectedModel;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;

- (void)onAlertYES:(int)type;
- (void)onAlertNO:(int)type;

@end
