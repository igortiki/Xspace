//
//  LaunchTableViewCell.swift
//  Devskiller
//
//  Created by Igor Malasevschi on 6/8/25.
//  Copyright © 2025 Xspace. All rights reserved.
//
// ┌──────────────────────────────────────────────────────────────────────────────────┐
// │                             LaunchTableViewCell                                  │
// │                                                                                  │
// │ ┌────────────┐  ┌────────────────────────────────────────────┐  ┌──────────┐     │
// │ │            │  │ Mission: {name}                            │  │          │     │
// │ │  mission   │  │ Date/Time: {date} at {time}                │  │ success  │     │
// │ │   image    │  │ Rocket: {name/type}                        │  │  icon    │     │
// │ │  (40x40)   │  │ Days: +/- {today - launch date}            │  │ (20x20)  │     │
// │ │            │  │ {since/from} now:                          │  │          │     │
// │ └────────────┘  └────────────────────────────────────────────┘  └──────────┘     │
// └──────────────────────────────────────────────────────────────────────────────────┘


import UIKit

final class LaunchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var viewModel: LaunchCellViewModelProtocol?
    static let reuseID = "LaunchCell"
    
    // MARK: - UI Elements
    private let missionImageView = UIImageView()
    private let successIcon = UIImageView()
    
    private let missionNameLabel = UILabel()
    private let dateTimeLabel = UILabel()
    private let rocketLabel = UILabel()
    private let daysLabel = UILabel()
    private let fromNowLabel = UILabel()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelImageLoad()
        viewModel = nil
        
        updateMissionImage(nil)
        successIcon.image = nil
        
        missionNameLabel.text = nil
        dateTimeLabel.text = nil
        rocketLabel.text = nil
        daysLabel.text = nil
        fromNowLabel.text = nil
    }
    
    // MARK: - Configuration
    func configure(with viewModel: LaunchCellViewModelProtocol) {
        self.viewModel = viewModel
        missionNameLabel.text = viewModel.missionName
        dateTimeLabel.text = viewModel.dateTimeString
        rocketLabel.text = viewModel.rocketDescription
        daysLabel.text = viewModel.daysSinceText
        fromNowLabel.text = viewModel.fromNowText
        successIcon.image = viewModel.successIcon
        successIcon.tintColor = viewModel.successIconTintColor
        
        updateMissionImage(viewModel.missionPatchImage)
    }
    
    func updateMissionImage(_ image: UIImage?) {
        missionImageView.image = image ?? UIImage(systemName: "photo")
    }
    
    // MARK: - Layout
    private func setupLayout() {
        missionImageView.translatesAutoresizingMaskIntoConstraints = false
        missionImageView.contentMode = .scaleAspectFit
        missionImageView.layer.cornerRadius = 4
        missionImageView.clipsToBounds = true
        missionImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        missionImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        successIcon.translatesAutoresizingMaskIntoConstraints = false
        successIcon.contentMode = .scaleAspectFit
        successIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        successIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let labels = [missionNameLabel, dateTimeLabel, rocketLabel, daysLabel, fromNowLabel]
        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.numberOfLines = 1
        }
        
        let vStack = UIStackView(arrangedSubviews: labels)
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack = UIStackView(arrangedSubviews: [missionImageView, vStack, successIcon])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
