//
//  ImageListTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/14/24.
//

import UIKit
import SnapKit

final class ImageListTableViewCell: BaseTableViewCell {
    
    private let deleteImage = UIImageView()
    private let thumbnailImageView = UIImageView()
    
    private let photoManager = PhotoManager()
    weak var viewModel: EnrollViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(deleteImage)
        contentView.addSubview(thumbnailImageView)
    }
    
    override func configureUI() {
        
        contentView.backgroundColor = .cell
        deleteImage.image = UIImage(systemName: "minus.circle")
        deleteImage.tintColor = .red
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.layer.masksToBounds = true
    }
    
    override func configureLayout() {
        
        deleteImage.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(16)
            make.width.equalTo(deleteImage.snp.height)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalTo(deleteImage.snp.trailing).offset(16)
            make.verticalEdges.equalTo(contentView.snp.verticalEdges).inset(8)
            make.width.equalTo(thumbnailImageView.snp.height)
        }
        
    }
   
    func updateContent(name: String) {
        
        thumbnailImageView.image = photoManager.loadImageToDocument(filename: name)
    }
}
