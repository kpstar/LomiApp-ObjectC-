//
//  CJournalSearchModel.h
//  LomiApp
//
//  Created by TwinkleStar on 12/16/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CJournalSearchModel : NSObject

//for Photo
@property   NSString*        offset;
@property   NSString*        pageID;
@property   NSString*        itemPerPage;
@property   NSString*        mealTypeId;
@property   NSString*        date;
@property   NSString*        approval;
//for Comment
@property   NSString*        photoId;
//for Post Photo
@property   NSString*        creationDate;
@property   UIImage*         photo;
//for Post Comment
@property   NSString*        body;
@property   Boolean          hasComment;

//for Return Value
@property   NSInteger        nPhotoId;
@property   NSString*        url;
//for JournalMessage
@property   NSInteger        indexOfPhoto;
@property   NSInteger        indexOfComment;

@property   NSString*        strMessage;

- (void)        inititalize;
- (void)        deleteAll;

@end
