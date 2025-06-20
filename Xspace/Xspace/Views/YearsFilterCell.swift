//
//  YearsFilterCell.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 XSpace. All rights reserved.
//

import UIKit

final class YearsFilterCell: UICollectionViewCell {
    static let reuseID = "YearsFilterCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.backgroundColor = .systemBackground
        
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemBlue : .systemBackground
            label.textColor = isSelected ? .white : .label
        }
    }
}
