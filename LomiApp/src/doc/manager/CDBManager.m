//
//  CDBManager.m
//
//  Created by apple on 9/23/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "CDBManager.h"

@implementation CDBManager

@synthesize m_strDatabasePath, m_eventDB;

/*
- (void)onFailedOpen
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Fail"
                          message:@"Failed to open/create database."
                          delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)onFailedInsert
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Fail"
                          message:@"Failed to insert data into database."
                          delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)onFailedDelete
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Fail"
                          message:@"Failed to delete data from database."
                          delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)onFailedUpdate
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Fail"
                          message:@"Failed to update database."
                          delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)onFailedLoad
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Fail"
                          message:@"Failed to load datas from database."
                          delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil];
    [alert show];
}
- (void)initDB
{
    NSString *docsDir;
    NSArray *dirPaths;
 
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
 
    docsDir = dirPaths[0];
 
    // Build the path to the database file
    m_strDatabasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      CONSTANT_STR_DBNAME]];
 
    NSFileManager *filemgr = [NSFileManager defaultManager];
 
    if ([filemgr fileExistsAtPath: m_strDatabasePath ] == NO)
    {
        const char *dbpath = [m_strDatabasePath UTF8String];

        if (sqlite3_open(dbpath, &m_eventDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS NOTES (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, DATE TEXT, CONTENT TEXT)";
            
            if (sqlite3_exec(m_eventDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                [self onFailedOpen];
            }
            sqlite3_close(m_eventDB);
        }
        else
        {
            [self onFailedOpen];
        
        }
    }
}

- (void)denitDB
{
    //sqlite3_close(m_eventDB);
}

- (void) insertNote:(CNoteModel*)mNote
{
    sqlite3_stmt    *statement;
    const char *dbpath = [m_strDatabasePath UTF8String];
 
    if (sqlite3_open(dbpath, &m_eventDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO NOTES (TITLE, DATE, CONTENT) VALUES (\"%@\", \"%@\", \"%@\")",
                               mNote.m_strTitle, mNote.m_strDate, mNote.m_strContent];

        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(m_eventDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
        
        }
        else
        {
            [self onFailedInsert];
        }
        sqlite3_finalize(statement);
        sqlite3_close(m_eventDB);
    }
}

- (void) updateNote:(CNoteModel*)mNote
{
    sqlite3_stmt    *statement;
    const char *dbpath = [m_strDatabasePath UTF8String];
    
    if (sqlite3_open(dbpath, &m_eventDB) == SQLITE_OK)
    {
    
    NSString *updateSQL = [NSString stringWithFormat:
                           @"UPDATE NOTES SET TITLE='%@', DATE='%@', CONTENT='%@' WHERE ID=%d",
                           mNote.m_strTitle, mNote.m_strDate, mNote.m_strContent, mNote.m_nId];
        NSString *updateSQL = @"UPDATE NOTES SET TITLE=?, DATE=?, CONTENT=? WHERE ID=?";

    const char *update_stmt = [updateSQL UTF8String];
        
    int nRet = sqlite3_prepare_v2(m_eventDB, update_stmt,
                       -1, &statement, NULL);
    if (nRet == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [mNote.m_strTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [mNote.m_strDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [mNote.m_strContent UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 4, mNote.m_nId);

        
    if (sqlite3_step(statement) == SQLITE_DONE)
    {

    }
    else
    {
        [self onFailedUpdate];
    }
        
    sqlite3_finalize(statement);
    }
    sqlite3_close(m_eventDB);
    }
}

- (void) deleteNote:(int)nID
{
    sqlite3_stmt    *statement;
    const char *dbpath = [m_strDatabasePath UTF8String];
    
    if (sqlite3_open(dbpath, &m_eventDB) == SQLITE_OK)
    {
    
    NSString *deleteSQL = [NSString stringWithFormat:
                           @"DELETE FROM NOTES WHERE ID=%d", nID];
    
    const char *delete_stmt = [deleteSQL UTF8String];
    sqlite3_prepare_v2(m_eventDB, delete_stmt,
                       -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        
    }
    else
    {
        [self onFailedDelete];
    }
    sqlite3_finalize(statement);
    sqlite3_close(m_eventDB);
    }
}

- (void) loadAllNotes
{
    const char *dbpath = [m_strDatabasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &m_eventDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM NOTES ORDER BY ID DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(m_eventDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (g_arrNotes == nil)
                g_arrNotes = [[NSMutableArray alloc] init];
            [g_arrNotes removeAllObjects];
 
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                CNoteModel *pNoteModel = [[CNoteModel alloc] init];
                
                pNoteModel.m_nId = (NSInteger)sqlite3_column_int(
                                                                 statement, 0);
                
                pNoteModel.m_strTitle = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(
                                                                             statement, 1)];
                pNoteModel.m_strDate = [[NSString alloc]
                                         initWithUTF8String:
                                         (const char *) sqlite3_column_text(
                                                                            statement, 2)];
                pNoteModel.m_strContent = [[NSString alloc]
                                        initWithUTF8String:
                                        (const char *) sqlite3_column_text(
                                                                           statement, 3)];
                
                [g_arrNotes addObject:pNoteModel];
            }
    
            sqlite3_finalize(statement);
        }
        sqlite3_close(m_eventDB);
    }
}
*/
@end
