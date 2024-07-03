//
//  UIButton+Extension.swift
//  Reminder
//
//  Created by 최승범 on 7/3/24.
//

import UIKit

extension UIButton {
    
    func toolBarButtonItem(type: ToolBarButtonType) {
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
        let image = UIImage(systemName: type.imageName, withConfiguration: symbolConfiguration)
        
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.title = type.title
        buttonConfig.image = image
        buttonConfig.imagePadding = 10
        buttonConfig.imagePlacement = .leading
        
        self.configuration = buttonConfig
    }
}
