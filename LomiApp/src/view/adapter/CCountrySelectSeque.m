//
//  CCountrySelectSeque.m
//  LomiApp
//
//  Created by TwinkleStar on 1/24/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CCountrySelectSeque.h"
#import "CGlobal.h"
#import "CVCProfileViewController.h"
#import "CVCProfileEditViewController.h"

@implementation CCountrySelectSeque

-(void)perform {
    
    UIViewController* source = self.sourceViewController;
    UIViewController* destination = (UIViewController *)self.destinationViewController;
  
    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;

    CGRect destFrame = destination.view.frame;
    destFrame.origin.x = destination.view.frame.size.width;
    destination.view.frame = destFrame;
    
    destFrame.origin.x = 0;

    [source.view.superview addSubview:destination.view];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         source.view.frame = sourceFrame;
                         destination.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         
//                         UIWindow *window = source.view.window;
//                         [window setRootViewController:destination];
//                         [source presentViewController:self.destinationViewController animated:NO completion:NULL];
                         
                         // Add view to placeholder view
                         [source.view addSubview: destination.view];
                         
                         // Set autoresizing
                         [source.view setTranslatesAutoresizingMaskIntoConstraints:NO];

                         UIView *childview = destination.view;
                         [childview setTranslatesAutoresizingMaskIntoConstraints: NO];
                         
                         // fill horizontal
                         [source.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[childview]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
                         
                         // fill vertical
                         [source.view addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[childview]-0-|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
                         
                         [source.view layoutIfNeeded];
                         
                         [source addChildViewController:destination];
                         // notify did move
                         [destination didMoveToParentViewController: source];
                     }];
}

@end
