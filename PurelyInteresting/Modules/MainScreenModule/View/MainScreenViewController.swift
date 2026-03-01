//
//  MainScreenViewController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainScreenViewProtocol

protocol MainScreenViewProtocol: AnyObject {}

// MARK: - MainScreenViewController

final class MainScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: MainScreenPresenterProtocol?
    
    private let chatItems = MockData.chatItems
    
    // MARK: - Visual Components
    
    private let mainScreenView = MainScreenView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupNavigationBar()
        setupTableView()
        setupActions()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        mainScreenView.chatsTableView.delegate = self
        mainScreenView.chatsTableView.dataSource = self
        mainScreenView.chatsTableView.register(
            ChatCell.self,
            forCellReuseIdentifier: ChatCell.identifier
        )
    }
    
    private func setupActions() {
        mainScreenView.usernameButton.addTarget(
            self,
            action: #selector(usernameButtonTapped),
            for: .touchUpInside
        )
        
        mainScreenView.composeButton.addTarget(
            self,
            action: #selector(composeButtonTapped),
            for: .touchUpInside
        )
        
        mainScreenView.filterButton.addTarget(
            self,
            action: #selector(filterButtonTapped),
            for: .touchUpInside
        )
        
        mainScreenView.segmentControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func usernameButtonTapped() {
        // TODO: - Передать в presenter
    }
    
    @objc private func composeButtonTapped() {
        // TODO: - Передать в presenter
    }
    
    @objc private func filterButtonTapped() {
        // TODO: - Передать в presenter
    }
    
    @objc private func segmentChanged() {
        // TODO: - Передать в presenter
    }
}

// MARK: - UITableViewDelegate

extension MainScreenViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // TODO: - Передать в presenter
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        return chatItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatCell.identifier,
            for: indexPath
        ) as? ChatCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: chatItems[indexPath.row])
        
        return cell
    }
}

// MARK: - MainScreenViewProtocol

extension MainScreenViewController: MainScreenViewProtocol {}
