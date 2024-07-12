//
//  TagListTableViewCell.swift
//  Reminder
//
//  Created by 최승범 on 7/12/24.
//

import UIKit
import Combine
import SnapKit

final class TagListTableViewCell: BaseTableViewCell {
    
    private lazy var tagCollectionView = UICollectionView(frame: .zero,
                                                          collectionViewLayout: createCollectionViewLayout())
    private let tagTextField = UITextField()
    private let addTagButton = UIButton()
    
    private let viewModel = TagViewModel()
    private var cancellable = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(tagCollectionView)
        contentView.addSubview(tagTextField)
        contentView.addSubview(addTagButton)
    }
    
    override func configureUI() {
        super.configureUI()
        
        tagCollectionView.backgroundColor = .iconBaseBackgroud
        tagCollectionView.layer.cornerRadius = 8
        tagCollectionView.layer.cornerCurve = .continuous
        
        tagTextField.layer.cornerRadius = 8
        tagTextField.backgroundColor = .iconBaseBackgroud
        tagTextField.layer.cornerCurve = .continuous
        tagTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        tagTextField.leftViewMode = .always
        
        addTagButton.backgroundColor = .iconBaseBackgroud
        addTagButton.setTitle("추가", for: .normal)
        addTagButton.layer.cornerRadius = 8
        addTagButton.layer.cornerCurve = .continuous
        
        tagCollectionView.register(TagCell.self,
                                   forCellWithReuseIdentifier: TagCell.identifier)
    }
    
    override func configureLayout() {
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.height.greaterThanOrEqualTo(60)
        }
        
        tagTextField.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(tagCollectionView.snp.leading)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
        
        addTagButton.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(tagTextField.snp.trailing).offset(8)
            make.trailing.equalTo(tagCollectionView.snp.trailing)
            make.height.equalTo(44)
            make.width.equalTo(60)
        }
    }
    
    override func configureGestureAndButtonAction() {
        
        addTagButton.addTarget(self,
                               action: #selector(addTag),
                               for: .touchUpInside)
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        var layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        return layout
    }
}

extension TagListTableViewCell {
    
    private func bindingOutput() {
        
        viewModel.$tagList.sink { [weak self]  _ in
            guard let self = self else { return }
            
            tagCollectionView.reloadData()
        }.store(in: &cancellable)
    }
    
    @objc private func addTag() {
        
        viewModel.applyInput(input: .addTag(tagTextField.text))
    }
    
    func updateContent(tags: [String]) {

        viewModel.applyInput(input: .readTag(tags))
    }
}

//MARK: - CollectionViewDelegate, Datsource
extension TagListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier,
                                                            for: indexPath) as? TagCell else {
            return TagCell()
        }
        
        let title = viewModel.tagList[indexPath.row]
        cell.updateContent(title: title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        viewModel.applyInput(input: .removeTag(indexPath.row))
    }
    
}
