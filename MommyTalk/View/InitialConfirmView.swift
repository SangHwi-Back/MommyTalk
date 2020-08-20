//
//  InitialConfirmView.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/18.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//  referenced ::: https://mildwhale.github.io/2020-03-12-Interfacing-with-UIKit-1/
//

import UIKit
import SwiftUI
import Combine

struct InitialConfirmView<Page: View>: View {
    @State var policyShow: Bool = false
    @State var privateAgreementShow: Bool = false
    @State var eventNotificationShow: Bool = false
    @State var currentIndex: Int = 0
//    @Binding var isConfirmed: Bool
    
    @EnvironmentObject var appEnvironmentObject: AppEnvironmentObject
    
    var viewControllers: [UIHostingController<Page>]
    
//    init(_ views: [Page], _ isConfirmed: Binding<Bool>) {
//        self.viewControllers = views.map{ UIHostingController(rootView: $0) }
//        self._isConfirmed = isConfirmed
//    }
    
    init(_ views: [Page]) {
        self.viewControllers = views.map{ UIHostingController(rootView: $0) }
    }
    
    var body: some View {
        VStack{
            ZStack {
                PageViewController(controllers: viewControllers, currentIndex: self.$currentIndex)
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        ForEach(0..<viewControllers.count, id: \.self) {
                            Circle().frame(width: 10, height: 10)
                                .foregroundColor($0 == self.currentIndex ? Color(UIColor.brown) : Color(UIColor.gray))
                        }
                    }.padding()
                }
            }
            HStack(spacing: 10) {
                //이용약관, 개인정보 수집/ 띄고 이용 및 이벤트 정보 수신
                VStack {
                    HStack(spacing:2) {
                        Button(action: {
                            self.policyShow = true
                        }, label: {
                            Text("이용약관")
                        }).sheet(isPresented: self.$policyShow) {
                            DetailActionSheet(header: "서비스 이용약관", content: Model.policyShowContent)
                        }
                        Text(",")
                        Button(action: {
                            self.privateAgreementShow = true
                        }, label: {
                            Text("개인정보 수집/이용")
                        }).sheet(isPresented: self.$privateAgreementShow) {
                            DetailActionSheet(header: "개인정보 수집/이용 동의", content: Model.privateAgreementContent)
                        }
                        Text(",")
                    }
                    Button(action: {
                        self.eventNotificationShow = true
                    }, label: {
                        Text("이벤트 정보 수신")
                    }).sheet(isPresented: self.$eventNotificationShow) {
                        DetailActionSheet(header: "이벤트 정보 수신", content: Model.eventNotificationContent)
                    }
                }
                    .font(.caption)
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "isConfirmed")
                    self.appEnvironmentObject.isConfirmed = true
                }, label: {
                    Text("동의하고 시작하기")
                        .frame(width: 150, height: 50, alignment: .center)
                        .font(.footnote)
                })
                    .foregroundColor(.white)
                    .background(Color(UIColor.brown))
                    .cornerRadius(30)
                    .padding(2)
            }
            
        }
        
    }
}



struct InitialConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        InitialConfirmView(["DetailInitialConfirmImage1Cropped","DetailInitialConfirmImage2Cropped","DetailInitialConfirmImage3Cropped"
            ].map({DetailInitialConfirmView(imageName: $0)}))
    }
}

struct PageViewController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var currentIndex: Int
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator //dataSource 설정
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.setViewControllers([self.controllers[self.currentIndex]], direction: .forward, animated: true)
            self.$currentIndex.wrappedValue = context.coordinator.currentIndex
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, currentIndex: $currentIndex)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        @Binding var currentIndex: Int
        
        init(_ pageViewController: PageViewController, currentIndex: Binding<Int>) {
            self.parent = pageViewController
            self._currentIndex = currentIndex
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            } // 내가 보고 있는 뷰컨트롤러의 인덱스
            print("viewControllerBefore")
            if index == 0 {
                return nil
            }
            
            return parent.controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            print("viewControllerAfter")
            if index + 1 == parent.controllers.count {
                return nil
            }
            
            return parent.controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if !completed {
                return
            }
            self.currentIndex = parent.controllers.firstIndex(of: pageViewController.viewControllers!.first!) ?? 0
        }
    }
}

struct DetailInitialConfirmView: View {
    let imageName: String
    
    init(imageName: String) {
        self.imageName = imageName
    }
    
    var body: some View {
        Image(imageName)
    }
}

struct DetailActionSheet: View {
    let header: String
    let content: String
    
    init(header: String, content: String) {
        self.header = header
        self.content = content
    }
    
    var body: some View {
        List {
            Text(header).font(.headline)
            if header == "서비스 이용약관" {
                Text("제1장 총칙").font(.subheadline)
            }
            ScrollView {
                Text(content).font(.body)
            }
        }
    }
}
