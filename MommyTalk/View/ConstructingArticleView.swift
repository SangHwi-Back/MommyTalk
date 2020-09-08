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
    var headers = ["","태교","임신건강","임신라이프","임신영양","출산","육아","선택안함"]
    let communityCategories2 = [
        "", "최신", "마미꿀팁", "익명", "고민상담", "일상", "중고", "리뷰", "이벤트"
    ]
    
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
                    ActionSheetButton(isShow: $showCommunityActionSheet, selectedValue: $selectedCommunity, dataArray: communityCategories2, blankValue: "게시판 선택")
                    ActionSheetButton(isShow: $showHeaderActionSheet, selectedValue: $selectedHeader, dataArray: headers, blankValue: "말머리 선택")
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

                    let article = Article(category: self.selectedCommunity, content: self.content, isHashTag: 0, profileImageId: "", replyCount: 0, rowCreated: dateFormatter.string(from: Date()), id: UUID().uuidString, title: self.articleTitle, userLevel: "1", userName: "테스트유저", viewCount: 1)

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

struct ActionSheetButton: View {
    @Binding var isShow: Bool
    @Binding var selectedValue: String
    var dataArray: [String]
    var blankValue: String
    
    var body: some View {
        Button(action: {
            self.$isShow.wrappedValue = true
        }) {
            HStack {
                Text(self.selectedValue == "" ? blankValue : self.selectedValue)
                Spacer()
                Image(systemName: "arrow.down")
            }.padding()
        }
        .actionSheet(isPresented: self.$isShow) {
            ActionSheet(
                title: Text(verbatim: ""),
                message: nil,
                buttons: self.dataArray.map({ item -> Alert.Button in
                    if item == "" {
                        return Alert.Button.cancel()
                    } else {
                        return Alert.Button.default(Text(item)) {
                            if item != "" { self._selectedValue.wrappedValue = item }
                        }
                    }
                })
            )
        }
//        .sheet(isPresented: self.$isShow, content: {
//            Picker(selection: self.$selectedValue, label: Text("")) {
//                ForEach(0 ..< self.dataArray.count) {
//                    Text(self.dataArray[$0]).id(self.dataArray[$0])
//                }
//            }
//        })
        .foregroundColor(self.selectedValue == "" ? .gray : .black)
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
        ConstructingArticleView(
            viewModel: SubContentCommunityViewModel()        )
    }
}
