//
//  CNotificationModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/19/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CNotificationModel : NSObject

@property   NSString*       body;
@property   NSString*       date;
@property   NSString*       objectType;
@property   NSString*       subjectType;
@property   NSString*       type;
@property   NSInteger       notificationId;
@property   NSInteger       objectId;
@property   NSInteger       subjectId;
@property   NSInteger       read;
@property   Boolean         bIsNew;
@property   NSString*       photoDate;
@end
