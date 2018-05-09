//
//  CVCRegist2ViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCRegist2ViewController.h"
#import "UIView+RoundedCorners.h"
#import "CSelectCountryViewController.h"
#import "CGlobal.h"

@interface CVCRegist2ViewController ()

@end

@implementation CVCRegist2ViewController

@synthesize m_nCurCountry, m_strSex;

- (void)viewDidLoad {
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
    

    m_nCurCountry = 0;
    m_strSex = @"412";

    NSString* strLan = [CPreferenceManager objectForKey:PREF_LANGUAGE];
    NSLocale *Locale = [[NSLocale alloc] initWithLocaleIdentifier:strLan];
    [self.m_ctlDatePicker setLocale:Locale];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.m_imgAvata == nil)
        [self.m_ivAvata setImage:[UIImage imageNamed:@"icon_avatar"]];
    else
        [self.m_ivAvata setImage:self.m_imgAvata];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];

    if (type == 0)  //signup
    {
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        
        [CServiceManager onEditUserLan:self type:3];
        [CServiceManager onSendOSVersion:self type:4];
        
        if (g_pUserModel.imgAvatar != nil)
        {
            [CServiceManager onSetUserProfilePhoto:self type:1];
            return;
        }
        else
        {
            [CServiceManager onSetUserTimezone:self type:2];
            return;
        }
    }
    else if (type == 1)
    {
        [CServiceManager onSetUserTimezone:self type:2];
        return;
    }
    else if (type == 2)
    {
        NSString *utcOffset = [CUtility getDeviceUTCOffset];
        [CPreferenceManager setObject:utcOffset forKey:PREF_TIMEZONE];
    }
    else if (type == 3)
    {
        return;
    }
    else if (type == 4)
    {
        if (result == nil)
        {
            [[self view] endEditing:YES];
            [CGlobal hideProgressHUD:self];
            [self performSegueWithIdentifier: @"REGIST2_TO_DIETREASONS"
                                      sender: self];
            return;
        }
        else
        {
            [CGlobal showAlertWithIgnoreSure:self type:0 message:NSLocalizedString(@"ALERT_MESSAGE_UPDATE", @"") title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
        }
    }
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    //[self performSegueWithIdentifier: @"REGIST2_TO_DIETREASONS"
    //                          sender: self];

    
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];

    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (type == 2)
    {
        //[self performSegueWithIdentifier: @"REGIST2_TO_DIETREASONS"
        //                          sender: self];
        [self performSegueWithIdentifier: @"REGIST2_TO_CHOOSENUT"
                                  sender: self];
        
        return;
    }
    else if (type == 3)
    {
        return;
    }
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

    if ([[segue identifier] isEqualToString:@"REGIST2_TO_SELECTCOUNTRY"])
    {
        CSelectCountryViewController* destController = [segue destinationViewController];
        destController.m_nCurSelectedIndex = m_nCurCountry;
        destController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"REGIST2_TO_DIETREASONS"])
    {
        [CGlobal setState:TASKSTATE_SIGNUP nextState:TASKSTATE_REG_QUESTIONARIES];
        [CPreferenceManager saveState:TASKSTATE_REG_QUESTIONARIES];
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        [CPreferenceManager saveUserModel:g_pUserModel];
    }
    else if([[segue identifier] isEqualToString:@"REGIST2_TO_CHOOSENUT"])
    {
        [CGlobal setState:TASKSTATE_REG_QUESTIONARIES nextState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveState:TASKSTATE_REG_CHOOSENUTRITIONIST];
        [CPreferenceManager saveEmail:g_strEmail];
        [CPreferenceManager savePassword:g_strPassword];
        [CPreferenceManager saveUserModel:g_pUserModel];
    }
}

- (void)onCountrySelected:(CSelectCountryViewController*)viewController
           didChooseIndex:(NSInteger)index didChooseCountry:(NSString*)strValue
{
    self.m_tfCountry.text = strValue;
    m_nCurCountry = index;
}


- (IBAction)onClickBack:(id)sender
{
    [self performSegueWithIdentifier: @"REGIST2_TO_REGIST1"
                              sender: self];
}

- (IBAction)onClickCreate:(id)sender
{
    [[self view] endEditing:YES];
 
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
        g_pUserModel.strCountryCode = g_arrCountryCode[m_nCurCountry];
        g_pUserModel.strBirthday = self.m_tfBirthday.text;
        g_pUserModel.strGenderMale = m_strSex;
        g_pUserModel.imgAvatar = self.m_imgAvata;
        g_pUserModel.strTelephone = self.m_tfPhone.text;
        
        NSArray* arrString = [g_pUserModel.strEmail componentsSeparatedByString:@"@"];
        int rndValue = 1000 + arc4random() % 9999;
        g_pUserModel.strProfileAddress = [NSString stringWithFormat:@"%@%d", arrString[0], rndValue];
        
        [CGlobal showProgressHUD:self];
        
        [CServiceManager onSignup:self type:0];
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
    [self.m_viewPhotoSelect setHidden:NO];
    [self.m_tfPhone resignFirstResponder];
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
    [self.m_tfPhone resignFirstResponder];
    [self performSegueWithIdentifier: @"REGIST2_TO_SELECTCOUNTRY"
                              sender: self];
    
}


- (IBAction)onClickBirthday:(id)sender
{
    [self.m_tfPhone resignFirstResponder];
    [self.m_viewDatePicker setHidden:NO];
    [self.view bringSubviewToFront:self.m_viewDatePicker];

    CGRect destFrame = self.m_viewDatePicker .frame;
    destFrame.origin.y = self.m_viewDatePicker.frame.size.height;
    self.m_viewDatePicker.frame = destFrame;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-80];
    NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    [comps setYear:-14];
    NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
    self.m_ctlDatePicker.minimumDate = minDate;
    self.m_ctlDatePicker.maximumDate = maxDate;
    
    
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



@end
