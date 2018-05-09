//
//  CSmoothNavigationSeque.h
//  BillApp
//
//  Created by apple on 9/28/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSmoothNavigationSeque : UIStoryboardSegue

@property (nonatomic, retain) UIView *myOldView;
@property (nonatomic, retain) UIView *myNewView;
-(void)animationDidFinish;

@end
