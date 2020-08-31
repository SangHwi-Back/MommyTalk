//
//  ConstructingArticleView.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/24.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI
import UIKit

struct ConstructingArticleView: View {
    @ObservedObject var viewModel: SubContentCommunityViewModel
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    var communityCategories = ["","마미꿀팁","익명","고민상담","일상","중고","리뷰"]
    var headers = ["","말머리1","말머리2","말머리3","말머리4"]
    
    @State var articleCategory = ""
    @State var content: String = ""
    //isHashTag
    //profileImageID
    //replyCount
    //rowCreated
    //id
    @State var articleTitle = ""
    
    @State var showCommunityActionSheet = false
    @State var showHeaderActionSheet = false
    @State var selectedCommunity = ""
    @State var selectedHeader = ""
    
    let contentPlaceHolder =
"""
함께 나누고 싶은 내용을 입력해주세요 :)
서로를 존중하고 책임감 있는 모습을 기대할게요.
부적절한 글은 검토 후 자동으로 숨김 처리될 수 있습니다.
"""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        self.showCommunityActionSheet = true
                    }) {
                        HStack {
                            Text(self.selectedCommunity == "" ? "게시판 선택" : self.selectedCommunity).foregroundColor(Color.gray.opacity(0.6))
                            Spacer()
                            Image(systemName: "arrow.down").foregroundColor(Color.black)
                        }.padding()
                    }.actionSheet(isPresented: self.$showCommunityActionSheet) {
                        ActionSheet(
                            title: Text(verbatim: ""),
                            message: nil,
                            buttons: self.communityCategories.map({ item -> Alert.Button in
                                if item == "" {
                                    return Alert.Button.cancel(Text("취소"))
                                } else {
                                    return Alert.Button.default(Text(item)) {
                                        if item != "" { self._selectedCommunity.wrappedValue = item }
                                    }
                                }
                            })
                        )
                    }
                    
                    Button(action: {
                        self.showHeaderActionSheet = true
                    }) {
                        HStack {
                            Text(self.selectedHeader == "" ? "선택안함" : self.selectedHeader)
                            Spacer()
                            Image(systemName: "arrow.down")
                        }.padding()
                    }.actionSheet(isPresented: self.$showHeaderActionSheet) {
                        ActionSheet(
                            title: Text(verbatim: ""),
                            message: nil,
                            buttons: self.headers.map({ item -> Alert.Button in
                                if item == "" {
                                    return Alert.Button.cancel()
                                } else {
                                    return Alert.Button.default(Text(item)) {
                                        if item != "" { self._selectedHeader.wrappedValue = item }
                                    }
                                }
                            })
                        )
                    }.foregroundColor(Color.black)
                }.background(Color.white).border(Color.gray.opacity(0.6), width: 1)
                
                TextField("제목을 입력해주세요", text: self.$articleTitle)
                    .padding()
                    .background(Color.white)
                    .padding(.vertical, 1)
                
                CustomUITextView(content: $content, contentPlaceHolder: contentPlaceHolder)
                    .padding(.top, 4)
                    .padding(.bottom ,1)
                
                HStack {
                    Spacer()
                    Image(systemName: "photo.fill").font(.system(size: 22)).padding()
                    ZStack(alignment: .center) {
                        Text("GIF").padding(5).border(Color.black, width: 1)
                    }.padding(.trailing, 10)
                }.background(Color.white)
            }
            .navigationBarTitle(Text("글쓰기"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY.MM.dd"
                    dateFormatter.locale = Locale(identifier: "ko_KR")

                    let article = Article(
                        category: self._selectedCommunity.wrappedValue, content: self._content.wrappedValue,
                        isHashTag: 0, profileImageId: "",
                        replyCount: 0, rowCreated: dateFormatter.string(from: Date()),
                        id: UUID().uuidString, title: self._articleTitle.wrappedValue,
                        userLevel: "1", userName: "테스트유저", viewCount: 1)

                    if self.viewModel.createCommunityArticle(article: article) {
                        print("Insert Success")
                    } else {
                        print("Insert Failed")
                    }
                    
                }) {
                    Text("등록")
                }.foregroundColor(.gray)
            )
        }.background(Color.init(white: 0.9))
    }
}

struct CustomUITextView: UIViewRepresentable {
    
    @Binding var content: String
    var contentPlaceHolder: String
    
    func makeUIView(context: Context) -> UITextView {
        let customUITextView = UITextView()
        customUITextView.delegate = context.coordinator
        customUITextView.selectedRange = NSRange(location: 0, length: 0)
        return customUITextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        context.coordinator.textViewSetupView(textView: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(content: $content, contentPlaceHolder: contentPlaceHolder)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var content: String
        var contentPlaceHolder: String
        var isPlaceHolderShow = false
        
        init(content: Binding<String>, contentPlaceHolder: String) {
            self._content = content
            self.contentPlaceHolder = contentPlaceHolder
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            if isPlaceHolderShow {
                textView.text = ""
                textView.textColor = .black
                isPlaceHolderShow = false
            }
            
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.$content.wrappedValue = textView.text
                textView.selectedRange.length = textView.text.count
                if textView.text == "" {
                    self.textViewSetupView(textView: textView)
                }
            }
        }
        
        func textViewSetupView(textView: UITextView) {
            if textView.text == "" {
                textView.text = self.contentPlaceHolder
                textView.textColor = .gray
                self.isPlaceHolderShow = true
                textView.resignFirstResponder()
            }
        }
    }
}

struct ConstructingArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ConstructingArticleView(viewModel: SubContentCommunityViewModel(), communityCategories: [
            "명예의 전당", "인기", "최신", "마미꿀팁", "익명", "고민상담", "일상", "중고", "리뷰", "이벤트"
        ])
    }
}
