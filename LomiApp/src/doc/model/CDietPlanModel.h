//
//  CDietPlanModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/15/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDietPlanModel : NSObject<NSCoding>

@property   NSString*        date;
@property   NSString*        strDescription;
@property   NSString*        end_time;
@property   NSString*        owner_type;
@property   NSString*        parent_type;
@property   NSString*        start_time;
@property   NSString*        title;
@property   NSInteger        category_id;
@property   NSInteger        owner_id;
@property   NSInteger        parent_id;
@property   NSInteger        schedule_id;

- (void)        inititalize;
- (void)        deleteAll;

@end
