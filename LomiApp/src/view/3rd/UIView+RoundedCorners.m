//
//  UIView+RoundedCorners.m
//
//  Created by Warren Moore on 9/28/10.
//  Copyright (c) 2010 Auerhaus Development, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIView+RoundedCorners.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (RoundedCorners)

-(void)setRoundedCorners:(UIViewRoundedCornerMask)corners radius:(CGFloat)radius {
	CGRect rect = self.bounds;
	CGFloat minx = CGRectGetMinX(rect);
	CGFloat midx = CGRectGetMidX(rect);
	CGFloat maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect);
	CGFloat midy = CGRectGetMidY(rect);
	CGFloat maxy = CGRectGetMaxY(rect);

	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, minx, midy);
	CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, (corners & UIViewRoundedCornerUpperLeft) ? radius : 0);
	CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, (corners & UIViewRoundedCornerUpperRight) ? radius : 0);
	CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, (corners & UIViewRoundedCornerLowerRight) ? radius : 0);
	CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, (corners & UIViewRoundedCornerLowerLeft) ? radius : 0);
	CGPathCloseSubpath(path);

	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	[maskLayer setPath:path];
	[[self layer] setMask:nil];
	[[self layer] setMask:maskLayer];
	CFRelease(path);
}

@end
