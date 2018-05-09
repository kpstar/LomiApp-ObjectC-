//
//  CUIViewSelectWUnit.h
//  LomiApp
//
//  Created by TwinkleStar on 12/5/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CUIViewSelectUnitDelegate;

@interface CUIViewSelectUnit : UIView

@property (nonatomic, weak) id<CUIViewSelectUnitDelegate> delegate;

- (IBAction)onClickPounds:(id)sender;
- (IBAction)onClickKilograms:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end

@protocol CUIViewSelectUnitDelegate <NSObject>

- (void)onUnitSelected:(CUIViewSelectUnit*)view type:(NSInteger)type
         didChooseUnit:(NSInteger)value;

@end
