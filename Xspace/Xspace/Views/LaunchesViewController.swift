//
//  LaunchesViewController.swift
//  XSpace
//
//  Created by Igor Malasevschi on 6/8/25.
//  Copyright © 2025 XSpace. All rights reserved.
//
//  ┌──────────────────────────── LaunchesViewController ───────────────────────────┐
//  │                                                                               │
//  │  ┌────────────── topBar ───────────────┐                                      │
//  │  │   [ titleLabel ]    [ filterButton ]                                       │
//  │  └──────────────────────────────────────┘                                     │
//  │                                                                               │
//  │  ┌──────────── headerContainer (UIStackView) ─────────────┐                   │
//  │  │ ┌──── companyBackgroundView ─────┐                     │                   │
//  │  │ │   [ companySectionLabel ]      │                     │                   │
//  │  │ └────────────────────────────────┘                     │                   │
//  │  │ ┌────── descriptionContainer ──────┐                   │                   │
//  │  │ │ [ companyDescriptionLabel ]      │                   │                   │
//  │  │ └──────────────────────────────────┘                   │                   │
//  │  └────────────────────────────────────────────────────────┘                   │
//  │                                                                               │
//  │  ┌──────────── bottomStack (UIStackView) ────────────────┐                    │
//  │  │ ┌──── launchesBackgroundView ─────┐                   │                    │
//  │  │ │  [ launchesSectionLabel ]       │                   │                    │
//  │  │ └─────────────────────────────────┘                   │                    │
//  │  │ ┌──────────── tableView ─────────────┐                │                    │
//  │  │ │   [ launches list (cells) ]        │                │                    │
//  │  │ └────────────────────────────────────┘                │                    │
//  │  └───────────────────────────────────────────────────────┘                    │
//  └─────────────────────────────────────────────────────────────────────────────-─┘
//
//  - Uses CompanyViewModel for company info (formatted)
//  - Uses LaunchesViewModel for paginated launch data
//

import UIKit

final class LaunchesViewController: UIViewController {
    
    // MARK: - Properties
    private(set) var launchesViewModel: LaunchesViewModelProtocol
    private let companyViewModel: CompanyViewModelProtocol
    
    // MARK: - UI Elements
    private let topBar = UIView()
    private let titleLabel = UILabel()
    private let filterButton = UIButton(type: .system)
    
    private let stateView = StateView()
    
    private let companySectionLabel = UILabel()
    private let companyDescriptionLabel = UILabel()
    private var headerContainer = UIStackView()
    
