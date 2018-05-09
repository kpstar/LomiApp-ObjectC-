//
//  CVCSettingsViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/3/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCSettingsViewController.h"
#import "CGlobal.h"

@interface CVCSettingsViewController ()

@end

@implementation CVCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvUpdateAccount.text = NSLocalizedStringFromTable(@"BfL-fA-FTY.text", @"Main", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SETTING_TO_TABHOME"])
    {
        [CGlobal setState:TASKSTATE_SETTING nextState:g_nPrevState];
    }
    else if ([[segue identifier] isEqualToString:@"SETTING_TO_UPDATEACCOUNT"])
    {
        [CGlobal setState:TASKSTATE_SETTING nextState:TASKSTATE_SETTING_UPDATE];
    }
    else if ([[segue identifier] isEqualToString:@"SETTING_TO_CONTACTUS"])
    {
        [CGlobal setState:TASKSTATE_SETTING nextState:TASKSTATE_SETTING_CONTACTUS];
    }
}


- (IBAction)onClickBack:(id)sender
{
//    if(self.navigationController){
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
}
@end
