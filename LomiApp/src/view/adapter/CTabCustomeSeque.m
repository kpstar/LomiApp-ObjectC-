//
//  CTabCustomeSeque.m
//  LomiApp
//
//  Created by TwinkleStar on 1/16/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CTabCustomeSeque.h"
#import "CVCProfileViewController.h"
@implementation CTabCustomeSeque

- (void) perform
{

     CVCProfileViewController *tabBarController = (CVCProfileViewController *) self.sourceViewController;
     UIViewController *destinationController = (UIViewController *) self.destinationViewController;
    
     // Add view to placeholder view
     [tabBarController.m_viewContainer addSubview: destinationController.view];
    
     // Set autoresizing
     [tabBarController.m_viewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];

     UIView *childview = destinationController.view;
     [childview setTranslatesAutoresizingMaskIntoConstraints: NO];
    
     // fill horizontal
     [tabBarController.m_viewContainer addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[childview]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
     
     // fill vertical
     [tabBarController.m_viewContainer addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[childview]-0-|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
     [tabBarController.m_viewContainer layoutIfNeeded];
     
     [tabBarController addChildViewController:destinationController];
     // notify did move
     [destinationController didMoveToParentViewController: tabBarController];
    
}


@end
