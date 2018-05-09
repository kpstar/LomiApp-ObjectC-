//
//  CPaymentPlanModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/25/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPaymentPlanModel : NSObject

@property   NSInteger        packageID;
@property   NSInteger        packageDuration;
@property   float            packagePrice;

@property   NSString*        packageTitle;
@property   NSString*        packageDescription;
@property   NSString*        packageDurationType;

@property   NSString*        packageExpirationDate;
@property   NSString*        promotionStatus;
@property   NSString*        promotionCode;
@property   NSInteger        orderId;

@end
