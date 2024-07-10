//
//  AddFolderViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/10/24.
//

import Foundation
import Combine

final class AddFolderViewModel {
    
    enum InputType {
        case none
        case selectColor(index: Int)
        case selectIcon(index: Int)
        case writeFolderName(folderName: String?)
    }
    
    @Published private(set) var folderName: String? = nil
    @Published private(set) var iconColor = DesignOfFolderColor.blue.colorValue
    @Published private(set) var iconName = DesignOfFolderIcon.list.iconName
    @Published private var input: InputType = .none
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bindInput()
    }
    
    func applyUserInput(_ input: InputType) {
        self.input = input
    }
    
    private func bindInput() {
        
        $input.sink { [weak self] inputType in
            guard let self = self else { return }
            
            switch inputType {
            case .none:
                return
                
            case .selectColor(index: let index):
                guard let selectedColor = DesignOfFolderColor(rawValue: index)?.colorValue else {
                    return
                }
                iconColor = selectedColor
                
            case .selectIcon(index: let index):
                guard let selectedIcon = DesignOfFolderIcon(rawValue: index)?.iconName else {
                    return
                }
                iconName = selectedIcon
                
            case .writeFolderName(folderName: let name):
                guard let text = name else {
                    return
                }
                
                if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    folderName = text
                } else {
                    folderName = nil
                }
                
            }
            
        }.store(in: &cancellable)
        
    }
}
