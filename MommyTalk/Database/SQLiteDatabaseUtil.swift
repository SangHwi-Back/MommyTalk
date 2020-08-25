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
    
    func queryCommunityArticles(_ category: String) -> [Article] {
        var queryStatement: OpaquePointer? = nil
        let statement = "SELECT category, content, isHashTag, profileImageId, replyCount, rowCreated, id, title, userLevel, userName, viewCount FROM CommunityArticles WHERE CATEGORY = '\(category)'"
        var result = [Article]()
        defer { sqlite3_finalize(queryStatement) }
        
        if sqlite3_prepare_v2(SQLiteDatabase, statement, EOF, &queryStatement, nil) != SQLITE_OK {
            print("!!!SQLITE error in !!! qlite3_prepare_v2(SQLiteDatabase, category, EOF, &queryStatement, nil)")
            result.append(Article(category))
            return result
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
}
