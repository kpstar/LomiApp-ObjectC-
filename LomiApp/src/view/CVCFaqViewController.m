//
//  CVCFaqViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 12/29/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CVCFaqViewController.h"
#import <Google/Analytics.h>

@interface CVCFaqViewController ()

@end

@implementation CVCFaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"PEy-IG-bY6.text", @"Main", @"");

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"FAQ"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//  End
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self.m_tvDesc setContentOffset:CGPointZero];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
