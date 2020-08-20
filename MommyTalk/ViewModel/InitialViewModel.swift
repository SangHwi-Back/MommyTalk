//
//  InitialViewModel.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/18.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import SwiftUI

class InitialViewModel: ObservableObject {
    
}

struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get {
            return self[ViewControllerKey.self].value
        }
        set {
            self[ViewControllerKey.self].value = newValue
        }
    }
}
