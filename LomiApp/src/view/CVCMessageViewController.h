//
//  CVCMessageViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "MBProgressHUD.h"
#import "CGlobal.h"

@interface CVCMessageViewController : CUIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *m_viewPhotoSelect;
@property (weak, nonatomic) IBOutlet UITextView *m_tvInputText;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cvInputImage;
@property (weak, nonatomic) IBOutlet UICollectionView *m_cvMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintHeightOfInputCollectionView;
@property (strong, nonatomic) NSMutableArray *m_arrImages;
@property (strong, nonatomic) NSMutableArray *m_arrMessage;
@property   Boolean          bIsLoaded;

- (IBAction)onClickNewPhoto:(id)sender;
- (IBAction)onClickPhotoLibrary:(id)sender;
- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickSend:(id)sender;
- (IBAction)onClickCamera:(id)sender;

- (void)refreshMessage;
- (void)onAPISuccessExtend:(int)type result:(id) result extend:(id) extend;

@end
