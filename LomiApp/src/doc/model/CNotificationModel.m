//
//  CNotificationModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/19/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CNotificationModel.h"

@implementation CNotificationModel



- (void) inititalize
{
    [self deleteAll];
    
    self.bIsNew = true;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self inititalize];
    }
    
    return self;
}

- (void) deleteAll
{
    
}

@end
