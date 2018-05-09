//
//  CUIViewSelectWUnit.h
//  LomiApp
//
//  Created by TwinkleStar on 12/5/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CUIViewSelectWUnitDelegate;

@interface CUIViewSelectWUnit : UIView

@property (nonatomic, weak) id<CUIViewSelectWUnitDelegate> delegate;

- (IBAction)onClickPounds:(id)sender;
- (IBAction)onClickKilograms:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end

@protocol CUIViewSelectWUnitDelegate <NSObject>

- (void)onWUnitSelected:(CUIViewSelectWUnit*)view type:(NSInteger)type
         didChooseUnit:(NSInteger)value;

@end
