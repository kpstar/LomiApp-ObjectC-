//
//  CMessageModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/15/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CMessageModel.h"

@implementation CMessageModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    
}


- (void) inititalize
{
    [self deleteAll];
    
    self.image = nil;
    self.isImage = NO;
    self.isForMessage = YES;
    self.bIsLiked = false;
    
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
