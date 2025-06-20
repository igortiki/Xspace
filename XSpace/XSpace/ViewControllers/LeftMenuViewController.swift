//
//  RightMenuViewController.swift
//  XSpace
//
//  Created by Igor Malasevschi on 20.06.2025.
//  Copyright © 2025 XSpace. All rights reserved.

import UIKit

final class LeftMenuViewController: UIViewController {

    private let stackView = UIStackView()
    private let toggleAppearanceButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupShadow()
        setupBlurBackground()
        setupStackView()
        setupToggleAppearanceButton()
    }

    // MARK: - UI Setup

    private func setupAppearance() {
        view.backgroundColor = .clear // use blur background instead
    }

    private func setupShadow() {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 2, height: 0)
        view.layer.shadowRadius = 8
    }

    private func setupBlurBackground() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Example menu item
        let label = UILabel()
        label.text = "🚀 Launches"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        stackView.addArrangedSubview(label)
    }

    private func setupToggleAppearanceButton() {
        toggleAppearanceButton.setTitle(currentAppearanceLabel(), for: .normal)
        toggleAppearanceButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        toggleAppearanceButton.translatesAutoresizingMaskIntoConstraints = false

        toggleAppearanceButton.addAction(UIAction { [weak self] _ in
            self?.toggleAppearance()
        }, for: .touchUpInside)

        view.addSubview(toggleAppearanceButton)

        NSLayoutConstraint.activate([
            toggleAppearanceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            toggleAppearanceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toggleAppearanceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toggleAppearanceButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Appearance Toggling

    private func toggleAppearance() {
        guard let window = view.window else { return }

        let current = window.overrideUserInterfaceStyle
        window.overrideUserInterfaceStyle = (current == .dark) ? .light : .dark

        toggleAppearanceButton.setTitle(currentAppearanceLabel(), for: .normal)
    }

    private func currentAppearanceLabel() -> String {
        switch view.window?.overrideUserInterfaceStyle {
        case .dark:
            return "☀️ Light Mode"
        default:
            return "🌙 Dark Mode"
        }
    }
}

