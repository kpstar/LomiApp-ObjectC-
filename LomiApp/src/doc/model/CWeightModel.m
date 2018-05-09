//
//  CWeightModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/12/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CWeightModel.h"

@implementation CWeightModel

@synthesize fStartingWeight,
            arrGoalWeight,
            pGoalWeight,
            fChangeWeight,
            fCurrentWeight,
            unitWeight,
            fBMI,
            strMeaning;


- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.fStartingWeight    = [decoder decodeDoubleForKey:@"WEIGHT_STARTINGWEIGHT"];
        self.arrGoalWeight      = [decoder decodeObjectForKey:@"WEIGHT_GOALWEIGHT"];
        self.pGoalWeight        = [decoder decodeObjectForKey:@"WEIGHT_GOALWEIGHTONE"];
        self.fChangeWeight      = [decoder decodeDoubleForKey:@"WEIGHT_CHANGEWEIGHT"];
        self.fCurrentWeight     = [decoder decodeDoubleForKey:@"WEIGHT_CURRENTWEIGHT"];
        self.unitWeight         = [decoder decodeIntegerForKey:@"WEIGHT_UNITWEIGHT"];
        self.fBMI               = [decoder decodeDoubleForKey:@"WEIGHT_BMI"];
        self.strMeaning         = [decoder decodeObjectForKey:@"WEIGHT_BMIMEANING"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeDouble:fStartingWeight forKey:@"WEIGHT_STARTINGWEIGHT"];
    [encoder encodeObject:arrGoalWeight forKey:@"WEIGHT_GOALWEIGHT"];
    [encoder encodeObject:pGoalWeight forKey:@"WEIGHT_GOALWEIGHTONE"];
    [encoder encodeDouble:fChangeWeight forKey:@"WEIGHT_CHANGEWEIGHT"];
    [encoder encodeDouble:fCurrentWeight forKey:@"WEIGHT_CURRENTWEIGHT"];
    [encoder encodeInteger:unitWeight forKey:@"WEIGHT_UNITWEIGHT"];
    [encoder encodeDouble:fBMI forKey:@"WEIGHT_BMI"];
    [encoder encodeObject:strMeaning forKey:@"WEIGHT_BMIMEANING"];
}


- (void) inititalize
{
    [self deleteAll];
    
    self.fStartingWeight    = 0;
    self.arrGoalWeight      = [[NSMutableArray alloc] init];
    self.pGoalWeight        = [[CGoalWeightModel alloc] init];
    self.fChangeWeight      = 0;
    self.fCurrentWeight     = 0;
    self.unitWeight         = 0;
    self.fBMI               = 0;
    self.strMeaning         = @"";
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
    self.fStartingWeight    = 0;
    [self.arrGoalWeight removeAllObjects];
    self.arrGoalWeight      = nil;
    [self.pGoalWeight deleteAll];
    self.pGoalWeight        = nil;
    self.fChangeWeight      = 0;
    self.fCurrentWeight     = 0;
    self.unitWeight         = 0;
    self.fBMI               = 0;
    self.strMeaning         = @"";
}

@end
