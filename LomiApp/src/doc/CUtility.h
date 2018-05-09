//
//  CUtility.h
//  MySplittBill
//
//  Created by apple on 3/14/14.
//  Copyright (c) 2014 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CUtility : NSCoder


+ (UIImage *)   fixRotation:(UIImage *)image;
+ (UIImage *)   resizeImage:(UIImage *)orginalImage;
+ (UIImage *)   imageByCroppingImage:(UIImage *)image toSize:(CGSize)size;
+ (NSString *)  encodeToBase64String:(UIImage *)image;
+ (UIImage *)   decodeBase64ToImage:(NSString *)strEncodeData;
+ (NSInteger)   age:(NSString*)birthday;
+ (NSInteger)   daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;
+ (NSString*)   stringFromInch:(float)value;
+ (NSString*)   getDeviceUTCOffset;
+ (NSString*)   metaString;
@end
