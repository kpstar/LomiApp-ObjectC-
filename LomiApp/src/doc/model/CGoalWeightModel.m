//
//  CGoalWeightModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/12/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CGoalWeightModel.h"

@implementation CGoalWeightModel

@synthesize fWeight,
            strDate;


- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.fWeight    = [decoder decodeDoubleForKey:@"GOALWEIGHT_WEIGHT"];
        self.strDate    = [decoder decodeObjectForKey:@"GOALWEIGHT_DATE"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeDouble:fWeight forKey:@"GOALWEIGHT_WEIGHT"];
    [encoder encodeObject:strDate forKey:@"GOALWEIGHT_DATE"];
}


- (void) inititalize
{
    [self deleteAll];
    
    self.fWeight    = 0;
    self.strDate    = @"";
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
    self.fWeight    = 0;
    self.strDate    = @"";
}

@end
