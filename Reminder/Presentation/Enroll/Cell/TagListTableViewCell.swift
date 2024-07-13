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
    
    weak var viewModel: EnrollViewModel?
    
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
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(TagCell.self,
                                   forCellWithReuseIdentifier: TagCell.identifier)
        
        tagTextField.layer.cornerRadius = 8
        tagTextField.layer.cornerCurve = .continuous
        tagTextField.backgroundColor = .iconBaseBackgroud
        tagTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        tagTextField.leftViewMode = .always
        tagTextField.placeholder = "태그를 입력해주세요"
        tagTextField.delegate = self
        
        addTagButton.backgroundColor = .iconBaseBackgroud
        addTagButton.setTitle("추가", for: .normal)
        addTagButton.layer.cornerRadius = 8
        addTagButton.layer.cornerCurve = .continuous
        
    }
    
    override func configureLayout() {
        
        tagTextField.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }
        
        addTagButton.snp.makeConstraints { make in
            make.leading.equalTo(tagTextField.snp.trailing).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
            make.height.equalTo(44)
            make.width.equalTo(60)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.directionalHorizontalEdges.equalTo(contentView.snp.directionalHorizontalEdges).inset(16)
            make.bottom.equalTo(tagTextField.snp.top).inset(-20)
        }
        
    }
    
    override func configureGestureAndButtonAction() {
        
        addTagButton.addTarget(self,
                               action: #selector(addTag),
                               for: .touchUpInside)
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize( widthDimension: .estimated(100),
                                               heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(4),
                                                         top: .none,
                                                         trailing: .fixed(4),
                                                         bottom: .none)
        
        let groupSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal( layoutSize: groupSize,
                                                        subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8,
                                                        leading: 8,
                                                        bottom: 8,
                                                        trailing: 8)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension TagListTableViewCell {
    
    func bindingOutput() {
        viewModel?.$tagList.receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                tagCollectionView.reloadData()
                
            }.store(in: &cancellable)
    }
    
    @objc private func addTag() {
        
        viewModel?.applyInput(.addTag(tagTextField.text))
        tagTextField.text = .none
    }
    
}

//MARK: - CollectionViewDelegate, Datsource
extension TagListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        return viewModel?.tagList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier,
                                                            for: indexPath) as? TagCell else {
            return TagCell()
        }
        
        if let title = viewModel?.tagList[indexPath.row] {
            cell.updateContent(title: title)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        viewModel?.applyInput(.removeTag(indexPath.row))
    }
    
}

extension TagListTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTag()
        
        return true
    }
    
}
