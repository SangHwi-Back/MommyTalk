//
//  ContentView.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/18.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let viewModel = InitialViewModel()

    let detailInitialConfirmImageNames = [
        "DetailInitialConfirmImage1Cropped",
        "DetailInitialConfirmImage2Cropped",
        "DetailInitialConfirmImage3Cropped"
    ]
    
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    @State var selectedTabIndex: Int = 0
    @State var isConfirmed: Bool = !(UserDefaults.standard.value(forKey: "isConfirmed") as? Bool ?? false)
    
    var body: some View {
        Group {
            if appEnvironmentObject.isConfirmed {
                TabView(selection: $selectedTabIndex) {
                    SubContent280DaysView().tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("280 days")
                        }
                    }.tag(0)
                    SubContentSuperSonicWaveView().tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("초음파")
                        }
                    }.tag(1)
                    SubContentCommunityView(viewModel: SubContentCommunityViewModel()).tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("커뮤니티")
                        }
                    }.tag(2)
                    SubContentShoppingView().tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("쇼핑")
                        }
                    }.tag(3)
                    SubContentMyInfoView().tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("내정보")
                        }
                    }.tag(4)
                }
            } else {
                InitialConfirmView(self.detailInitialConfirmImageNames.map({DetailInitialConfirmView(imageName: $0)}))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "dismissModal"), object: nil, queue: nil) { [weak toPresent] _ in
            toPresent?.dismiss(animated: true, completion: nil)
        }
        self.present(toPresent, animated: true, completion: nil)
    }
}
