//
//  IconSectionCellViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/11/24.
//

import Foundation
import Combine

final class IconSectionCellViewModel {
    
    enum InputType {
        case none
        case selectIcon(index: Int)
    }
    
    @Published private(set) var index = DesignOfFolderIcon.list.rawValue
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
                
            case .selectIcon(index: let index):
                guard let _ = DesignOfFolderIcon(rawValue: index) else {
                    return
                }
                
                self.index = index
                
            }
            
        }.store(in: &cancellable)
        
    }
}

