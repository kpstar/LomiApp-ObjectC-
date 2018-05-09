//
//  CVCProfileEditViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/11/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCProfileEditViewController.h"
#import "UIView+RoundedCorners.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CSelectCountryViewController.h"
#import "CGlobal.h"
#import "CProfileFieldModel.h"

@interface CVCProfileEditViewController ()

@end

@implementation CVCProfileEditViewController

@synthesize m_nCurCountry, m_strSex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_viewSex.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] CGColor];
    self.m_viewFemale_s.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] CGColor];
    self.m_viewFemale_n.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] CGColor];
    self.m_viewMale_n.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] CGColor];
    self.m_viewMale_s.layer.borderColor = [[UIColor colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] CGColor];
    
    
    [self.m_tfPhone.formatter setDefaultOutputPattern:@"+# ### ### #### ###"];
    [self.m_tfPhone.formatter addOutputPattern:@"+# ### ### ## ##" forRegExp:@"^7[0-689]\\d*$" imagePath:nil];
    [self.m_tfPhone.formatter addOutputPattern:@"+### ## ### ###" forRegExp:@"^374\\d*$" imagePath:nil];
    
    
    self.m_tfFName.delegate = self;
    self.m_tfLName.delegate = self;
    
    m_nCurCountry = [CGlobal countryIndexFromCode:g_pUserModel.strCountryCode];
    m_strSex = @"412";
    
    self.bIsChange = false;
    self.bIsCamera = false;
    
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    NSLocale *Locale = [[NSLocale alloc] initWithLocaleIdentifier:strLan];
    [self.m_ctlDatePicker setLocale:Locale];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    //For Arabic
    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    if ([strLan isEqualToString:@"ar"])
    {
        [self.m_viewFemale_s setRoundedCorners:UIViewRoundedCornerUpperRight | UIViewRoundedCornerLowerRight radius:14];
        [self.m_viewFemale_n setRoundedCorners:UIViewRoundedCornerUpperRight | UIViewRoundedCornerLowerRight radius:14];
        [self.m_viewMale_s setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft radius:14];
        [self.m_viewMale_n setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft radius:14];
    }
    else
    {
        [self.m_viewFemale_s setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft radius:14];
        [self.m_viewFemale_n setRoundedCorners:UIViewRoundedCornerLowerLeft | UIViewRoundedCornerUpperLeft radius:14];
        [self.m_viewMale_s setRoundedCorners:UIViewRoundedCornerUpperRight | UIViewRoundedCornerLowerRight radius:14];
        [self.m_viewMale_n setRoundedCorners:UIViewRoundedCornerUpperRight | UIViewRoundedCornerLowerRight radius:14];
    }

    if (self.m_imgAvata == nil)
        [self.m_ivAvata sd_setImageWithURL:[NSURL URLWithString:g_pUserModel.strThumbnail]
                          placeholderImage:[UIImage imageNamed:@"icon_avatar"]];
    else
        [self.m_ivAvata setImage:self.m_imgAvata];
    
    self.m_tfBirthday.text = g_pUserModel.strBirthday;
    
    self.m_tfCountry.text = g_arrCountryFullName[m_nCurCountry];//[CGlobal countryFullName:g_pUserModel.strCountryCode];
    self.m_tfFName.text = g_pUserModel.strFirstName;
    self.m_tfLName.text = g_pUserModel.strLastName;
    self.m_tfPhone.text = g_pUserModel.strTelephone;

    if ([g_pUserModel.strGenderMale isEqualToString:@"411"])
    {
        self.m_viewFemale_s.hidden = true;
        self.m_viewMale_n.hidden = true;
        
        self.m_viewFemale_n.hidden = false;
        self.m_viewMale_s.hidden = false;
        
        m_strSex = @"411";
    }
    else
    {
        
        self.m_viewFemale_s.hidden = false;
        self.m_viewMale_n.hidden = false;
        
        self.m_viewFemale_n.hidden = true;
        self.m_viewMale_s.hidden = true;
        
        m_strSex = @"412";
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.bIsCamera == FALSE)
        [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:g_vcTabHome];

    if (type == 0)
    {
        if (self.m_imgAvata != nil)
        {
            [CGlobal showProgressHUD:g_vcTabHome];
            [CServiceManager onSetUserProfilePhoto:self type:2];
        }
        else
        {
            [self endEdit];
        }
    }
    if (type == 2)
    {
        [self endEdit];
    }

}

- (void)endEdit
{
    [CGlobal setState:TASKSTATE_PROFILE_EDIT nextState:TASKSTATE_TAB_PROFILE];
    if (self.bIsChange == true)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Profile" object:nil];
    [self.view removeFromSuperview];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"EDITPROFILE_TO_SELECTCOUNTRY"])
    {
        CSelectCountryViewController* destController = [segue destinationViewController];
        destController.m_nCurSelectedIndex = m_nCurCountry;
        destController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"EDITPROFILE_TO_PROFILE"])
    {
        [CGlobal setState:TASKSTATE_PROFILE_EDIT nextState:TASKSTATE_TAB_PROFILE];
        if (self.bIsChange == true)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Profile" object:nil];
    }

}

- (void)onCountrySelected:(CSelectCountryViewController*)viewController
           didChooseIndex:(NSInteger)index didChooseCountry:(NSString*)strValue
{
    self.m_tfCountry.text = strValue;
    m_nCurCountry = index;
}



- (IBAction)onClickCancel:(id)sender
{
    [[self view] endEditing:YES];
    self.bIsChange = false;
    [CGlobal setState:TASKSTATE_PROFILE_EDIT nextState:TASKSTATE_TAB_PROFILE];
    [self.view removeFromSuperview];
}

