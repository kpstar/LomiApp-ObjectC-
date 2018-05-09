//
//  CVCViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 11/26/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUIViewController : UIViewController

- (void)onAPISuccess:(int)type result:(id) result;
- (void)onAPIFail:(int)type result:(id) result;

@end
