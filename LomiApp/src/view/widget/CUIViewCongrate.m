//
//  CUIViewCongrate.m
//  LomiApp
//
//  Created by TwinkleStar on 1/16/17.
//  Copyright © 2017 twinklestar. All rights reserved.
//

#import "CUIViewCongrate.h"
#import "CGlobal.h"

@implementation CUIViewCongrate

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onClickClose:(id)sender
{
    [self removeFromSuperview];
}

- (void)initView
{
    NSString *strName = [NSString stringWithFormat:@"%@ %@", g_pUserModel.strFirstName,g_pUserModel.strLastName];
    
    
    if (g_pUserModel.strFirstName != nil)
    {
        NSString* strDesc = [NSString stringWithFormat:@"%@, %@", strName, NSLocalizedStringFromTable(@"cpU-Ju-L2q.text", @"CUIViewCongrate", @"")];
        self.m_tvDesc.text = strDesc;
    }
    else
    {
        NSString* strDesc = NSLocalizedStringFromTable(@"cpU-Ju-L2q.text", @"CUIViewCongrate", @"");
        self.m_tvDesc.text = strDesc;
    }
}

@end
