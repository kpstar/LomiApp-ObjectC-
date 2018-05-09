//
//  CVCRegist1ViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCRegist1ViewController.h"
#import "CGlobal.h"

@interface CVCRegist1ViewController ()

@end

@implementation CVCRegist1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tvTerms.text = NSLocalizedStringFromTable(@"c18-39-JmT.text", @"Main", @"");

    self.m_tfFirstName.delegate = self;
    self.m_tfLastName.delegate = self;
    self.m_tfEmail.delegate = self;
    self.m_tfEmailConfirm.delegate = self;
    self.m_tfPass.delegate = self;
    self.m_tfPassConfirm.delegate = self;
    
    [self initInput];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.m_ctlTerm.boxType = BEMBoxTypeSquare;
    self.m_ctlTerm.on = NO;
    self.m_btnNext.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (g_pUserModel != nil)
    {
        self.m_tfFirstName.text = g_pUserModel.strFirstName;
        self.m_tfLastName.text  = g_pUserModel.strLastName;
        self.m_tfEmail.text     = g_pUserModel.strEmail;
        self.m_tfPass.text      = g_pUserModel.strPassword;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    [self performSegueWithIdentifier: @"REGIST1_TO_REGIST2"
                              sender: self];
/*
    if ([result isKindOfClass:[NSString class]])
    {
//        if ([result isEqualToString:NSLocalizedString(@"ALERT_MESSAGE_API_CHECKEMAIL_VALID", @"")])
        if ([result isEqualToString:@"Email is fine!!"])
            [self performSegueWithIdentifier: @"REGIST1_TO_REGIST2"
                                           sender: self];
        else
            [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")];
    }
*/
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
    
    [[self view] endEditing:YES];
    [CGlobal hideProgressHUD:self];
    
    if (result == nil)
        [CGlobal showNetworkErrorAlert:self];
    else if ([result isKindOfClass:[NSString class]])
    {
        [CGlobal showAlert:self message:result title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        self.m_tfEmail.textColor = [UIColor redColor];
        [self.m_tfEmail becomeFirstResponder];
    }

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"REGIST1_TO_REGIST2"])
    {
        [CGlobal setState:TASKSTATE_SIGNUP nextState:TASKSTATE_SIGNUP];
        
        if (g_pUserModel != nil)
            [g_pUserModel deleteAll];
        g_pUserModel = nil;
        g_pUserModel = [[CUserModel alloc] init];
        
        g_pUserModel.strFirstName = self.m_tfFirstName.text;
        g_pUserModel.strLastName = self.m_tfLastName.text;
        g_pUserModel.strEmail = self.m_tfEmail.text;
        g_pUserModel.strPassword = self.m_tfPass.text;
        g_strEmail = self.m_tfEmail.text;
        g_strPassword = self.m_tfPass.text;
    }
    else if ([[segue identifier] isEqualToString:@"REGIST1_TO_SIGN"])
    {
        [CGlobal setState:TASKSTATE_SIGNUP nextState:TASKSTATE_SIGN];
        [CPreferenceManager saveState:TASKSTATE_SIGN];
    }
}


- (void) initInput
{
    self.m_tfFirstName.textColor = [UIColor blackColor];
    self.m_tfLastName.textColor = [UIColor blackColor];
    self.m_tfEmail.textColor = [UIColor blackColor];
    self.m_tfEmailConfirm.textColor = [UIColor blackColor];
    self.m_tfPass.textColor = [UIColor blackColor];
    self.m_tfPassConfirm.textColor = [UIColor blackColor];
}

- (IBAction)onClickTerm:(id)sender
{
    self.m_viewTerm.hidden = YES;
}

- (IBAction)onClickBack:(id)sender
{
    
    [self performSegueWithIdentifier: @"REGIST1_TO_SIGN"
                              sender: self];
}

- (IBAction)onClickNext:(id)sender
{
    [[self view] endEditing:YES];
    
    [self initInput];
    
    if (self.m_tfFirstName.text.length < 4)
    {
        self.m_tfFirstName.textColor = [UIColor redColor];
        [self.m_tfFirstName becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_FIRSTNAME", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else if (self.m_tfLastName.text.length < 4)
    {
        self.m_tfLastName.textColor = [UIColor redColor];
        [self.m_tfLastName becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_LASTNAME", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else if (self.m_tfPass.text.length < 6)
    {
        self.m_tfPass.textColor = [UIColor redColor];
        [self.m_tfPass becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_PASSWORD", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else if (![self.m_tfEmail.text isEqualToString:self.m_tfEmailConfirm.text])
    {
        //self.m_tfEmail.textColor = [UIColor redColor];
        self.m_tfEmailConfirm.textColor = [UIColor redColor];
        [self.m_tfEmailConfirm becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_CONFRIMEMAIL", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else if (![self.m_tfPass.text isEqualToString:self.m_tfPassConfirm.text])
    {
        //self.m_tfPass.textColor = [UIColor redColor];
        self.m_tfPassConfirm.textColor = [UIColor redColor];
        [self.m_tfPassConfirm becomeFirstResponder];
        
        [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_CONFRIMPASSWORD", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
        return;
    }
    else
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:self.m_tfEmail.text])
        {
            self.m_tfEmail.textColor = [UIColor redColor];
            [self.m_tfEmail becomeFirstResponder];
            
            [CGlobal showAlert:self message:NSLocalizedString(@"ALERT_MESSAGE_REGIST1_INPUTERROR_INVALIDEMAIL", @"") title:NSLocalizedString(@"ALERT_TITLE_ERROR", @"")];
            return;
        }
        
        g_strEmail = self.m_tfEmail.text;
        
        [CGlobal showProgressHUD:self];
        
        [CServiceManager onEmailCheck:self];
    }
    
//    [self performSegueWithIdentifier: @"REGIST1_TO_REGIST2"
//                              sender: self];
}

- (IBAction)onClickView:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)texfieldEditChanged:(id)sender
{
    UITextField*    textField = sender;
    textField.textColor = [UIColor blackColor];
}

- (IBAction)onClickTermLabel:(id)sender
{
    [[self view] endEditing:YES];
    [self.view bringSubviewToFront:self.m_viewTerm];
    self.m_viewTerm.hidden = NO;
}

- (IBAction)onClickAcceptofTerm:(id)sender
{
    self.m_viewTerm.hidden = YES;
    self.m_btnNext.enabled = YES;
    self.m_ctlTerm.on = YES;
}

- (IBAction)onClickCloseofTerm:(id)sender
{
    self.m_viewTerm.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //textField.textColor = [UIColor blackColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didTapCheckBox:(BEMCheckBox *)checkBox
{
    if (checkBox.on == YES)
    {
        self.m_btnNext.enabled = YES;
    }
    else
    {
        self.m_btnNext.enabled = NO;
    }
}
@end
