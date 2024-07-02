//
//  Identifier+Extension.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import Foundation

extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}
