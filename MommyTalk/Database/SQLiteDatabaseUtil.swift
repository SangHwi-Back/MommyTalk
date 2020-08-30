//
//  File.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/23.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabaseUtil {
    
    let SQLiteDatabase: OpaquePointer?
    
    init(database: OpaquePointer) {
        self.SQLiteDatabase = database
    }
    
    func queryCommunityArticles(category: String) -> [Article] {        
        var queryStatement: OpaquePointer? = nil
        let statement = """
            SELECT
                CATEGORY,
                CONTENT,
                ISHASHTAG,
                PROFILEIMAGEID,
                REPLYCOUNT,
                ROWCREATED,
                ID,
                TITLE,
                USERLEVEL,
                USERNAME,
                VIEWCOUNT
            FROM
                COMMUNITYARTICLES
            WHERE CATEGORY = ?
        """
        var result = [Article]()
        
        defer { sqlite3_finalize(queryStatement) }
        
        if sqlite3_prepare_v2(SQLiteDatabase, statement, EOF, &queryStatement, nil) != SQLITE_OK {
            print("!!!SQLITE error in !!! qlite3_prepare_v2(SQLiteDatabase, category, EOF, &queryStatement, nil)")
            result.append(Article(category))
            return result
        } else {
            sqlite3_bind_text(queryStatement, 1, category, -1, nil)
        }
        
        while sqlite3_step(queryStatement) == SQLITE_ROW {
            result.append(
                Article(
                    category: String(cString: sqlite3_column_text(queryStatement, 0)),
                    content: String(cString: sqlite3_column_text(queryStatement, 1)),
                    isHashTag: Int(sqlite3_column_int(queryStatement, 2)),
                    profileImageId: String(cString: sqlite3_column_text(queryStatement, 3)),
                    replyCount: Int(sqlite3_column_int(queryStatement, 4)),
                    rowCreated: String(cString: sqlite3_column_text(queryStatement, 5)),
                    id: String(cString: sqlite3_column_text(queryStatement, 6)),
                    title: String(cString: sqlite3_column_text(queryStatement, 7)),
                    userLevel: String(cString: sqlite3_column_text(queryStatement, 8)),
                    userName: String(cString: sqlite3_column_text(queryStatement, 9)),
                    viewCount: Int(sqlite3_column_int(queryStatement, 10))
                )
            )
        }
        
        return result
    }
    
    @discardableResult
    func createCommunityArticle(article: Article) -> Bool {
        guard let SQLiteDatabase = SQLiteDatabase else { return false }
        
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = """
            INSERT INTO COMMUNITYARTICLES
                (CATEGORY,
                ID,
                TITLE,
                CONTENT,
                ISHASHTAG,
                PROFILEIMAGEID,
                USERNAME,
                USERLEVEL,
                ROWCREATED,
                VIEWCOUNT,
                REPLYCOUNT)
            VALUES
                (?,?,?,?,?,?,?,?,?,?,?)
        """
        
        defer { sqlite3_finalize(insertStatement) }
        
        if sqlite3_prepare_v2(SQLiteDatabase, insertStatementString, EOF, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, article.category, -1, nil)
            sqlite3_bind_text(insertStatement, 2, article.id, -1, nil)
            sqlite3_bind_text(insertStatement, 3, article.title, -1, nil)
            sqlite3_bind_text(insertStatement, 4, article.content, -1, nil)
            sqlite3_bind_int(insertStatement, 5, Int32(article.isHashTag))
            sqlite3_bind_text(insertStatement, 6, article.profileImageId, -1, nil)
            sqlite3_bind_text(insertStatement, 7, article.userName, -1, nil)
            sqlite3_bind_text(insertStatement, 8, article.userLevel, -1, nil)
            sqlite3_bind_text(insertStatement, 9, article.rowCreated, -1, nil)
            sqlite3_bind_int(insertStatement, 10, Int32(article.viewCount))
            sqlite3_bind_int(insertStatement, 11, Int32(article.replyCount))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    @discardableResult
    func deleteCommunityArticle(id: String) -> Bool {
        guard let SQLiteDatabase = SQLiteDatabase else { return false }
        
        var deleteStatement: OpaquePointer? = nil
        let deleteStatementString = "DELETE FROM COMMUNITYARTICLES WHERE ID = ?"
        
        defer { sqlite3_finalize(deleteStatement) }
        
        if sqlite3_prepare_v2(SQLiteDatabase, deleteStatementString, EOF, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, id, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
