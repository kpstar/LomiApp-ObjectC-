//
//  CVCJournalOneViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/14/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "MBProgressHUD.h"
#import "CGlobal.h"

@interface CVCJournalOneViewController : CUIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *m_viewPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDate;
@property (weak, nonatomic) IBOutlet UIView *m_viewPhotoSelect;
@property (weak, nonatomic) IBOutlet UITextView *m_tvInputText;
@property (weak, nonatomic) IBOutlet UICollectionView *m_ctlInputCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *m_ctlJournalCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintHeightOfInputCollectionView;
@property (weak, nonatomic) IBOutlet UIView *m_viewInput;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivCamera;

- (IBAction)onClickSend:(id)sender;
- (IBAction)onClickCamera:(id)sender;

@property   NSInteger        m_nMealTypeID;
@property   NSString*        m_strDate;
@property   NSArray*         arrMealType;
@property   NSString*        m_strPublicPhotoId;

@property (strong, nonatomic) NSMutableArray *m_arrImages;
@property (strong, nonatomic) NSMutableArray *m_arrJournal;
@property (strong, nonatomic) NSMutableArray *m_arrPhotos;

@property   Boolean         bIsLoaded;

- (IBAction)onClickPhotoNew:(id)sender;
- (IBAction)onClickPhotoLibrary:(id)sender;
- (IBAction)onClickPhotoCancel:(id)sender;


@end
