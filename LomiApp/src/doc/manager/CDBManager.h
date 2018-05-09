//
//  CDBManager.h
//
//  Created by apple on 9/23/15.
//  Copyright (c) 2015 apple. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "CGlobal.h"

static const NSString *CONSTANT_STR_DBNAME = @"LomiDB";

@interface CDBManager : NSObject

@property   NSString    *m_strDatabasePath;
@property   sqlite3     *m_eventDB;

/*
- (void) onFailedOpen;
- (void) onFailedInsert;
- (void) onFailedDelete;
- (void) onFailedUpdate;
- (void) onFailedLoad;
- (void) initDB;
- (void) denitDB;
- (void) insertNote:(CNoteModel*)mNote;
- (void) updateNote:(CNoteModel*)mNote;
- (void) deleteNote:(int)nID;
- (void) loadAllNotes;
*/
@end
