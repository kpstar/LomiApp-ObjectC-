//
//  CBodyMeasurementModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/6/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CBodyMeasurementModel.h"
#import "CConstant.h"

@implementation CBodyMeasurementModel

@synthesize fWeight,
            fHeight,
            fUpperarm,
            fChest,
            fWaist,
            fHips,
            fThigh,
            nWUnit,
            nLUnit,
            nMeasurementId,
            strDisplayName,
            strCreationDate,
            strModifiedDate;

- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init]))
    {
        self.fWeight    = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_WEIGHT"];
        self.fHeight    = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_HEIGHT"];
        self.fUpperarm  = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_UPPERARM"];
        self.fChest     = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_CHEST"];
        self.fWaist     = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_WAIST"];
        self.fHips      = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_HIPS"];
        self.fThigh     = [decoder decodeDoubleForKey:@"BODYMEASUREMENT_THIGH"];
        self.nWUnit   = [decoder decodeIntegerForKey:@"BODYMEASUREMENT_WUNIT"];
        self.nLUnit   = [decoder decodeIntegerForKey:@"BODYMEASUREMENT_LUNIT"];
        self.nMeasurementId = [decoder decodeIntegerForKey:@"BODYMEASUREMENT_MEASUREMENTID"];
        self.strDisplayName = [decoder decodeObjectForKey:@"BODYMEASUREMENT_DISPLAYNAME"];
        self.strCreationDate = [decoder decodeObjectForKey:@"BODYMEASUREMENT_CREATIONDATE"];
        self.strModifiedDate = [decoder decodeObjectForKey:@"BODYMEASUREMENT_MODIFIEDDATE"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    [encoder encodeDouble:fWeight forKey:@"BODYMEASUREMENT_WEIGHT"];
    [encoder encodeDouble:fHeight forKey:@"BODYMEASUREMENT_HEIGHT"];
    [encoder encodeDouble:fUpperarm forKey:@"BODYMEASUREMENT_UPPERARM"];
    [encoder encodeDouble:fChest forKey:@"BODYMEASUREMENT_CHEST"];
    [encoder encodeDouble:fWaist forKey:@"BODYMEASUREMENT_WAIST"];
    [encoder encodeDouble:fHips forKey:@"BODYMEASUREMENT_HIPS"];
    [encoder encodeDouble:fThigh forKey:@"BODYMEASUREMENT_THIGH"];
    [encoder encodeInteger:nWUnit forKey:@"BODYMEASUREMENT_WUNIT"];
    [encoder encodeInteger:nLUnit forKey:@"BODYMEASUREMENT_LUNIT"];
    [encoder encodeObject:strDisplayName forKey:@"BODYMEASUREMENT_DISPLAYNAME"];
    [encoder encodeObject:strCreationDate forKey:@"BODYMEASUREMENT_CREATIONDATE"];
    [encoder encodeObject:strModifiedDate forKey:@"BODYMEASUREMENT_MODIFIEDDATE"];
    [encoder encodeInteger:nMeasurementId forKey:@"BODYMEASUREMENT_MEASUREMENTID"];
}

- (void) inititalize
{
    [self deleteAll];
    
    self.fWeight    = 0;
    self.fHeight    = 0;
    self.fUpperarm  = 0;
    self.fChest     = 0;
    self.fWaist     = 0;
    self.fHips      = 0;
    self.fThigh     = 0;
    self.nWUnit     = WUNIT_KILOGRAMS;
    self.nLUnit     = LUNIT_CENTIMETRS;
    self.nMeasurementId = 0;
    self.strDisplayName = nil;
    self.strCreationDate = nil;
    self.strModifiedDate = nil;
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
    self.fHeight    = 0;
    self.fUpperarm  = 0;
    self.fChest     = 0;
    self.fWaist     = 0;
    self.fHips      = 0;
    self.fThigh     = 0;
    self.nWUnit     = WUNIT_KILOGRAMS;
    self.nLUnit     = LUNIT_CENTIMETRS;
    self.nMeasurementId = 0;
    self.strDisplayName = nil;
    self.strCreationDate = nil;
    self.strModifiedDate = nil;
}

@end
