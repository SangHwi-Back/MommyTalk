//
//  SubContentCommunityView.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/18.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

struct SubContentCommunityView: View {
    
    @ObservedObject var viewModel: SubContentCommunityViewModel
    
    @State var selectedCommunityIndex: Int = 0
    @State var selectedRowId: String?
    
    let communityCategories = [
        "명예의 전당", "인기", "최신", "마미꿀팁", "익명", "고민상담", "일상", "중고", "리뷰", "이벤트"
    ]
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("커뮤니티")
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding(.horizontal, 17).padding(.vertical, 5)
                    .background(Color.white)
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            ForEach(0 ..< communityCategories.count) { inx in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(self.$selectedCommunityIndex.wrappedValue == inx ? .yellow : .white)
                                    Button(action: {
                                        self.selectedCommunityIndex = inx
                                        self.viewModel.queryOtherArticles(self.communityCategories[self.selectedCommunityIndex]) // 다른 카테고리의 게시글을 가져온다.
                                    }) {
                                        Text(self.communityCategories[inx])
                                            .font(.subheadline).foregroundColor(.black)
                                            .scaledToFill()
                                            .padding(.horizontal, 10).padding(.vertical, 5)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 17).padding(.vertical, 10).background(Color.white)
                    .padding(.bottom, 5)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    ZStack {
                        CommunityListView(category: self.communityCategories[selectedCommunityIndex], articles: self.viewModel.getArticles())
                        GeometryReader { geometry in
                            NavigationLink(destination: ConstructingArticleView(viewModel: self.viewModel)) {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color.white)
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.yellow)
                                        .font(.largeTitle)
                                }
                            }
                            .frame(width: geometry.size.width / 10,
                                   height: geometry.size.width / 10,
                                   alignment: .center)
                                .position(x: geometry.size.width - (geometry.size.width / 10) - 10,
                                          y: geometry.size.height - (geometry.size.height / 10) - 10)
                        }
                    }.background(Color.white)
                }
                .background(Color.init(white: 0.9))
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct CommunityListView: View {
    var category: String
    var articles: [Article]
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if articles.count == 0 {
            Text("게시글이 없습니다.").foregroundColor(.red).font(.largeTitle)
        } else {
            List(0 ..< self.articles.count) { inx in
                NavigationLink(destination: DetailArticleView(articleData: self.articles[inx])) {
                    CommunityRow(
                        replyCount: self.articles[inx].replyCount,
                        rowTitle: self.articles[inx].title,
                        isHashTag: self.articles[inx].isHashTag,
                        profileImageId: nil,
                        userName: self.articles[inx].userName,
                        userLevel: self.articles[inx].userLevel,
                        rowCreated: self.articles[inx].rowCreated,
                        viewCount: self.articles[inx].viewCount
                    )
                }
            }
        }
    }
}

struct SubContentCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        SubContentCommunityView(viewModel: SubContentCommunityViewModel())
    }
}
