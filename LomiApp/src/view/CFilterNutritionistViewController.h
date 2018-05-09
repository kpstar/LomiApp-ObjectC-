//
//  CFilterNutritionistViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/2/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"

@protocol CFilterNutritionistViewControllerDelegate;

@interface CFilterNutritionistViewController : CUIViewController<UITableViewDelegate>

@property (nonatomic, weak) id<CFilterNutritionistViewControllerDelegate> delegate;

@property (strong, nonatomic) NSArray *m_arrSpeciality;
@property (strong, nonatomic) NSMutableArray *m_arrCountry;
@property (strong, nonatomic) NSMutableArray *m_arrSelected;
@property NSInteger m_nCurSelectedIndex;

- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickApply:(id)sender;

@end

@protocol CFilterNutritionistViewControllerDelegate <NSObject>

- (void)onCountrySelected:(CFilterNutritionistViewController*)viewController
           didChooseIndex:(NSInteger)index didChooseCountry:(NSString*)strValue;
@end
