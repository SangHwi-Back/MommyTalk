//
//  CommunityRow.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/22.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

struct CommunityRow: View {
    
    var replyCount: Int = 0
    var rowTitle: String = ""
    var isHashTag: Int
    var profileImageId: UUID?
    var userName: String?
    var userLevel: String?
    var rowCreated: String
    var viewCount: Int = 0
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                (Text(self.isHashTag == 0 ? "[Event] " : (self.isHashTag == 1 ? "#HashTag " : "없음 "))+Text(self.rowTitle))
                    .font(.callout)
                    .lineLimit(2).frame(alignment: .leading)
                HStack {
                    Image(self.profileImageId?.uuidString ?? "defaultProfile")
                    Text(self.userName ?? "Unknown")
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(Color.blue.opacity(0.3))
                        Text(userLevel == nil ? "Lv. 0" : "Lv. \(userLevel!)")
                            .padding(.horizontal, 6).padding(.vertical, 2)
                    }
                    .fixedSize()
                    Image("communityRowClockImage")
                    Text(rowCreated)
                    Image("communityRowEyeImage")
                    Text("\(self.viewCount)")
                    Spacer()
                }.foregroundColor(Color.gray.opacity(0.7)).font(.footnote)
            }
            
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                VStack {
                    Text(self.replyCount > 999 ? "999+" : "\(self.replyCount)")
                    Text("댓글")
                        .foregroundColor(.gray)
                }.padding().font(.caption)
            }.fixedSize()
        }
        .padding(5)
    }
}
