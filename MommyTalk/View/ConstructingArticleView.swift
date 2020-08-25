//
//  ConstructingArticleView.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/24.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

struct ConstructingArticleView: View {
    
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    var communityCategories: [String]
    var headers = ["말머리1","말머리2","말머리3","말머리4"]
    @State var articleTitle = ""
    @State var articleCategory = ""
    @State var showCommunityActionSheet = false
    @State var showHeaderActionSheet = false
    @State var selectedCommunity = ""
    @State var selectedHeader = ""
    @State var content: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        self.showCommunityActionSheet = true
                    }) {
                        HStack {
                            Text("게시판 선택")
                            Spacer()
                            Image(systemName: "arrow.down")
                        }.padding()
                    }
                    .actionSheet(isPresented: self.$showCommunityActionSheet) {
                        ActionSheet(
                            title: Text(verbatim: ""),
                            message: nil,
                            buttons: self.communityCategories.map({ item -> Alert.Button in
                                Alert.Button.default(Text(item)) {
                                    self.selectedCommunity = item
                                }
                            })
                        )
                    }
                    
                    Button(action: {
                        self.showHeaderActionSheet = true
                    }) {
                        HStack {
                            Text("말머리 선택")
                            Spacer()
                            Image(systemName: "arrow.down")
                        }.padding()
                    }.actionSheet(isPresented: self.$showHeaderActionSheet) {
                        ActionSheet(
                            title: Text(verbatim: ""),
                            message: nil,
                            buttons: self.headers.map({ item -> Alert.Button in
                                Alert.Button.default(Text(item)) {
                                    self.selectedHeader = item
                                }
                            })
                        )
                    }
                }
                    .foregroundColor(Color.gray.opacity(0.6))
                    .border(Color.gray.opacity(0.6), width: 1)
                TextField("제목을 입력해주세요", text: self.$articleTitle)
                    .padding()
                
                TextField("asdf", text: self.$content)
                    .padding()
            }
        }
        .navigationBarTitle(Text("글쓰기"), displayMode: .automatic)
        .navigationBarItems(leading: Text("취소"), trailing: Text("등록").onTapGesture {
            self.appEnvironmentObject.selectedTabBarIndex = 2
        })
            
    }
}

struct ConstructingArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ConstructingArticleView(communityCategories: [
            "명예의 전당", "인기", "최신", "마미꿀팁", "익명", "고민상담", "일상", "중고", "리뷰", "이벤트"
        ])
    }
}
