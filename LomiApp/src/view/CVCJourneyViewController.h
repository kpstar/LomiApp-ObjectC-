//
//  CVCJourneyViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "MBProgressHUD.h"
#import "FSCalendar.h"
#import "CGlobal.h"
#import "CMessageModel.h"


@interface CVCJourneyViewController : CUIViewController<FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintHeightOfCalendar;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeBreakfast;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeBreakfast;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeMorningsnack;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeMorningsnack;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeLunch;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeLunch;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeAfternoonsnack;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeAfternoonsnack;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeDinner;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeDinner;
@property (weak, nonatomic) IBOutlet UIView *m_viewBadgeEveningsnack;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadgeEveningsnack;

@property (weak, nonatomic) IBOutlet FSCalendar *m_ctlCalendar;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cvImage;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cvComments;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivJournalImage;
@property (weak, nonatomic) IBOutlet UIView *m_viewComment;

// Send Comments
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintHeightOfInputCollectionView;
@property (weak, nonatomic) IBOutlet UIView *m_viewInput;
@property (weak, nonatomic) IBOutlet UICollectionView *m_ctlInputCollection;
@property (weak, nonatomic) IBOutlet UITextView *m_tvInputText;
- (IBAction)onClickSend:(id)sender;


@property (strong, nonatomic) NSMutableArray *m_arrImage;
@property (strong, nonatomic) NSMutableArray *m_arrComment;
@property (strong, nonatomic) CMessageModel* m_pSelectedModel;
@property (weak, nonatomic) IBOutlet UILabel *m_lblNoComment;

@property   Boolean          bIsLoaded;

@property   NSInteger        m_nMealTypeID;
@property   NSString*        m_strDate;

- (IBAction)onClickBreakfast:(id)sender;
- (IBAction)onClickMorningsnack:(id)sender;
- (IBAction)onClickLunch:(id)sender;
- (IBAction)onClickAfternoonsnack:(id)sender;
- (IBAction)onClickDinner:(id)sender;
- (IBAction)onClickEveningsnack:(id)sender;
- (IBAction)onClickCommentView:(id)sender;

- (void)refreshJournalImage;
- (void)refreshBadge;

@end
