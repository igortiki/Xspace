//
//  StateView.swift
//  XSpace
//
//  Created by Igor Malasevschi on 13.06.2025.
//  Copyright © 2025 XSpace. All rights reserved.
//

import UIKit

final class StateView: UIView {
    
    // MARK: - Subviews
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Callbacks
    private var action: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func show(message: String, buttonTitle: String? = nil, onAction: (() -> Void)? = nil) {
        messageLabel.text = message
        
        if let title = buttonTitle {
            actionButton.setTitle(title, for: .normal)
            actionButton.isHidden = false
            self.action = onAction
        } else {
            actionButton.isHidden = true
            self.action = nil
        }
        
        isHidden = false
    }
    
    func dismiss() {
        isHidden = true
        messageLabel.text = nil
        action = nil
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemBackground
        
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel
        
        actionButton.addAction(UIAction { [weak self] _ in
            self?.handleTap()
        }, for: .touchUpInside)
        
        actionButton.setTitleColor(tintColor, for: .normal)
        
        let stack = UIStackView(arrangedSubviews: [messageLabel, actionButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
        
        isHidden = true
    }
    
    private func handleTap() {
        action?()
    }
}
