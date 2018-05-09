//
//  CProgressGraphView.h
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGlobal.h"
#import "CWeightModel.h"

@interface CProgressGraphView : UIView

@property   CWeightModel            *pWeightModel;

- (void) setData:(CWeightModel*)model;

@end
