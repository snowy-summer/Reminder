//
//  TagViewModel.swift
//  Reminder
//
//  Created by 최승범 on 7/12/24.
//

import Foundation
import Combine

final class TagViewModel {
    
    enum InputType {
        case noValue
        case readTag([String])
        case addTag(String?)
        case removeTag(Int)
    }
    
    @Published private var input: InputType = .noValue
    @Published private(set) var tagList = [String]()
    private var cancellable = Set<AnyCancellable>()
    
    func applyInput(input: InputType) {
        self.input = input
    }
}

extension TagViewModel {
    
    private func bindingInput() {
        
        $input.sink { [weak self] newInputType in
            guard let self = self else { return }
            
            switch newInputType {
            case .noValue:
                return
                
            case .readTag(let tags):
                readTag(tags: tags)
                
            case .addTag:
                return
                
            case .removeTag:
                return
            }
            
        }.store(in: &cancellable)
    }
    
    private func readTag(tags: [String]) {
        tagList = tags
    }
    
    private func addTag(text: String?) {
        
        guard let text = text else { return }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            tagList.contains(text) {
            return
        }
        
        tagList.append(text)
    }
    
    private func removeTag(index: Int) {
        
        tagList.remove(at: index)
    }
}
