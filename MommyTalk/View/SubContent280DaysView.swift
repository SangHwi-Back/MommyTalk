//
//  ContentSubView280Days.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/18.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

struct SubContent280DaysView: View {
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    var body: some View {
        VStack {
            Text("280")
            Button(action: {
                UserDefaults.standard.set(false, forKey: "isConfirmed")
                self.appEnvironmentObject.isConfirmed = false
            }, label: {
                Text("X")
                    .frame(width: 30, height: 30, alignment: .center)
                    .font(.footnote)
            })
                .foregroundColor(.white)
                .background(Color(UIColor.brown))
                .cornerRadius(30)
        }
    }
}

struct SubContent280DaysView_Previews: PreviewProvider {
    static var previews: some View {
        SubContent280DaysView()
    }
}