- (IBAction)onClickSave:(id)sender
{
    [[self view] endEditing:YES];
    
    if (self.m_tfFName.text.length < 4)
    {
        self.m_tfFName.textColor = [UIColor redColor];
        [self.m_tfFName becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_FIRSTNAME", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else if (self.m_tfLName.text.length < 4)
    {
        self.m_tfLName.textColor = [UIColor redColor];
        [self.m_tfLName becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_FIRSTNAME", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    if (self.m_tfCountry.text.length == 0)
    {
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST2_INPUTERROR_COUNTRY", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else if (self.m_tfBirthday.text.length == 0)
    {
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST2_INPUTERROR_BIRTHDAY", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else
    {
        self.bIsChange = true;
        
        CProfileFieldModel *model = [[CProfileFieldModel alloc] init];
        
        model.strFName = self.m_tfFName.text;
        model.strLName = self.m_tfLName.text;
        model.strCountryCode = g_arrCountryCode[m_nCurCountry];
        model.strBirthday = self.m_tfBirthday.text;
        model.strGender = m_strSex;
//        if (g_pUserModel.strTelephone != nil)
//            model.strTelephone = g_pUserModel.strTelephone;
//        else
//            model.strTelephone = @"";
        model.strTelephone = self.m_tfPhone.text;
        
        g_pUserModel.imgAvatar = self.m_imgAvata;
        
        [CGlobal showProgressHUD:g_vcTabHome];
        
        [CServiceManager onEditProfile:self type:0 model:model];
    }
}

- (IBAction)onClickFemaleN:(id)sender
{
    self.m_viewFemale_s.hidden = false;
    self.m_viewMale_n.hidden = false;
    
    self.m_viewFemale_n.hidden = true;
    self.m_viewMale_s.hidden = true;
    
    m_strSex = @"412";
}

- (IBAction)onClickMaleS:(id)sender
{
    self.m_viewFemale_s.hidden = true;
    self.m_viewMale_n.hidden = true;
    
    self.m_viewFemale_n.hidden = false;
    self.m_viewMale_s.hidden = false;
    
    m_strSex = @"411";
}

- (IBAction)onClickMaleN:(id)sender
{
    self.m_viewFemale_s.hidden = true;
    self.m_viewMale_n.hidden = true;
    
    self.m_viewFemale_n.hidden = false;
    self.m_viewMale_s.hidden = false;
    
    m_strSex = @"411";
}

- (IBAction)onClickFemaleS:(id)sender
{
    self.m_viewFemale_s.hidden = false;
    self.m_viewMale_n.hidden = false;
    
    self.m_viewFemale_n.hidden = true;
    self.m_viewMale_s.hidden = true;
    
    m_strSex = @"412";
}

- (IBAction)onClickAvata:(id)sender
{
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

- (IBAction)onClickCountry:(id)sender
{
    [self performSegueWithIdentifier: @"EDITPROFILE_TO_SELECTCOUNTRY"
                              sender: self];
}

- (IBAction)onClickBirthday:(id)sender
{
    [[self view] endEditing:YES];
    [self.m_viewDatePicker setHidden:NO];
    [self.view bringSubviewToFront:self.m_viewDatePicker];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [self.m_ctlDatePicker setDate:[dateFormat dateFromString:self.m_tfBirthday.text]];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-80];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-14];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    self.m_ctlDatePicker.minimumDate = minDate;
    self.m_ctlDatePicker.maximumDate = maxDate;
    
    CGRect destFrame = self.m_viewDatePicker .frame;
    destFrame.origin.y = self.m_viewDatePicker.frame.size.height;
    self.m_viewDatePicker.frame = destFrame;
    
    destFrame.origin.y = 0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.m_viewDatePicker.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)onClickPickerCancel:(id)sender
{
    [self.m_viewDatePicker setHidden:YES];
}

- (IBAction)onClickPickerDone:(id)sender
{
    
    NSDate *mDate = self.m_ctlDatePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *indianLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:indianLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormat stringFromDate:mDate];
    self.m_tfBirthday.text = strDate;
    
    [self.m_viewDatePicker setHidden:YES];
    
}

- (IBAction)onClickNewPhoto:(id)sender
{
    [self.m_viewPhotoSelect setHidden:YES];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
        self.bIsCamera = true;
    }
    else
    {
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_PHOTO_NOCAMERA", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
    }
}

- (IBAction)onClickLibrary:(id)sender
{
    [self.m_viewPhotoSelect setHidden:YES];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        [self presentViewController:imgPicker animated:YES completion:nil];
        self.bIsCamera = true;
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

-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [self.view endEditing:YES];
    self.bIsCamera = false;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //imagePath = (NSURL *)[info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage* imgTempR = [CUtility resizeImage:pickedImage];
    UIImage* imgTempC = [CUtility imageByCroppingImage:imgTempR toSize:CGSizeMake(AVATAR_WIDTH, AVATAR_HEIGHT)];
    UIImage* imgTempF = [CUtility fixRotation: imgTempC];
    imgTempR = nil;
    imgTempC = nil;
    self.m_imgAvata = nil;
    self.m_imgAvata = imgTempF;
    [self.m_ivAvata setImage:nil];
    [self.m_ivAvata setImage:self.m_imgAvata];
    
}

- (IBAction)texfieldEditChanged:(id)sender
{
    UITextField*    textField = sender;
    textField.textColor = [UIColor blackColor];
}

@end
