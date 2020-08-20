//
//  AppEnvironmentObject.swift
//  MommyTalk
//
//  Created by 백상휘 on 2020/08/20.
//  Copyright © 2020 Sanghwi Back. All rights reserved.
//

import Foundation
import Combine

class AppEnvironmentObject: ObservableObject {
    @Published var isConfirmed = false
    
    private var autosave: AnyCancellable?
    
    init(isConfirmed: Bool = false) {
        let isConfirmedKey = "isConfirmed"
        self.isConfirmed = UserDefaults.standard.value(forKey: isConfirmedKey) as? Bool ?? false
        autosave = $isConfirmed.sink(receiveValue: { isConfirmed in
            UserDefaults.standard.set(isConfirmed, forKey: isConfirmedKey)
        })
    }
}
