//
//  CSmoothNavigationSeque.m
//  BillApp
//
//  Created by apple on 9/28/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CSmoothNavigationSeque.h"

@implementation CSmoothNavigationSeque


-(void)perform
{
    NSTimeInterval duration = 0.1f;
    self.myOldView = [self.sourceViewController view];
    self.myNewView = [self.destinationViewController view];
    
    [self.myNewView setAlpha:0.0];
    
    [[[self.sourceViewController view] superview] addSubview:self.myNewView];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:duration];
    [self.myOldView setAlpha:0.5f];
    [self.myNewView setAlpha:1.0f];
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [self performSelector:@selector(animationDidFinish) withObject:nil afterDelay:duration];
}

-(void)animationDidFinish
{
    [self.myOldView setAlpha:1.0f];
    //[self.myNewView removeFromSuperview];
    [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:NULL];
    self.myOldView = nil;
    self.myNewView = nil;
}


@end
