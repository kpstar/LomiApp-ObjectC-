//
//  CMessageModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/15/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMessageModel : NSObject<NSCoding>

//For Message
@property   NSString*        body;
@property   NSString*        date;
@property   NSString*        sendername;
@property   NSString*        thumbnail;
@property   NSString*        username;
@property   NSInteger        userId;
@property   NSInteger        senderId;
@property   Boolean          isNutritionist;
@property   Boolean          isImage;
@property   NSInteger        schedule_id;

//For Journal Comment
@property   NSString*        bodyText;
@property   NSString*        commentDate;
@property   NSString*        commentImage;
@property   NSInteger        commentId;
@property   NSInteger        likeCount;
@property   UIImage*         image;

//For Journal Photo
@property   NSString*        mealTypeName;
@property   NSString*        photoStatus;
@property   NSString*        url;
@property   NSInteger        photoId;
@property   NSInteger        fileId;
@property   NSInteger        mealTypeId;
@property   BOOL             bIsLiked;

@property   Boolean          isForMessage;

- (void)        inititalize;
- (void)        deleteAll;

@end
