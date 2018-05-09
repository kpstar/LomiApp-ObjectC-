//
//  CVCTabHomeViewController.h
//  LomiApp
//
//  Created by TwinkleStar on 12/9/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVCTabHomeViewController : UITabBarController<UITabBarControllerDelegate>

@property NSInteger m_nPrevIndex;
@property NSTimer*  m_timerNotification;
@property Boolean         bIsLoaded;
@property int             nPostIndex;

- (void)onAPISuccess:(int)type result:(id) result;
- (void)onAPIFail:(int)type result:(id) result;
- (void)onClickNotification;
- (void)refreshTab;
- (void)refreshBadge;
@end
