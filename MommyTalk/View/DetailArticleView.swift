//
//  DetailArticleView.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/24.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

struct DetailArticleView: View {
    
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    
    var articleData: Article
    
    var body: some View {
        NavigationView {
            ScrollView {
                NavigationLink(destination: ContentView(appEnvironmentObject: self._appEnvironmentObject)) {
                    HStack {
                        Text("마미꿀팁")
                            .foregroundColor(Color.blue.opacity(0.8))
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal, 17).padding(.vertical, 15)
                }.padding(.top, 5)
                
                if self.articleData.isHashTag == 0 {
                    Text("[EVENT] \(self.articleData.title)")
                } else if self.articleData.isHashTag == 1 {
                    Text("#HashTag ").foregroundColor(.red)+Text(self.articleData.title)
                }
            }
        }
        .navigationBarItems(leading: Text(""))
        .navigationBarTitle(Text(self.articleData.category), displayMode: .large)
        .background(Color.init(white: 0.7))
    }
}

struct DetailArticleView_Previews: PreviewProvider {
    static var previews: some View {
        DetailArticleView(articleData: Article("명예의 전당"))
    }
}
