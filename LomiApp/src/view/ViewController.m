//
//  ViewController.m
//  LomiApp
//
//  Created by TwinkleStar on 10/22/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDWebImage/UIImage+GIF.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage* gifImg = [UIImage sd_animatedGIFNamed:@"ajax_clock_small"];
    self.m_ivGif.image = gifImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
