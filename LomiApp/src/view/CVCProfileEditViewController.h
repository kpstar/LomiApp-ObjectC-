//
//  CVCProfileEditViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/11/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CSelectCountryViewController.h"
#import "CUIViewController.h"
#import "SHSPhoneTextField.h"

@interface CVCProfileEditViewController : CUIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, CSelectCountryViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *m_viewSex;
@property (weak, nonatomic) IBOutlet UIView *m_viewFemale_s;
@property (weak, nonatomic) IBOutlet UIView *m_viewFemale_n;
@property (weak, nonatomic) IBOutlet UIView *m_viewMale_n;
@property (weak, nonatomic) IBOutlet UIView *m_viewMale_s;
@property (weak, nonatomic) IBOutlet UIImageView *m_ivAvata;
@property (weak, nonatomic) IBOutlet UIView *m_viewDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *m_ctlDatePicker;
@property (weak, nonatomic) IBOutlet UIView *m_viewPhotoSelect;
@property (weak, nonatomic) IBOutlet UITextField *m_tfCountry;
@property (weak, nonatomic) IBOutlet UITextField *m_tfBirthday;
@property (weak, nonatomic) IBOutlet UITextField *m_tfFName;
@property (weak, nonatomic) IBOutlet UITextField *m_tfLName;
@property (weak, nonatomic) IBOutlet SHSPhoneTextField *m_tfPhone;

@property   Boolean          bIsChange;
@property   Boolean          bIsCamera;

@property (weak, nonatomic) UIImage *m_imgAvata;
@property NSInteger m_nCurCountry;
@property NSString* m_strSex;

- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickSave:(id)sender;
- (IBAction)onClickFemaleN:(id)sender;
- (IBAction)onClickMaleS:(id)sender;
- (IBAction)onClickMaleN:(id)sender;
- (IBAction)onClickFemaleS:(id)sender;
- (IBAction)onClickAvata:(id)sender;
- (IBAction)onClickCountry:(id)sender;
- (IBAction)onClickBirthday:(id)sender;
- (IBAction)onClickPickerCancel:(id)sender;
- (IBAction)onClickPickerDone:(id)sender;
- (IBAction)onClickNewPhoto:(id)sender;
- (IBAction)onClickLibrary:(id)sender;
- (IBAction)onClickPhotoCancel:(id)sender;

- (IBAction)texfieldEditChanged:(id)sender;

@end
