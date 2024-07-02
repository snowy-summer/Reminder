//
//  TitleAndMemoTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/2/24.
//

import UIKit
import SnapKit

final class TitleAndMemoTableViewCell: BaseTableViewCell {
    
    private let contentTextView = UITextView()
    private var placeHolder: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(contentTextView)
    }
    
    override func configureUI() {
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
    
    func updateContent(type: EnrollSections.Main) {
        
        contentTextView.text = type.text
        placeHolder = type.text

    }
}

extension TitleAndMemoTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            contentTextView.text = .none
        }
        
        contentTextView.textColor = .baseFont
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTextView.text = placeHolder
            contentTextView.textColor = .lightGray
        }
    }
}
