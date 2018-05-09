//
//  CGoalWeightModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/12/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGoalWeightModel : NSObject<NSCoding>

@property   float            fWeight;
@property   NSString*        strDate;

- (void)        inititalize;
- (void)        deleteAll;

@end
