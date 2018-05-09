//
//  CJournalSearchModel.m
//  LomiApp
//
//  Created by TwinkleStar on 12/16/16.
//  Copyright © 2016 twinklestar. All rights reserved.
//

#import "CJournalSearchModel.h"

@implementation CJournalSearchModel


- (void) inititalize
{
    [self deleteAll];
    
    self.offset = @"";
    self.pageID = @"";
    self.itemPerPage = @"";
    self.mealTypeId = @"";
    self.date = @"";
    self.approval = @"";
    self.photoId = @"";
    self.creationDate = @"";
    self.body = @"";
    self.hasComment = false;
    self.url = @"";
}

- (id)init
{
    if ((self = [super init]))
    {
        [self inititalize];
    }
    
    return self;
}

- (void) deleteAll
{
    
}
@end
