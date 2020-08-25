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
    
    @Published private var model: CommunityLists<String> = createCategoryArticles()
    
    var category: String
    var appDelegate: AppDelegate
    
    init(_ category: String = "명예의 전당") {
        self.category = category
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    private static func createCategoryArticles(_ category: String = "명예의 전당") -> CommunityLists<String> {
        return CommunityLists("명예의 전당", dbUtil: (UIApplication.shared.delegate as! AppDelegate).sQLiteDatabaseUtil!)
    }
    
    func getArticles() -> [Article] {
        return model.articles
    }
    
    func queryOtherArticles(_ category: String) {
        model.queryArticles(category)
    }
    
}
