//
//  CPromotionInfoModel.h
//  LomiApp
//
//  Created by Aquari on 06/03/2018.
//  Copyright © 2018 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPromotionInfoModel : NSObject

@property NSInteger     packageID;
@property NSInteger     packageDuration;
@property float         packagePrice;
@property NSInteger     promotionValue;
@property float         promotionPrice;

@property NSString*     packageTitle;
@property NSString*     packageDescription;
@property NSString*     packageDurationType;
@property NSString*     promotionStatus;
@property NSString*     promotionType;

@property NSString*     promotionCode;
@property NSString*     totalPromotionStatus;
@property NSString*     message;
@end
