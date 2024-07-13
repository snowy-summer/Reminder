//
//  FolderListViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/13/24.
//

import Foundation
import Combine

final class FolderListViewModel {
    
    enum InputType {
        case noValue
        case selectNil
        case selectFolder(CustomTodoFolder)
    }
    
    private(set) var folderList = DataBaseManager.shared.read(CustomTodoFolder.self)
    
    @Published private(set) var input: InputType = .noValue
    private(set) var selectedFolder: CustomTodoFolder? = nil
    var selectFolder: ((CustomTodoFolder?) -> Void)?
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        bindingInput()
    }
    
    func applyInput(_ input: InputType) {
        self.input = input
    }
    
    private func bindingInput() {
        
        $input.sink { [weak self] newInput in
            guard let self = self else { return }
            
            switch newInput {
            case .noValue:
                return
            case .selectNil:
                selectedFolder = nil
                return
            case .selectFolder(let folder):
                selectedFolder = folder
                return
            }
        }.store(in: &cancellable)
    }
}
