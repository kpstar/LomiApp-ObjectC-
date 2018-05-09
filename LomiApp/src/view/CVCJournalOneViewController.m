//
//  CVCJournalOneViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/14/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCJournalOneViewController.h"
#import "CInputImageCollectionViewCell.h"
#import "CMyMessageViewCell.h"
#import "CNutritionistMessageViewCell.h"
#import "CMyImageCollectionViewCell.h"
#import "CMessageModel.h"
#import "CJournalSearchModel.h"
#import "UIView+RoundedCorners.h"

@interface CVCJournalOneViewController ()

@end

@implementation CVCJournalOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.arrMealType = @[
                        NSLocalizedString(@"STR_BREAKFAST", @""),
                        NSLocalizedString(@"STR_LUNCH", @""),
                        NSLocalizedString(@"STR_DINNER", @""),
                        NSLocalizedString(@"STR_MSNACK", @""),
                        NSLocalizedString(@"STR_ASNACK", @""),
                        NSLocalizedString(@"STR_ESNACK", @"")];

    [self.m_ctlInputCollectionView registerNib:[UINib nibWithNibName:@"CInputImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_INPUTIMAGE"];
    
    [self.m_ctlJournalCollectionView registerNib:[UINib nibWithNibName:@"CNutritionistMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_NUTMESSAGE"];
    [self.m_ctlJournalCollectionView registerNib:[UINib nibWithNibName:@"CMyMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_MYMESSAGE"];
    [self.m_ctlJournalCollectionView registerNib:[UINib nibWithNibName:@"CMyImageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_MYIMAGE"];
    
    self.m_arrJournal = [[NSMutableArray alloc] init];
    self.m_arrPhotos = [[NSMutableArray alloc] init];

    self.m_constraintHeightOfInputCollectionView.constant = 0;
    [self.m_ctlInputCollectionView setHidden:YES];
    [self.m_ctlInputCollectionView setNeedsLayout];
    
    self.m_strPublicPhotoId = nil;
    
    self.bIsLoaded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.m_lblDate.text = self.m_strDate;
    self.m_lblTitle.text = self.arrMealType[self.m_nMealTypeID - 1];
    

    if (self.bIsLoaded)
        return;
    self.bIsLoaded = YES;

    [CGlobal showProgressHUD:self];
    
    CJournalSearchModel *model = [[CJournalSearchModel alloc] init];
    model.date = self.m_strDate;
    model.approval = @"";//@"true";
    model.mealTypeId = [NSString stringWithFormat:@"%ld", (long)self.m_nMealTypeID];
    [CServiceManager onGetApprovedPhotos:self type:0 model:model];
    //[CServiceManager onGetUserPhotos:self type:0 model:model];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.m_viewPhotoSelect setHidden:YES];
    //self.bIsLoaded = NO;
}

- (void)viewDidLayoutSubviews
{

}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
//    [CGlobal hideProgressHUD:self];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (type == 0)  //photo list
    {
        if (self.m_arrPhotos != nil)
            [self.m_arrPhotos removeAllObjects];
        if (self.m_arrJournal != nil)
            [self.m_arrJournal removeAllObjects];
        
        [self.m_arrPhotos addObjectsFromArray:result];
        [result removeAllObjects];
        result = nil;
        
        if (self.m_arrPhotos.count != 0)
        {
            [self.m_arrJournal addObject:self.m_arrPhotos[0]];
            CMessageModel* message = self.m_arrPhotos[0];
            
            self.m_strPublicPhotoId = [NSString stringWithFormat:@"%ld", (long)message.photoId];
            
            CJournalSearchModel* model = [[CJournalSearchModel alloc] init];
            model.photoId = [NSString stringWithFormat:@"%ld", (long)message.photoId];
     
            [CGlobal showProgressHUD:self];
            [CServiceManager onGetComments:self type:1 model:model];
        }
    }
    else if (type == 1) //get comment
    {
        
        [self.m_arrJournal addObjectsFromArray:result];
        [result removeAllObjects];
        result = nil;
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
        if (self.m_arrJournal.count != 0)
            [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        if (self.m_arrPhotos.count != 0)
            [self.m_arrPhotos removeObjectAtIndex:0];

        if (self.m_arrPhotos.count != 0)
        {
        
            [self.m_arrJournal addObject:self.m_arrPhotos[0]];
            CMessageModel* message = self.m_arrPhotos[0];
            self.m_strPublicPhotoId = [NSString stringWithFormat:@"%ld", (long)message.photoId];

            CJournalSearchModel* model = [[CJournalSearchModel alloc] init];
            model.photoId = [NSString stringWithFormat:@"%ld", (long)message.photoId];
            
            [CGlobal showProgressHUD:self];
            [CServiceManager onGetComments:self type:1 model:model];
        }
    }
    else if (type == 2) //post photo
    {
        CJournalSearchModel* model = result;
        self.m_strPublicPhotoId = model.photoId;
        
        CMessageModel* journalModel = self.m_arrJournal[model.indexOfPhoto];
        journalModel.url = model.url;
        journalModel.photoId = model.nPhotoId;
        
        if (model.hasComment == YES)
        {
            [CGlobal showProgressHUD:self];
            [CServiceManager onPostComments:self type:4 model:model];
        }
        else
        {
            [self.m_arrImages removeObjectAtIndex:0];
            [self.m_ctlInputCollectionView reloadData];
            [self refreshInputView];
            
            [self.m_ctlJournalCollectionView reloadData];
            [self refreshCollectionView];
            if (self.m_arrJournal.count != 0)
                [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            
            [self sendPhotoAndMessage];
        }
    }
    else if (type == 3) //post comment
    {
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
        if (self.m_arrJournal.count != 0)
            [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
 
        self.m_tvInputText.text = @"";
        [self.m_tvInputText setNeedsLayout];
    }
    else if (type == 4) //post photo->message
    {
        if (self.m_arrJournal.count != 0)
            [self.m_arrImages removeObjectAtIndex:0];
        [self.m_ctlInputCollectionView reloadData];
        [self refreshInputView];
        
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
        if (self.m_arrJournal.count != 0)
            [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
     
        [self sendPhotoAndMessage];

    }
    
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
//    [CGlobal hideProgressHUD:self];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if (type == 0)  //photo list
    {
        self.m_strPublicPhotoId = nil;
     
        if ([result isKindOfClass:[NSString class]])
        {
            [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        }
    }
    else if (type == 1) //get comment
    {
        self.m_strPublicPhotoId = nil;
     
        [self.m_arrJournal removeAllObjects];
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
    }
    else if (type == 2) //post photo
    {
        self.m_strPublicPhotoId = nil;
 
        CJournalSearchModel* model = result;

        [self.m_arrJournal removeObjectAtIndex:model.indexOfPhoto];
        if (model.hasComment == YES)
            [self.m_arrJournal removeObjectAtIndex:model.indexOfComment - 1];
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
        if (self.m_arrJournal.count != 0)
            [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else if (type == 3) //post comment
    {
        CJournalSearchModel* model = result;

        [self.m_arrJournal removeObjectAtIndex:model.indexOfComment];
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
        if (self.m_arrJournal.count != 0)
            [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else if (type == 4) //post photo->message
    {
        CJournalSearchModel* model = result;
 
        [self.m_arrJournal removeObjectAtIndex:model.indexOfComment];
        [self.m_ctlJournalCollectionView reloadData];
        [self refreshCollectionView];
        if (self.m_arrJournal.count != 0)
            [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }

    CJournalSearchModel* model = result;
    if (model.strMessage == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([model.strMessage isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [[self view] endEditing:YES];
    if ([[segue identifier] isEqualToString:@"JOURNALVIEW_TO_JOURNAL"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_JOURNAL" object:nil];
    }

}


#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1)
    {
        return self.m_arrJournal.count;
    }
    else if (collectionView.tag == 2)
    {
        return self.m_arrImages.count;
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1)
    {
        CMessageModel* model = self.m_arrJournal[indexPath.row];
        
        if (model.isImage)
        {
            CMyImageCollectionViewCell *mCell = (CMyImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_MYIMAGE" forIndexPath:indexPath];
            [mCell setNeedsLayout];
            [mCell layoutIfNeeded];
            [mCell setData:model];
            return mCell;
        }
        else
        {
//            NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
//            if (![model.username isEqualToString:strName])
            {
                CNutritionistMessageViewCell *mCell = (CNutritionistMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_NUTMESSAGE" forIndexPath:indexPath];
                [mCell setNeedsLayout];
                [mCell layoutIfNeeded];
                [mCell setData:model];
                return mCell;
            }
//            else
//            {
//                CMyMessageViewCell *mCell = (CMyMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_MYMESSAGE" forIndexPath:indexPath];
//                [mCell setNeedsLayout];
//                [mCell layoutIfNeeded];
//                [mCell setData:model];
//                return mCell;
//            }
        }
    }
    else if (collectionView.tag == 2)
    {
        CInputImageCollectionViewCell *mCell = (CInputImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_INPUTIMAGE" forIndexPath:indexPath];
        
        mCell.m_ivImage.image = nil;
        mCell.m_ivImage.image = self.m_arrImages[indexPath.row];
//        mCell.backgroundColor = [UIColor lightGrayColor];
        
        
        return mCell;
    }
    return nil;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1)
    {
        CMessageModel* model = self.m_arrJournal[indexPath.row];
        
        if (model.isImage)
        {
            CGFloat nWidth = self.m_ctlJournalCollectionView.frame.size.width;
            CGFloat fRate = 3 / 2;
            if (model.image != nil)
            {
                fRate = model.image.size.width / model.image.size.height;
            }
            else
            {
                NSURL *URL = [NSURL URLWithString:model.url];
                NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
                UIImage *image = [[UIImage alloc]initWithData:data];
                fRate = image.size.width / image.size.height;
            }
            
            CGFloat nHeight = (nWidth - 90) / fRate;
            CGSize mElementSize = CGSizeMake(nWidth, nHeight + 24);
            return mElementSize;
        }
        else
        {
//            NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
//            if (![model.username isEqualToString:strName])
            
            {
                CNutritionistMessageViewCell * cell = (CNutritionistMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
                
                if (cell == nil) {
                    
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CNutritionistMessageViewCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                [cell setData:model];
                
                CGFloat nWidth = self.m_ctlJournalCollectionView.frame.size.width;
                CGFloat nHeight = [cell.m_tvMessage sizeThatFits:CGSizeMake(nWidth - 90, CGFLOAT_MAX)].height;
                CGSize mElementSize = CGSizeMake(nWidth, nHeight + 52);
                return mElementSize;
            }
//            else
//            {
//
//                CMyMessageViewCell * cell = (CMyMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
//
//                if (cell == nil) {
//                    
//                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CMyMessageViewCell" owner:self options:nil];
//                    cell = [topLevelObjects objectAtIndex:0];
//                }
//                
//                [cell setData:model];
//
//                CGFloat nWidth = self.m_ctlJournalCollectionView.frame.size.width;
//                CGFloat nHeight = [cell.m_tvMessage sizeThatFits:CGSizeMake(nWidth * 0.7 - 32, CGFLOAT_MAX)].height;
//                CGSize mElementSize = CGSizeMake(nWidth, nHeight + 52);
//                return mElementSize;
//            }
        }
    }
    else if (collectionView.tag == 2)
    {
        CGFloat nWidth = (self.m_ctlInputCollectionView.frame.size.width) / 2;
        CGSize mElementSize = CGSizeMake(nWidth, nWidth);
        return mElementSize;
    }
    return CGSizeMake(0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    m_pSelectedModel = [m_arrNutritionist objectAtIndex:indexPath.row];
//    
//    [self performSegueWithIdentifier: @"CHOOSENUT_TO_INDIVNUT"
//                              sender: self];
    
    if (collectionView.tag == 1)
    {
        
    }
    else if (collectionView.tag == 2)
    {
        [self.m_arrImages removeObjectAtIndex:indexPath.row];
        [self.m_ctlInputCollectionView reloadData];
        [self refreshInputView];
    }
}

- (IBAction)onClickPhotoNew:(id)sender
{
    [self.m_viewPhotoSelect setHidden:YES];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    else
    {
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_PHOTO_NOCAMERA", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

- (IBAction)onClickPhotoLibrary:(id)sender
{
    [self.m_viewPhotoSelect setHidden:YES];
 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    else
    {
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_PHOTO_NOPHOTOLIBRARY", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

- (IBAction)onClickPhotoCancel:(id)sender
{
    [self.m_viewPhotoSelect setHidden:YES];
}

- (void)sendMessage:(NSString*) photoId
{
    if (photoId == nil)
        return;
    
    NSString* message = self.m_tvInputText.text;

    [[self view] endEditing:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *today = [dateFormat stringFromDate:[NSDate date]];
    
    CMessageModel* model = [[CMessageModel alloc] init];
    model.isNutritionist = NO;
    model.isImage = NO;
    model.isForMessage = NO;
    
    model.bodyText = message;
    model.userId = g_pUserModel.nUserID;
    NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
    model.username = strName;//g_pUserModel.strUserName;
    model.commentDate = [NSString stringWithFormat:@"%@ %@", self.m_strDate, [today substringFromIndex:11]];
    model.commentImage = g_pUserModel.strThumbnail;
    [self.m_arrJournal addObject:model];
    
    CJournalSearchModel* searchModel = [[CJournalSearchModel alloc] init];
    searchModel.photoId = photoId;
    searchModel.body = message;
    searchModel.indexOfComment = self.m_arrJournal.count - 1;
    
//    self.m_tvInputText.text = @"";
//    [self.m_tvInputText setNeedsLayout];
//
//    
    [CGlobal showProgressHUD:self];
    [CServiceManager onPostComments:self type:3 model:searchModel];
}

- (void)sendPhotoAndMessage
{
    NSString* message = self.m_tvInputText.text;

    if (self.m_arrImages.count == 0)
    {
        self.m_tvInputText.text = @"";
        [self.m_tvInputText setNeedsLayout];
        return;
    }
    
    [[self view] endEditing:YES];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *today = [dateFormat stringFromDate:[NSDate date]];

    CMessageModel* model = [[CMessageModel alloc] init];
    model.isNutritionist = NO;
    model.isImage = YES;
    model.isForMessage = NO;
    
    model.image = self.m_arrImages[0];
    model.userId = g_pUserModel.nUserID;
    NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
    model.username = strName;//g_pUserModel.strUserName;
    model.date = [dateFormat stringFromDate:[NSDate date]];
    [self.m_arrJournal addObject:model];
    
    CJournalSearchModel* searchModel = [[CJournalSearchModel alloc] init];
    searchModel.mealTypeId = [NSString stringWithFormat:@"%ld", (long)self.m_nMealTypeID];
    searchModel.creationDate = [NSString stringWithFormat:@"%@ %@", self.m_strDate, [today substringFromIndex:11]];
    searchModel.photo = self.m_arrImages[0];
    searchModel.body = message;
    searchModel.indexOfPhoto = self.m_arrJournal.count - 1;
    
    if (![message isEqualToString:@""])
    {
        searchModel.hasComment = YES;
        
        CMessageModel* modelMessage = [[CMessageModel alloc] init];
        modelMessage.isNutritionist = NO;
        modelMessage.isImage = NO;
        modelMessage.isForMessage = NO;
        
        modelMessage.bodyText = message;
        modelMessage.userId = g_pUserModel.nUserID;
        
        NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
        modelMessage.username = strName;//g_pUserModel.strUserName;
        modelMessage.commentDate = [NSString stringWithFormat:@"%@ %@", self.m_strDate, [today substringFromIndex:11]];
        [self.m_arrJournal addObject:modelMessage];
        searchModel.indexOfComment = self.m_arrJournal.count - 1;
    }
    
    [CGlobal showProgressHUD:self];
    [CServiceManager onPostPhoto:self type:2 model:searchModel];

//    [self.m_ctlJournalCollectionView reloadData];
//    [self.m_ctlJournalCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrJournal.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (IBAction)onClickSend:(id)sender
{
    NSString* message = self.m_tvInputText.text;
    
    if (self.m_arrImages.count != 0)
    {
        [self sendPhotoAndMessage];
    }
    else if (self.m_arrImages.count == 0 && ![message isEqualToString:@""])
    {
        [self sendMessage:self.m_strPublicPhotoId];
    }
    
//    
//    [self.m_arrImages removeAllObjects];
//    [self.m_ctlInputCollectionView reloadData];
//    [self refreshInputView];
//    self.m_tvInputText.text = @"";
//    [self.m_tvInputText setNeedsLayout];
}

- (IBAction)onClickCamera:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormat setTimeZone:timeZone];
    
    NSDate* priordate = [dateFormat dateFromString:self.m_strDate];
    NSString *strToday = [dateFormat stringFromDate:[NSDate date]];
    NSDate* today = [dateFormat dateFromString:strToday];
    //NSDate* today = [NSDate date];
    
    NSInteger nPrevCount = [CUtility daysBetween:today and:priordate];
    
    if (nPrevCount < - 3 || nPrevCount > 0)
        return;
    
    [[self view] endEditing:YES];
    [self.m_viewPhotoSelect setHidden:NO];
    [self.view bringSubviewToFront:self.m_viewPhotoSelect];
    
    CGRect destFrame = self.m_viewPhotoSelect .frame;
    destFrame.origin.y = self.m_viewPhotoSelect.frame.size.height;
    self.m_viewPhotoSelect.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.m_viewPhotoSelect.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //imagePath = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* imgTempR = [CUtility resizeImage:pickedImage];
    pickedImage = nil;
    if (self.m_arrImages == nil)
        self.m_arrImages = [[NSMutableArray alloc] init];
    [self.m_arrImages addObject:imgTempR];
    
    CGFloat nWidth = (self.m_tvInputText.frame.size.width);
    self.m_constraintHeightOfInputCollectionView.constant = nWidth / 2;
    [self.m_ctlInputCollectionView setHidden:NO];
    [self.m_ctlInputCollectionView setNeedsLayout];
    [self.m_ctlInputCollectionView layoutIfNeeded];
    [self.m_ctlInputCollectionView reloadData];
    
    [self refreshInputView];
}

-(void) refreshCollectionView
{
    [self.m_ctlJournalCollectionView setNeedsLayout];
    [self.m_ctlJournalCollectionView layoutIfNeeded];

    if (self.m_arrJournal.count == 0)
    {
        self.m_viewPlaceholder.hidden = NO;
    }
    else
    {
        self.m_viewPlaceholder.hidden = YES;
    }
}
-(void) refreshInputView
{
    if (self.m_arrImages.count == 0)
    {
        self.m_constraintHeightOfInputCollectionView.constant = 0;
        [self.m_ctlInputCollectionView setHidden:YES];
        [self.m_ctlInputCollectionView setNeedsLayout];
        [self.m_ctlInputCollectionView layoutIfNeeded];
    }
    if (self.m_arrImages.count < 2)
    {
        [self.m_ivCamera setUserInteractionEnabled:YES];
        [self.m_ivCamera setNeedsLayout];
    }
    else
    {
        [self.m_ivCamera setUserInteractionEnabled:NO];
        [self.m_ivCamera setNeedsLayout];
    }
}
@end