    private let launchesSectionLabel = UILabel()
    private let tableView = UITableView()
    private let footerSpinner = UIActivityIndicatorView(style: .medium)
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, LaunchCellViewModel> = {
        return UITableViewDiffableDataSource<Section, LaunchCellViewModel>(tableView: tableView) { tableView, indexPath, launch in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LaunchTableViewCell.reuseID, for: indexPath) as? LaunchTableViewCell else {
                return UITableViewCell()
            }
            
            let cellViewModel = self.launchesViewModel.cellViewModel(atIndex: indexPath.row)
            cell.configure(with: cellViewModel)
            
            if cellViewModel.missionPatchImage == nil {
                cellViewModel.prepareImage() { image in
                    guard let image = image else { return }
                    DispatchQueue.main.async { [weak cell] in
                        cell?.updateMissionImage(image)
                    }
                }
            } else {
                cell.updateMissionImage(cellViewModel.missionPatchImage)
            }
            
            return cell
        }
    }()
    
    // MARK: - Initializer
    init(viewModel: LaunchesViewModelProtocol, companyViewModel: CompanyViewModelProtocol) {
        self.launchesViewModel = viewModel
        self.companyViewModel = companyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        
        setupBindings()
        
        fetchData()
        
    }
    
    private func setupStateView() {
        view.addSubview(stateView)
        stateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @MainActor
    private func fetchData() {
        let companyVM = companyViewModel
        let launchesVM = launchesViewModel
        
        Task { @MainActor in
            async let company: () = companyVM.fetchCompanyInfo()
            async let launches: () = launchesVM.loadNextPage()
            _ = await (company, launches)
        }
    }
    
    // Call site
    
    // MARK: - Layout Setup
    private func setupLayout() {
        setupTopBar()
        setupCompanyHeader()
        setupTableView()
        setupBottomSection()
        setupStateView()
    }
    
    private func setupTopBar() {
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = companyViewModel.companyName
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.tintColor = .label
        
        filterButton.addAction(UIAction { [weak self] _ in
            self?.presentFilters()
        }, for: .touchUpInside)
        
        
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.addSubview(titleLabel)
        topBar.addSubview(filterButton)
        view.addSubview(topBar)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            topBar.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
            
            filterButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor),
            filterButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor),
        ])
    }
    
    private func setupCompanyHeader() {
        companySectionLabel.text = companyViewModel.topHeaderSection
        companySectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        companySectionLabel.backgroundColor = UIColor.systemGray6
        companySectionLabel.textAlignment = .left
        companySectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let companyBackgroundView = UIView()
        companyBackgroundView.backgroundColor = UIColor.systemGray6
        companyBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        companyBackgroundView.addSubview(companySectionLabel)
        
        NSLayoutConstraint.activate([
            companySectionLabel.topAnchor.constraint(equalTo: companyBackgroundView.topAnchor),
            companySectionLabel.leadingAnchor.constraint(equalTo: companyBackgroundView.leadingAnchor, constant: 8),
            companySectionLabel.trailingAnchor.constraint(equalTo: companyBackgroundView.trailingAnchor, constant: -8),
            companySectionLabel.bottomAnchor.constraint(equalTo: companyBackgroundView.bottomAnchor),
            companyBackgroundView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        companyDescriptionLabel.numberOfLines = 0
        companyDescriptionLabel.font = UIFont.systemFont(ofSize: 15)
        companyDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionContainer = UIView()
        descriptionContainer.translatesAutoresizingMaskIntoConstraints = false
        descriptionContainer.addSubview(companyDescriptionLabel)
        
        NSLayoutConstraint.activate([
            companyDescriptionLabel.topAnchor.constraint(equalTo: descriptionContainer.topAnchor),
            companyDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor, constant: 8),
            companyDescriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor, constant: -8),
            companyDescriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor,constant: -8)
        ])
        
        headerContainer = UIStackView(arrangedSubviews: [companyBackgroundView, descriptionContainer])
        headerContainer.axis = .vertical
        headerContainer.spacing = 8
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.backgroundColor = .white
        headerContainer.layer.cornerRadius = 8
        headerContainer.layer.borderWidth = 1
        headerContainer.layer.borderColor = UIColor.separator.cgColor
        headerContainer.layer.masksToBounds = true
        
        view.addSubview(headerContainer)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 8),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            headerContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: LaunchTableViewCell.reuseID)
        tableView.separatorInset = .zero
        tableView.setContentHuggingPriority(.defaultLow, for: .vertical)
        tableView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private func setupBottomSection() {
        launchesSectionLabel.text = launchesViewModel.launchesSectionTitle
        launchesSectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        launchesSectionLabel.textAlignment = .left
        launchesSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let launchesBackgroundView = UIView()
        launchesBackgroundView.backgroundColor = UIColor.systemGray6
        launchesBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        launchesBackgroundView.addSubview(launchesSectionLabel)
        
        NSLayoutConstraint.activate([
            launchesSectionLabel.topAnchor.constraint(equalTo: launchesBackgroundView.topAnchor),
            launchesSectionLabel.leadingAnchor.constraint(equalTo: launchesBackgroundView.leadingAnchor, constant: 8),
            launchesSectionLabel.trailingAnchor.constraint(equalTo: launchesBackgroundView.trailingAnchor),
            launchesSectionLabel.bottomAnchor.constraint(equalTo: launchesBackgroundView.bottomAnchor),
            launchesBackgroundView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let bottomStack = UIStackView(arrangedSubviews: [launchesBackgroundView, tableView])
        bottomStack.axis = .vertical
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.backgroundColor = .secondarySystemBackground
        bottomStack.layer.cornerRadius = 8
        bottomStack.layer.borderWidth = 1
        bottomStack.layer.borderColor = UIColor.separator.cgColor
        bottomStack.layer.masksToBounds = true
        bottomStack.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(bottomStack)
        
        NSLayoutConstraint.activate([
            bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            bottomStack.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 8),
            bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
}

// MARK: - ViewModel Bindings & State Handling
extension LaunchesViewController {
    private func setupBindings() {
        companyViewModel.onViewStateChange = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading: break
            case .loaded(let formattedText):
                self.handleCompanyData(formattedText)
            case .error(let message):
                self.handleCompanyData(message)
            }
        }
        
        launchesViewModel.onViewStateChange = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.handleLaunchesLoading()
            case .loaded(let isEmpty):
                self.handleLoadedState(isEmpty: isEmpty)
            case .error(let message):
                self.handleLaunchesError(message: message)
            }
        }
    }
    
    private func handleCompanyData(_ text: String) {
        companyDescriptionLabel.text = text
    }
    
    private func handleLaunchesLoading() {
        showFooterLoadingIndicator()
        stateView.dismiss()
    }
    
    private func handleLoadedState(isEmpty: Bool) {
        hideFooterLoadingIndicator()
        
        if isEmpty {
            stateView.show(message: launchesViewModel.emptyLaunchesText) {
                self.stateView.dismiss()
            }
        }
        
        reloadData()
    }
    
    private func handleLaunchesError(message: String) {
        hideFooterLoadingIndicator()
        
        stateView.show(message: message, buttonTitle: launchesViewModel.retryButtonText) {
            self.stateView.dismiss()
            Task {
                await self.launchesViewModel.loadNextPage()
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, LaunchCellViewModel>()
        snapshot.appendSections([.main])
        
        // You need access to all current cell view models
        for index in 0..<self.launchesViewModel.enrichedLaunchesCount {
            let vm = self.launchesViewModel.cellViewModel(atIndex: index)
            snapshot.appendItems([vm])
        }
        
        self.dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension LaunchesViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        guard offsetY > contentHeight - frameHeight - 100 else { return }
        guard !launchesViewModel.isLoading else { return }
        
        Task {
            await launchesViewModel.loadNextPage()
            hideFooterLoadingIndicator()
        }
    }
}

// MARK: - Section Enum
extension LaunchesViewController {
    private enum Section {
        case main
    }
}

// MARK: - UI Helpers
extension LaunchesViewController {
    private func showFooterLoadingIndicator() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = spinner
    }
    
    private func hideFooterLoadingIndicator() {
        tableView.tableFooterView = nil
    }
    
    private func presentFilters() {
        let currentFilters = launchesViewModel.currentFilters
        
        let filtersViewModel = FiltersViewModel(filterModel: currentFilters)
        let filtersVC = FiltersViewController(viewModel: filtersViewModel)
        
        filtersVC.onApplyFilters = { [weak self] newFilters in
            Task {
                await self?.launchesViewModel.applyFilters(newFilters)
            }
        }
        
        filtersVC.onResetFilters = { [weak self]  in
            Task {
                await self?.launchesViewModel.applyFilters(.empty)
            }
        }
        
        present(filtersVC, animated: true)
    }
}
