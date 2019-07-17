//
//  Utils.swift
//  PersianBMS
//
//  Created by Arash on 7/2/19.
//  Copyright © 2019 PersianBMS. All rights reserved.
//

import Foundation

func l10n(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

func onMain(execute work: @escaping @convention(block) () -> Swift.Void) {
    DispatchQueue.main.async {
        work()
    }
}

func onMainAfter(delay: TimeInterval, execute work: @escaping @convention(block) () -> Swift.Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        work()
    }
}
