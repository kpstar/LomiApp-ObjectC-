//
//  CCustomNavigationSeque.m
//  BillApp
//
//  Created by apple on 9/21/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CCustomNavigationSeque.h"
//#import "CVCTabBar.h"
#import "AppDelegate.h"

@implementation CCustomNavigationSeque

- (void) perform
{
    /*
    CVCTabBar *tabBarController = [((AppDelegate *) [[UIApplication sharedApplication] delegate]) tabBarController];
    
    if (tabBarController == nil)
        return;
    
    //CVCTabBar *tabBarController = (CVCTabBar *) self.sourceViewController;
    UIViewController *destinationController = (UIViewController *) self.destinationViewController;
    
    for (UIView *view in tabBarController.m_viewPlaceHolder.subviews)
    {
        [view removeFromSuperview];
    }
    
    // Add view to placeholder view
    tabBarController.currentViewController = destinationController;
    [tabBarController.m_viewPlaceHolder addSubview: destinationController.view];
    
    // Set autoresizing
    [tabBarController.m_viewPlaceHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *childview = destinationController.view;
    [childview setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // fill horizontal
    [tabBarController.m_viewPlaceHolder addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[childview]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
    // fill vertical
    [tabBarController.m_viewPlaceHolder addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[childview]-0-|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
    [tabBarController.m_viewPlaceHolder layoutIfNeeded];
    
    [tabBarController addChildViewController:destinationController];
    // notify did move
    [destinationController didMoveToParentViewController: tabBarController];
     
     */
}


@end
