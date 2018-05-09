//
//  CVCAboutViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 1/24/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CVCAboutViewController.h"
#import <Google/Analytics.h>

@interface CVCAboutViewController ()

@end

@implementation CVCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tvDesc.text = NSLocalizedStringFromTable(@"vYd-ap-jEh.text", @"Main", @"");

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //  Google Analytics
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"About Us"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    //  End
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickFacebook:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/LomiApp/"]];
}

- (IBAction)noClickTwitter:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/lomiapp"]];
}

- (IBAction)onClickLomi:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.lomi-app.com"]];
}

- (IBAction)onClickSnapchat:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.snapchat.com/add/lomiapp"]];
}

- (IBAction)onClickInstagram:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/lomiapp/"]];
}
@end
