//
//  CommunityArticles.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/23.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import Foundation
import SQLite3

struct CommunityLists<ArticleId> where ArticleId: Equatable {
    private(set) var articles: Array<Article>
    
    private var category: String
    private var dbUtil: SQLiteDatabaseUtil
    
    init(_ category: String, dbUtil: SQLiteDatabaseUtil) {
        self.category = category
        self.dbUtil = dbUtil
        self.articles = self.dbUtil.queryCommunityArticles(category: self.category)
    }
    
    mutating func queryArticles(_ category: String) {
        self.articles = dbUtil.queryCommunityArticles(category: category)
    }
    
    func createCommunityArticle(article: Article) -> Bool {
        return dbUtil.createCommunityArticle(article: article)
    }
    
    func deleteCommunityArticle(id: String) -> Bool {
        return dbUtil.deleteCommunityArticle(id: id)
    }
    
}

struct Article {
    var category: String
    var content: String
    var isHashTag: Int
    var profileImageId: String
    var replyCount: Int
    var rowCreated: String
    var id: String
    var title: String
    var userLevel: String
    var userName: String
    var viewCount: Int
    
    init(category: String, content: String, isHashTag: Int, profileImageId: String, replyCount: Int, rowCreated: String, id: String, title: String, userLevel: String, userName: String, viewCount: Int) {
        self.category = category
        self.content = content
        self.isHashTag = isHashTag
        self.profileImageId = profileImageId
        self.replyCount = replyCount
        self.rowCreated = rowCreated
        self.id = id
        self.title = title
        self.userLevel = userLevel
        self.userName = userName
        self.viewCount = viewCount
    }
    init(_ category: String) {
        self.category = category
        self.content = ""
        self.isHashTag = 0
        self.profileImageId = ""
        self.replyCount = 0
        self.rowCreated = ""
        self.id = ""
        self.title = ""
        self.userLevel = ""
        self.userName = ""
        self.viewCount = 0
    }
    
}
