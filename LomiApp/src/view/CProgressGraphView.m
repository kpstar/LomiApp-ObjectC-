//
//  CProgressGraphView.m
//  LomiApp
//
//  Created by TwinkleStar on 12/13/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CProgressGraphView.h"

@implementation CProgressGraphView

@synthesize pWeightModel;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect
{
    CGFloat fYGap = 20;
    
    CGFloat fWidth = self.frame.size.width;
    CGFloat fHeight = self.frame.size.height - fYGap;
    UIFont *font = [UIFont systemFontOfSize:13.0];
    UIFont *font10 = [UIFont systemFontOfSize:12.0];
    UIFont *font15 = [UIFont systemFontOfSize:15.0];

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat fMax = MAX(g_pUserModel.pWeightModel.fStartingWeight, g_pUserModel.pWeightModel.fCurrentWeight);
    if (g_pUserModel.pWeightModel.pGoalWeight.fWeight != 0)
        fMax = MAX(fMax, g_pUserModel.pWeightModel.pGoalWeight.fWeight);
    
    CGFloat fMin = MIN(g_pUserModel.pWeightModel.fStartingWeight, g_pUserModel.pWeightModel.fCurrentWeight);
    if (g_pUserModel.pWeightModel.pGoalWeight.fWeight != 0)
        fMin = MIN(fMin, g_pUserModel.pWeightModel.pGoalWeight.fWeight);
    
    CGFloat fUpValue = ((int)(fMax / 10) + 2.5) * 10;
    CGFloat fDownValue = ((int)(fMin / 10) - 1.5) * 10;
    
//------ Goal
    if (g_pUserModel.pWeightModel.pGoalWeight.fWeight != 0)
    {
        UIBezierPath *goalLine = [UIBezierPath bezierPath];
        CGFloat fYGoal = fYGap + fHeight - (fHeight / (fUpValue - fDownValue)) * (g_pUserModel.pWeightModel.pGoalWeight.fWeight - fDownValue);
        [goalLine moveToPoint:CGPointMake(150.0, fYGoal)];
        [goalLine addLineToPoint:CGPointMake(fWidth, fYGoal)];
        goalLine.lineWidth = 3.0f;
        //[[UIColor  darkGrayColor] setStroke];
        [[UIColor colorWithRed:(140.0f / 255) green:(195.0f / 255) blue:(75.0f / 255) alpha:1] setStroke];
        [goalLine stroke];

        NSString* strGoal = NSLocalizedString(@"STR_YOURGOAL", @"");//@"YOUR GOAL";
        [strGoal drawAtPoint:CGPointMake(50.0, fYGoal - 6.5) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor lightGrayColor] }];
        
        NSString* strGoalDate = g_pUserModel.pWeightModel.pGoalWeight.strDate;
        if (strGoalDate != nil)
        {
            [strGoalDate drawAtPoint:CGPointMake(150, fYGoal + 1) withAttributes:@{NSFontAttributeName:font10, NSForegroundColorAttributeName:[UIColor  colorWithRed:(140.0f / 255) green:(195.0f / 255) blue:(75.0f / 255) alpha:1]}];
        }
        
        CGContextSetRGBStrokeColor(contextRef, 140.0f / 255, 195.0f / 255, 75.0f / 255, 1.0);
        CGContextSetLineWidth(contextRef, 1.0f);
        CGRect rc = CGRectMake(150.0 - 6, fYGoal - 3, 6, 6);
        CGContextStrokeEllipseInRect(contextRef, rc);
    }
//------

    
//------4 lines
    CGFloat fStep = fHeight / 4;
    UIBezierPath *fourLine = [UIBezierPath bezierPath];
    for (int i = 1; i < 4; i++)
    {
        [fourLine moveToPoint:CGPointMake(0.0, fStep * i + fYGap)];
        [fourLine addLineToPoint:CGPointMake(fWidth, fStep * i + fYGap)];
        
        NSString* strDownValue = [NSString stringWithFormat:@"%d", (int)(fUpValue - (fUpValue - fDownValue) / 4 * i)];
        [strDownValue drawAtPoint:CGPointMake(10.0, (fStep * i) + fYGap - 15) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    }
    NSString* strDownValue = [NSString stringWithFormat:@"%d", (int)(fDownValue)];
    [strDownValue drawAtPoint:CGPointMake(10.0, fHeight - 15 + fYGap) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    fourLine.lineWidth = 0.5f;
    [[UIColor  colorWithRed:(210.0f / 255) green:(210.0f / 255) blue:(210.0f / 255) alpha:1] setStroke];
    [fourLine stroke];
    
//------ Bezier
    CGFloat fYStart = fYGap + fHeight - (fHeight / (fUpValue - fDownValue)) * (g_pUserModel.pWeightModel.fStartingWeight - fDownValue);
    CGFloat fYCurrent = fYGap + fHeight - (fHeight / (fUpValue - fDownValue)) * (g_pUserModel.pWeightModel.fCurrentWeight - fDownValue);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50.0, fYStart)];
    [path addQuadCurveToPoint:CGPointMake(fWidth - 50, fYCurrent) controlPoint:CGPointMake((fWidth - 50) / 2, fYStart)];
    path.lineWidth = 3;
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setStroke];
    [path stroke];

