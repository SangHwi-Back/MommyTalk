//
//  SubContentCommunityViewModel.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/23.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import Foundation
import SwiftUI

class SubContentCommunityViewModel: ObservableObject {
    
    private var model: CommunityLists<String> = createCategoryArticles()
    private(set) var articles: [Article]
    private(set) var category: String
    private var appDelegate: AppDelegate
    
    init(_ category: String = "명예의 전당") {
        self.category = category
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.model.queryMostRepliedArticles(count: 100)
        self.articles = self.model.articles
    }
    
    private static func createCategoryArticles(_ category: String = "명예의 전당") -> CommunityLists<String> {
        return CommunityLists(category, dbUtil: (UIApplication.shared.delegate as! AppDelegate).sQLiteDatabaseUtil!)
    }
    
    func getArticles(category: String) -> [Article] {
        if category == "명예의 전당" {
            self.model.queryMostRepliedArticles(count: 100)
        } else if category == "인기" {
            self.model.queryMostWatchedArticles(count: 100)
        } else {
            self.model.queryArticles(self.category)
        }
        
        self.articles = self.model.articles
        
        return self.model.articles
    }
    
    func createCommunityArticle(article: Article) -> Bool {
        return model.createCommunityArticle(article: article)
    }
    
    func deleteCommunityArticle(id: String) -> Bool {
        return model.deleteCommunityArticle(id: id)
    }
}
