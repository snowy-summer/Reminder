//
//  TitleAndMemoTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

protocol TitleAndMemoTableViewCellDelegate: AnyObject {
    
    func changeSaveButtonEnabled(text: String, type: EnrollSections.Main)
}

final class TitleAndMemoTableViewCell: BaseTableViewCell {
    
    private(set) var contentTextView = UITextView()
    weak var delegate: TitleAndMemoTableViewCellDelegate?
    var type: EnrollSections.Main?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(contentTextView)
    }
    
    override func configureUI() {
        super.configureUI()
        
        contentTextView.textContainerInset = UIEdgeInsets(top: 8.0,
                                                          left: 8.0,
                                                          bottom: 8.0,
                                                          right: 8.0)
        
        contentTextView.fontType(what: .enrollPlaceHolder)
        contentTextView.backgroundColor = .clear
        
        contentTextView.delegate = self
    }
    
    override func configureLayout() {
        
        contentTextView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }
    
    func updateContent(text: String?) {
        
        guard let type = type else { return }
        if let text = text,
           !text.isEmpty {
            
            contentTextView.text = text
        } else {
            contentTextView.text = type.text
        }
    }
    
}

extension TitleAndMemoTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == type?.text {
            contentTextView.text = .none
        }
        
        contentTextView.textColor = .baseFont
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let type = type {
            delegate?.changeSaveButtonEnabled(text: text,
                                              type: type)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTextView.text = type?.text
            contentTextView.textColor = .lightGray
        }
        
        
    }
    
}
