//
//  CVCMessageViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCMessageViewController.h"
#import "CInputImageCollectionViewCell.h"
#import "CMyMessageViewCell.h"
#import "CNutritionistMessageViewCell.h"
#import "CMessageModel.h"
#import "UIView+RoundedCorners.h"
#import <Google/Analytics.h>

//#import <MessageSDKFramework/CometChat.h>
//#import <cometchat-ui/readyUIFile.h>

@interface CVCMessageViewController ()

@end

@implementation CVCMessageViewController
{
//    CometChat *cometchat;
//    readyUIFIle *readyUI;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.m_cvMessage registerNib:[UINib nibWithNibName:@"CNutritionistMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_NUTMESSAGE"];
    [self.m_cvMessage registerNib:[UINib nibWithNibName:@"CMyMessageViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_MYMESSAGE"];

    [self.m_cvInputImage registerNib:[UINib nibWithNibName:@"CInputImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CELL_INPUTIMAGE"];

    self.m_constraintHeightOfInputCollectionView.constant = 0;
    [self.m_cvInputImage setHidden:YES];
    [self.m_cvInputImage setNeedsLayout];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(removeKeyboard)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    [self.m_tvInputText setInputAccessoryView:toolBar];

    self.m_arrMessage = [[NSMutableArray alloc] init];
}

- (void)removeKeyboard
{
    [self.m_tvInputText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"Message"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
 
    if (self.bIsLoaded)
        return;
    self.bIsLoaded = YES;

    [CGlobal showProgressHUD:g_vcTabHome];
    [CServiceManager onGetConversations:self type:0];

    //[CGlobal setState:g_nCurState nextState:TASKSTATE_TAB_MESSAGES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.bIsLoaded = NO;

    [self.m_viewPhotoSelect setHidden:YES];
}

- (void)refreshMessage
{
    [CServiceManager onGetConversations:self type:0];
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];

    if (type == 0)
    {
//        self.tabBarItem.badgeValue = nil;
        
        if (self.m_arrMessage != nil)
        [self.m_arrMessage removeAllObjects];
        [self.m_arrMessage addObjectsFromArray:result];
        [result removeAllObjects];
        result = nil;
        [self.m_cvMessage reloadData];
        if (self.m_arrMessage.count != 0)
            [self.m_cvMessage scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrMessage.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    else if (type == 1)
    {
        [self.m_arrMessage addObject:result];
        [self.m_cvMessage reloadData];
        if (self.m_arrMessage.count != 0)
            [self.m_cvMessage scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrMessage.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        self.m_tvInputText.text = @"";
        [self.m_tvInputText setNeedsLayout];

    }
}

- (void)onAPISuccessExtend:(int)type result:(id) result extend:(id) extend
{
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
    
    [self.m_arrMessage addObject:result];
    
    NSString *strLastTime = [CPreferenceManager loadExtendedMessageTime];
    if (strLastTime != nil)
    {
        CMessageModel* extendModel = extend;
        NSString *strCurrentTime = extendModel.date;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormat setLocale:indianLocale];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *lastTime = [dateFormat dateFromString:strLastTime];
        NSDate *currentTime = [dateFormat dateFromString:strCurrentTime];
        
        NSTimeInterval secondsBetween = [currentTime timeIntervalSinceDate:lastTime];
        
        int numberOfDays = secondsBetween / 86400;
        if (numberOfDays > 0)
        {
            [self.m_arrMessage addObject:extend];
            [CPreferenceManager saveExtendedMessageTime:extendModel.date];
        }
    }
    else
    {
        CMessageModel* extendModel = extend;
        [self.m_arrMessage addObject:extend];
        [CPreferenceManager saveExtendedMessageTime:extendModel.date];
    }
    
    [self.m_cvMessage reloadData];
    if (self.m_arrMessage.count != 0)
        [self.m_cvMessage scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.m_arrMessage.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    self.m_tvInputText.text = @"";
    [self.m_tvInputText setNeedsLayout];
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];
 
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1)
    {
        return self.m_arrMessage.count;
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
        CMessageModel* model = self.m_arrMessage[indexPath.row];

        if (model.isNutritionist)
        {
            CNutritionistMessageViewCell *mCell = (CNutritionistMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_NUTMESSAGE" forIndexPath:indexPath];
            [mCell setNeedsLayout];
            [mCell layoutIfNeeded];
            [mCell setData:model];
            return mCell;
        }
        else
        {
            CMyMessageViewCell *mCell = (CMyMessageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_MYMESSAGE" forIndexPath:indexPath];
            [mCell setNeedsLayout];
            [mCell layoutIfNeeded];
            [mCell setData:model];
            return mCell;
        }
    }
    if (collectionView.tag == 2)
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
        CMessageModel* model = self.m_arrMessage[indexPath.row];
 
        if (model.isNutritionist)
        {
            CNutritionistMessageViewCell * cell = (CNutritionistMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

            if (cell == nil) {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CNutritionistMessageViewCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            [cell setData:model];

            CGFloat nWidth = self.m_cvMessage.frame.size.width;
            CGFloat nHeight = [cell.m_tvMessage sizeThatFits:CGSizeMake(nWidth - 90, CGFLOAT_MAX)].height;
            CGSize mElementSize = CGSizeMake(nWidth, nHeight + 52);
            return mElementSize;
        }
        else
        {

            CMyMessageViewCell * cell = (CMyMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
     
            if (cell == nil) {
     
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CMyMessageViewCell" owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            [cell setData:model];
            
            CGFloat nWidth = self.m_cvMessage.frame.size.width;
            CGFloat nHeight = [cell.m_tvMessage sizeThatFits:CGSizeMake(nWidth * 0.7 - 32, CGFLOAT_MAX)].height;
            CGSize mElementSize = CGSizeMake(nWidth, nHeight + 52);
            return mElementSize;
        }

    }
    else if (collectionView.tag == 2)
    {
        int nWidth = (self.m_cvInputImage.frame.size.width) / 2;
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

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    UICollectionViewCell * viewCell = [collectionView cellForItemAtIndexPath:indexPath];
//    if ([viewCell isKindOfClass:[CNutritionistMessageViewCell class]])
//    {
//        CNutritionistMessageViewCell * cell = (CNutritionistMessageViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
//        [cell.m_tvMessage setUserInteractionEnabled:YES];
//    }
//    if (collectionView.tag == 1)
//    {
//
//    }
//    else if (collectionView.tag == 2)
//    {
//        
//    }
//}



- (IBAction)onClickNewPhoto:(id)sender
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

- (IBAction)onClickCancel:(id)sender
{
    [self.m_viewPhotoSelect setHidden:YES];

}

- (IBAction)onClickSend:(id)sender
{
    NSString* message = self.m_tvInputText.text;

    if (![message isEqualToString:@""])
    {
        [[self view] endEditing:YES];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormat setLocale:indianLocale];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        CMessageModel* model = [[CMessageModel alloc] init];
        model.isNutritionist = NO;
        model.isImage = NO;
        
        model.body = message;
        model.userId = g_pUserModel.nUserID;
        model.username = g_pUserModel.strUserName;
        model.date = [dateFormat stringFromDate:[NSDate date]];
        
        [CGlobal showProgressHUD:g_vcTabHome];
        [CServiceManager onPostMessage:self type:1 model:model];
    }
}

- (IBAction)onClickCamera:(id)sender
{
//    [[self view] endEditing:YES];
//    [self.m_viewPhotoSelect setHidden:NO];
//    [self.view bringSubviewToFront:self.m_viewPhotoSelect];
//    
//    CGRect destFrame = self.m_viewPhotoSelect .frame;
//    destFrame.origin.y = self.m_viewPhotoSelect.frame.size.height;
//    self.m_viewPhotoSelect.frame = destFrame;
//    
//    destFrame.origin.y = 0;
//    
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         self.m_viewPhotoSelect.frame = destFrame;
//                     }
//                     completion:^(BOOL finished) {
//                         
//                     }];
//    cometchat = [[CometChat alloc] init];
//
//    [cometchat checkCometChatUrl:COMETCHAT_SITEURL success:^(NSDictionary *response) {
//
//        NSLog(@"checkCometChatUrl Success: %@",response);
//
//        [cometchat initializeCometChat:[response objectForKey:@"cometchat_url"] licenseKey:COMETCHAT_LICENCEKEY apikey:COMETCHAT_APIKEY isCometOnDemand:NO success:^(NSDictionary *response) {
//
//        } failure:^(NSError *error) {
//            NSLog(@"initializeCometChat Error %@",error);
//        }];
//
//        [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"cometchat_url"] forKey:@"Website_url"];
//
//        NSString *website_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"Website_url"];
//        NSLog(@"URL is--> %@",website_url);
//
//        [cometchat login:g_strEmail password:g_strPassword success:^(NSDictionary *response) {
//            NSLog(@"Login Successful %@",response);
//
//            [readyUI launchCometChat:YES observer:self userInfo:^(NSDictionary *response) {
//                NSLog(@"launchCometChat : userInfo %@",response);
//            } groupInfo:^(NSDictionary *response) {
//                NSLog(@"launchCometChat : groupInfo %@",response);
//            } onMessageReceive:^(NSDictionary *response) {
//                NSLog(@"launchCometChat : onMessageReceive %@",response);
//            } success:^(NSDictionary *response) {
//                NSLog(@"launchCometChat : success %@",response);
//            } failure:^(NSError *error) {
//                NSLog(@"launchCometChat : failure %@",error);
//            } onLogout:^(NSDictionary *response) {
//                NSLog(@"launchCometChat : onLogout %@",response);
//            }];
//
//        } failure:^(NSError *error) {
//            NSLog(@"Login Error %@",error);
//        }];
//
//
//
//    } failure:^(NSError *error) {
//        NSLog(@"checkCometChatUrl Error %@",error);
//    }];


}

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{   	
    [picker dismissViewControllerAnimated:YES completion:nil];
    //imagePath = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (self.m_arrImages == nil)
        self.m_arrImages = [[NSMutableArray alloc] init];
    [self.m_arrImages addObject:pickedImage];
    
    self.m_constraintHeightOfInputCollectionView.constant = 80;
    [self.m_cvInputImage setHidden:NO];
    [self.m_cvInputImage setNeedsLayout];
    [self.m_cvInputImage reloadData];
    
    //    UIImage* imgTempR = [CUtility resizeImage:pickedImage];
    //    UIImage* imgTempC = [CUtility imageByCroppingImage:imgTempR toSize:CGSizeMake(AVATAR_WIDTH, AVATAR_HEIGHT)];
    //
    //    UIImage* imgTempF = [CUtility fixRotation: imgTempC];
    //    imgTempR = nil;
    //    imgTempC = nil;
    
}
@end
