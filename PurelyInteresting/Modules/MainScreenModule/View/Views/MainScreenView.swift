//
//  MainScreenView.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainScreenView

final class MainScreenView: UIView {
    
    // MARK: - Visual Components
    
    let usernameButton: UIButton = {
        let button = UIButton(type: .system)
        
        var config = UIButton.Configuration.plain()
        config.title = .username
        config.image = UIImage(systemName: .chevronIcon)
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.baseForegroundColor = .white
        
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 12, weight: .semibold
        )
        config.preferredSymbolConfigurationForImage = imageConfig
        
        button.configuration = config
        button.titleLabel?.font = .roboto(.medium, size: 20)
        
        return button
    }()
    
    let composeButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 18, weight: .medium
        )
        button.setImage(
            UIImage(
                systemName: .composeIcon,
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = .searchPlaceholder
        searchBar.searchBarStyle = .minimal
        searchBar.keyboardType = .default
        searchBar.barTintColor = .bgPrimary
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = .textSecondary
        
        return searchBar
    }()
    
    let filterButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 18, weight: .medium
        )
        button.setImage(
            UIImage(
                systemName: .filterIcon,
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        
        return button
    }()
    
    let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            String.messagesTab,
            String.archiveTab
        ])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .clear
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textSecondary,
            .font: UIFont.roboto(.medium, size: 16)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.roboto(.medium, size: 16)
        ]
        
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        control.setBackgroundImage(
            UIImage(), for: .normal, barMetrics: .default
        )
        control.setBackgroundImage(
            UIImage(), for: .selected, barMetrics: .default
        )
        control.setDividerImage(
            UIImage(),
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default
        )
        
        return control
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .textSecondary.withAlphaComponent(0.3)
        
        return view
    }()
    
    let chatsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgPrimary
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupSubviews()
        configureConstraints()
    }
    
    private func setupSubviews() {
        backgroundColor = .bgPrimary
        
        addSubviews([
            usernameButton,
            composeButton,
            searchBar,
            filterButton,
            segmentControl,
            separatorView,
            chatsTableView
        ])
    }
    
    private func configureConstraints() {
        setupUsernameButtonConstraints()
        setupComposeButtonConstraints()
        setupSearchBarConstraints()
        setupFilterButtonConstraints()
        setupSegmentControlConstraints()
        setupSeparatorViewConstraints()
        setupChatsTableViewConstraints()
    }
}

// MARK: - Constraints

private extension MainScreenView {
    
    func setupUsernameButtonConstraints() {
        NSLayoutConstraint.activate([
            usernameButton.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: .topPadding
            ),
            usernameButton.centerXAnchor.constraint(
                equalTo: centerXAnchor
            )
        ])
    }
    
    func setupComposeButtonConstraints() {
        NSLayoutConstraint.activate([
            composeButton.centerYAnchor.constraint(
                equalTo: usernameButton.centerYAnchor
            ),
            composeButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -.horizontalPadding
            ),
            composeButton.widthAnchor.constraint(
                equalToConstant: .iconSize
            ),
            composeButton.heightAnchor.constraint(
                equalToConstant: .iconSize
            )
        ])
    }
    
    func setupSearchBarConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: usernameButton.bottomAnchor,
                constant: .searchBarTopOffset
            ),
            searchBar.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: .searchBarHorizontalPadding
            ),
            searchBar.trailingAnchor.constraint(
                equalTo: filterButton.leadingAnchor,
                constant: -.searchBarSpacing
            ),
            searchBar.heightAnchor.constraint(
                equalToConstant: .searchBarHeight
            )
        ])
    }
    
    func setupFilterButtonConstraints() {
        NSLayoutConstraint.activate([
            filterButton.centerYAnchor.constraint(
                equalTo: searchBar.centerYAnchor
            ),
            filterButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -.horizontalPadding
            ),
            filterButton.widthAnchor.constraint(
                equalToConstant: .iconSize
            ),
            filterButton.heightAnchor.constraint(
                equalToConstant: .iconSize
            )
        ])
    }
    
    func setupSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: .segmentTopOffset
            ),
            segmentControl.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: .horizontalPadding
            ),
            segmentControl.heightAnchor.constraint(
                equalToConstant: .segmentHeight
            )
        ])
    }
    
    func setupSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                equalTo: segmentControl.bottomAnchor,
                constant: .separatorTopOffset
            ),
            separatorView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            separatorView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            separatorView.heightAnchor.constraint(
                equalToConstant: .separatorHeight
            )
        ])
    }
    
    func setupChatsTableViewConstraints() {
        NSLayoutConstraint.activate([
            chatsTableView.topAnchor.constraint(
                equalTo: separatorView.bottomAnchor
            ),
            chatsTableView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            chatsTableView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            chatsTableView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let horizontalPadding: Self = 16
    static let topPadding: Self = 8
    static let searchBarTopOffset: Self = 12
    static let searchBarHorizontalPadding: Self = 8
    static let searchBarSpacing: Self = 8
    static let searchBarHeight: Self = 36
    static let segmentTopOffset: Self = 8
    static let segmentHeight: Self = 32
    static let separatorTopOffset: Self = 4
    static let separatorHeight: Self = 0.5
    static let iconSize: Self = 28
}

private extension String {
    
    static let username = "servise_car666"
    static let searchPlaceholder = "Поиск"
    static let messagesTab = "Сообщения"
    static let archiveTab = "Архив"
    static let chevronIcon = "chevron.down"
    static let composeIcon = "square.and.pencil"
    static let filterIcon = "line.3.horizontal.decrease"
}
