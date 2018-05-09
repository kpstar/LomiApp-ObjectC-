//
//  CSelectCountryViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 11/30/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"

@protocol CSelectCountryViewControllerDelegate;

@interface CSelectCountryViewController : CUIViewController<UITableViewDelegate>

@property (nonatomic, weak) id<CSelectCountryViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *m_tblCountry;
@property (strong, nonatomic) NSArray *m_arrCountry;
@property (strong, nonatomic) NSArray *m_arrCountryCode;

@property NSInteger m_nCurSelectedIndex;

- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end

@protocol CSelectCountryViewControllerDelegate <NSObject>

- (void)onCountrySelected:(CSelectCountryViewController*)viewController
           didChooseIndex:(NSInteger)index didChooseCountry:(NSString*)strValue;

@end
