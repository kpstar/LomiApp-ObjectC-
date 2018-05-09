//
//  CQFoodKindViewController.h
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


@interface CQFoodKindViewController : CUIViewController<UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *m_tvDesc;
@property (strong, nonatomic) NSArray *m_arrFoodKind;
@property (strong, nonatomic) NSMutableArray *m_arrSelected;

@property SHOWMODE m_nMode;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickNext:(id)sender;

@end
