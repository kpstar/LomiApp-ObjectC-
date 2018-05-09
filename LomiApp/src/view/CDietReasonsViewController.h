//
//  CDietReasonsViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/1/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"

typedef NS_ENUM(NSInteger, SHOWMODE)
{
    MODE_SELECT   = 0,
    MODE_SHOW     = 1,
};

@interface CDietReasonsViewController : CUIViewController<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (strong, nonatomic) NSArray *m_arrDietReasons;
@property (strong, nonatomic) NSMutableArray *m_arrSelected;
@property (weak, nonatomic) IBOutlet UIView *m_viewBack;
@property (weak, nonatomic) IBOutlet UITableView *m_tableDiet;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIView *m_viewProgress;

@property NSInteger m_nCurSelectedIndex;

@property SHOWMODE m_nMode;

- (IBAction)onClickNext:(id)sender;

@end
