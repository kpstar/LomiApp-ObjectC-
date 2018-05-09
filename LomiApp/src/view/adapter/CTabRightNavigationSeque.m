//
//  CTabRightNavigationSeque.m
//  LomiApp
//
//  Created by TwinkleStar on 12/9/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CTabRightNavigationSeque.h"
#import "CGlobal.h"

@implementation CTabRightNavigationSeque

-(void)perform {
    
    UIViewController* source = g_vcTabHome;//(UIViewController *)self.sourceViewController;
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
                         
                      UIWindow *window = source.view.window;
                                                  [window setRootViewController:destination];
//                         [source presentViewController:self.destinationViewController animated:NO completion:NULL];
                     }];
}

@end
