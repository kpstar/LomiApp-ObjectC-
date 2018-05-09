//
//  CDietPlanModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/15/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CDietPlanModel.h"

@implementation CDietPlanModel

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
