//
//  CWeightModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/12/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGoalWeightModel.h"

@interface CWeightModel : NSObject<NSCoding>


@property   float            fStartingWeight;
@property   NSMutableArray*            arrGoalWeight;
@property   CGoalWeightModel*           pGoalWeight;
@property   float            fChangeWeight;
@property   float            fCurrentWeight;
@property   NSInteger        unitWeight;
@property   float            fBMI;
@property   NSString*        strMeaning;

- (void)        inititalize;
- (void)        deleteAll;

@end
