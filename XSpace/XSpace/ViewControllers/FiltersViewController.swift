//
//  FiltersViewController.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/10/25.
//  Copyright © 2025 XSpace. All rights reserved.
//
//
// +------------------------------------------------------+
// |                 FiltersViewController                |
// |------------------------------------------------------|
// | [Launch Years]                                       | <- UILabel
// |                                                      |
// | [2006] [2007] [2008] [2009] [2010] ...               | <- UICollectionView (multi-select)
// |                                                      |
// | [Launch Success]                                     | <- UILabel
// | [ All | Success only ]                               | <- UISegmentedControl
// |                                                      |
// | [Sort Order]                                         | <- UILabel
// | [ ASC | DESC ]                                       | <- UISegmentedControl
// |                                                      |
// |                [Apply Filters]                       | <- UIButton (bordered blue)
// |                [Reset Filters]                       | <- UIButton (plain red)
// +------------------------------------------------------+

import UIKit

final class FiltersViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: FiltersViewModelProtocol
    var onApplyFilters: ((LaunchFiltersModel) -> Void)?
    var onResetFilters: (() -> Void)?
    
    private let successControl: UISegmentedControl
    private let sortOrderControl: UISegmentedControl

    private let launchYearsLabel = UILabel()
    private let launchSuccessLabel = UILabel()
    private let sortOrderLabel = UILabel()
    private let applyButton = UIButton(type: .system)
    private let contentStack = UIStackView()

    // MARK: - Collection View
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.allowsMultipleSelection = true
        cv.register(YearsFilterCell.self, forCellWithReuseIdentifier: YearsFilterCell.reuseID)
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Init
    init(viewModel: FiltersViewModelProtocol) {
        self.viewModel = viewModel
        self.successControl = UISegmentedControl(items: viewModel.successOptions)
        self.sortOrderControl = UISegmentedControl(items: viewModel.sortOrderOptions)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        syncUIWithViewModel()
    }
        
    private func setupUI() {
        setupStackView()
        setupLaunchYearsSection()
        setupSuccessFilterSection()
        setupSortOrderSection()
        setupApplyButton()
        setupResetButton()
    }
    
    private func syncUIWithViewModel() {
        // Deselect all collection view items
        for index in 0..<viewModel.availableYears.count {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.deselectItem(at: indexPath, animated: false)
        }

        // Select pre-existing years 
        for (index, year) in viewModel.availableYears.enumerated() {
            if viewModel.selectedYears.contains(year) {
                let indexPath = IndexPath(item: index, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }

        successControl.selectedSegmentIndex = viewModel.successOnly ? 1 : 0
        sortOrderControl.selectedSegmentIndex = viewModel.sortOrderAscending ? 0 : 1
    }

    // MARK: - UI Setup
    private func setupStackView() {
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupLaunchYearsSection() {
        launchYearsLabel.text = viewModel.launchYearsLabelText
        launchYearsLabel.font = .systemFont(ofSize: 16, weight: .medium)

        contentStack.addArrangedSubview(launchYearsLabel)
        contentStack.addArrangedSubview(collectionView)
        collectionView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }

    private func setupSuccessFilterSection() {
        launchSuccessLabel.text = viewModel.launchSuccessLabelText
        launchSuccessLabel.font = .systemFont(ofSize: 16, weight: .medium)
        successControl.selectedSegmentIndex = 0

        contentStack.addArrangedSubview(launchSuccessLabel)
        contentStack.addArrangedSubview(successControl)
    }

    private func setupSortOrderSection() {
        sortOrderLabel.text = viewModel.sortOrderLabelText
        sortOrderLabel.font = .systemFont(ofSize: 16, weight: .medium)
        sortOrderControl.selectedSegmentIndex = 0

        contentStack.addArrangedSubview(sortOrderLabel)
        contentStack.addArrangedSubview(sortOrderControl)
    }

    private func setupApplyButton() {
        var config = UIButton.Configuration.bordered()
        config.title = viewModel.applyButtonTitle
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        let action = UIAction(title: viewModel.applyButtonTitle) { [weak self] _ in
            self?.handleApply()
        }

        let applyButton = UIButton(configuration: config, primaryAction: action)

        contentStack.addArrangedSubview(applyButton)
    }
    
    private func setupResetButton() {
        let resetAction = UIAction(title: viewModel.resetButtonTitle) { [weak self] _ in
            self?.handleReset()
        }

        var config = UIButton.Configuration.plain()
        config.title = viewModel.resetButtonTitle
        config.baseForegroundColor = .systemRed

        let resetButton = UIButton(configuration: config, primaryAction: resetAction)
        contentStack.addArrangedSubview(resetButton)
    }

    private func handleReset() {
        viewModel.resetFilters()
        syncUIWithViewModel()
        // notify parent
        onResetFilters?()
    }

    // MARK: - Actions
    private func handleApply() {
        viewModel.successOnly = (successControl.selectedSegmentIndex == 1)
        viewModel.sortOrderAscending = (sortOrderControl.selectedSegmentIndex == 0)

        let filters = viewModel.filterModel
        onApplyFilters?(filters)
        dismiss(animated: true)
    }
}

// MARK: - Collection View
extension FiltersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.availableYears.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let year = viewModel.availableYears[indexPath.item]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YearsFilterCell.reuseID, for: indexPath) as? YearsFilterCell else {
            assertionFailure("Failed to dequeue YearsFilterCell")
            return UICollectionViewCell()
        }

        cell.label.text = "\(year)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let year = viewModel.availableYears[indexPath.item]
        viewModel.selectedYears.insert(year)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let year = viewModel.availableYears[indexPath.item]
        viewModel.selectedYears.remove(year)
    }
}
