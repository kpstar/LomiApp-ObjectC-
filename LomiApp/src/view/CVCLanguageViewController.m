//
//  CVCLanguageViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 11/22/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCLanguageViewController.h"
#import "CGlobal.h"

@interface CVCLanguageViewController ()

@end

@implementation CVCLanguageViewController

@synthesize m_btnEngish, m_btnArabic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onAPISuccess:(int)type result:(id) result
{
    [super onAPISuccess:type result:result];
}

- (void)onAPIFail:(int)type result:(id) result
{
    [super onAPIFail:type result:result];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickBtnEnglish:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")
                                  message:NSLocalizedString(@"ALERT_MESSAGE_CHOOSELANGUAGE", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_YES", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button

        [CPreferenceManager setObject:@"N" forKey:PREF_ISFIRSTRUN];
        [CPreferenceManager saveLanguage:@"en"];
        [CGlobal setLanguage:@"en"];
        exit(0);
        
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_NO", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
    }];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)onClickBtnArabic:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"ALERT_TITLE_NOTE", @"")
                                  message:NSLocalizedString(@"ALERT_MESSAGE_CHOOSELANGUAGE", @"")
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_YES", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        [CPreferenceManager setObject:@"N" forKey:PREF_ISFIRSTRUN];
        [CPreferenceManager saveLanguage:@"ar"];
        [CGlobal setLanguage:@"ar"];
        
        exit(0);
        
    }];
    [alert addAction:yesAction];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"STR_NO", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
    }];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
    
//    [self performSegueWithIdentifier: @"LANGUAGE_TO_SPLASH"
//                              sender: self];
}
@end
