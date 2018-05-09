//
//  CBodyMeasurementModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/6/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBodyMeasurementModel : NSObject<NSCoding>

@property   float       fWeight;
@property   float       fHeight;
@property   float       fUpperarm;
@property   float       fChest;
@property   float       fWaist;
@property   float       fHips;
@property   float       fThigh;
@property   NSString*   strDisplayName;
@property   NSString*   strCreationDate;
@property   NSString*   strModifiedDate;

@property   NSInteger   nMeasurementId;
@property   NSInteger   nWUnit;
@property   NSInteger   nLUnit;

- (void)        inititalize;
- (void)        deleteAll;

@end
