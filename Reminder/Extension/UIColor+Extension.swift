//
//  UIColor+Extension.swift
//  Reminder
//
//  Created by 최승범 on 7/11/24.
//

import UIKit

extension UIColor {
    var component: (CGFloat,CGFloat,CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        return (red,green,blue)
    }
    
}