//------- Start Weight
    CGContextSetRGBStrokeColor(contextRef, 255.0f / 255, 156.0f / 255, 19.0f / 255, 1.0);
    CGContextSetLineWidth(contextRef, 3.0f);
    CGRect rc = CGRectMake(40, fYStart- 3, 10, 10);
    CGContextStrokeEllipseInRect(contextRef, rc);
    
    CGRect bubbleBounds = CGRectMake(25, fYStart- 50, 60, 30);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:bubbleBounds cornerRadius:6.0];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setStroke];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setFill];
    [roundedRect fill];
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setStroke];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setFill];
    [triangle moveToPoint:CGPointMake(55, fYStart - 21)];
    [triangle addLineToPoint:CGPointMake(45, fYStart - 10)];
    [triangle addLineToPoint:CGPointMake(35, fYStart - 21)];
    [triangle closePath];
    [triangle fill];
    
    NSString* strStartWeight = [NSString stringWithFormat:@"%.1f %@", g_pUserModel.pWeightModel.fStartingWeight, g_pUserModel.pMobileSettingModel.strWeightUnit];
    CGFloat nStringWidth = [strStartWeight sizeWithAttributes:@{NSFontAttributeName:font15}].width;
    CGFloat nStringHeight = [strStartWeight sizeWithAttributes:@{NSFontAttributeName:font15}].height;
    [strStartWeight drawAtPoint:CGPointMake(5 + nStringWidth / 2, fYStart - 35 - nStringHeight / 2 ) withAttributes:@{NSFontAttributeName:font15, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSString* strStartDate = g_pUserModel.pStartBodyMeasurementModel.strCreationDate;
    if (strStartDate != nil)
    {
        nStringWidth = [strStartDate sizeWithAttributes:@{NSFontAttributeName:font10}].width;
        nStringHeight = [strStartDate sizeWithAttributes:@{NSFontAttributeName:font10}].height;
        [strStartDate drawAtPoint:CGPointMake(40 - nStringWidth / 2, 1 ) withAttributes:@{NSFontAttributeName:font10, NSForegroundColorAttributeName:[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1]}];
    }
    
//------- Current Weight
    CGContextSetRGBStrokeColor(contextRef, 255.0f / 255, 156.0f / 255, 19.0f / 255, 1.0);
    CGContextSetLineWidth(contextRef, 3.0f);
    rc = CGRectMake(fWidth - 50, fYCurrent- 3, 10, 10);
    CGContextStrokeEllipseInRect(contextRef, rc);
    
    bubbleBounds = CGRectMake(fWidth - 75, fYCurrent- 50, 60, 30);
    roundedRect = [UIBezierPath bezierPathWithRoundedRect:bubbleBounds cornerRadius:6.0];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setStroke];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setFill];
    [roundedRect fill];
    
    triangle = [UIBezierPath bezierPath];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setStroke];
    [[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1] setFill];
    [triangle moveToPoint:CGPointMake(fWidth - 55, fYCurrent - 21)];
    [triangle addLineToPoint:CGPointMake(fWidth - 45, fYCurrent - 10)];
    [triangle addLineToPoint:CGPointMake(fWidth - 35, fYCurrent - 21)];
    [triangle closePath];
    [triangle fill];
    
    NSString* strCurrentWeight = [NSString stringWithFormat:@"%.1f %@", g_pUserModel.pWeightModel.fCurrentWeight, g_pUserModel.pMobileSettingModel.strWeightUnit];
    nStringWidth = [strCurrentWeight sizeWithAttributes:@{NSFontAttributeName:font15}].width;
    nStringHeight = [strCurrentWeight sizeWithAttributes:@{NSFontAttributeName:font15}].height;
    [strCurrentWeight drawAtPoint:CGPointMake(fWidth - 45 - nStringWidth / 2, fYCurrent - 35 - nStringHeight / 2 ) withAttributes:@{NSFontAttributeName:font15, NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    NSString* strCurrentDate = g_pUserModel.pBodyMeasurementModel.strModifiedDate;
    if (strCurrentDate != nil)
    {
        nStringWidth = [strCurrentDate sizeWithAttributes:@{NSFontAttributeName:font10}].width;
        nStringHeight = [strCurrentDate sizeWithAttributes:@{NSFontAttributeName:font10}].height;
        [strCurrentDate drawAtPoint:CGPointMake(fWidth - 40 - nStringWidth / 2, 1 ) withAttributes:@{NSFontAttributeName:font10, NSForegroundColorAttributeName:[UIColor  colorWithRed:(255.0f / 255) green:(156.0f / 255) blue:(19.0f / 255) alpha:1]}];
    }

    
    
    
}

- (void) setData:(CWeightModel*)model
{
    pWeightModel = model;
    [self setNeedsDisplay];
}


@end
