//
//  UITextView+Extension.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit

extension UITextView {
    
    func fontType(what type: DesignOfFont) {
        self.font = type.font
        self.textColor = type.color
    }
}
