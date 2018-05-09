//
//  CVCRegist2ViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CUIViewController.h"
#import "CSelectCountryViewController.h"
#import "SHSPhoneTextField.h"

@interface CVCRegist2ViewController : CUIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, CSelectCountryViewControllerDelegate>

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
@property (weak, nonatomic) IBOutlet SHSPhoneTextField *m_tfPhone;

@property (weak, nonatomic) UIImage *m_imgAvata;
@property NSInteger m_nCurCountry;
@property NSString* m_strSex;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickCreate:(id)sender;
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

@end
