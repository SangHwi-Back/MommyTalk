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
                        CommunityListView(category: self.communityCategories[selectedCommunityIndex])
                            .environmentObject(self.viewModel)
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
    @EnvironmentObject var viewModel: SubContentCommunityViewModel
    var category: String
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        List(self.viewModel.getArticles(category: self.category).indices, id: \.self) { articleIndex in
            NavigationLink(destination: DetailArticleView(articleData: self.viewModel.articles[articleIndex])) {
                CommunityRow(article: self.viewModel.articles[articleIndex])
            }
        }.onAppear {
            self.viewModel.objectWillChange.send()
        }
    }
}

struct SubContentCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        SubContentCommunityView(viewModel: SubContentCommunityViewModel())
    }
}
