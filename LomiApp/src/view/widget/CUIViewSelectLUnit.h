//
//  CUIViewSelectLUnit.h
//  LomiApp
//
//  Created by TwinkleStar on 12/5/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CUIViewSelectLUnitDelegate;

@interface CUIViewSelectLUnit : UIView

@property (nonatomic, weak) id<CUIViewSelectLUnitDelegate> delegate;

- (IBAction)onClickCentimetrs:(id)sender;
- (IBAction)onClickInches:(id)sender;
- (IBAction)onClickCancel:(id)sender;
- (IBAction)onClickFeets:(id)sender;

@end

@protocol CUIViewSelectLUnitDelegate <NSObject>

- (void)onLUnitSelected:(CUIViewSelectLUnit*)view type:(NSInteger)type
          didChooseUnit:(NSInteger)value;

@end
