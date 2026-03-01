//
//  MainScreenViewController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainScreenViewProtocol

protocol MainScreenViewProtocol: AnyObject {
    
    func reloadChats()
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

// MARK: - MainScreenViewController

final class MainScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: MainScreenPresenterProtocol?
    
    // MARK: - Visual Components
    
    private let mainScreenView = MainScreenView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupNavigationBar()
        setupTableView()
        setupActions()
        setupActivityIndicator()
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
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ])
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
        presenter?.didSelectChat(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter?.chatItems.count ?? 0
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
        
        if let item = presenter?.chatItems[indexPath.row] {
            cell.configure(with: item)
        }
        
        return cell
    }
}

// MARK: - MainScreenViewProtocol

extension MainScreenViewController: MainScreenViewProtocol {
    
    func reloadChats() {
        mainScreenView.chatsTableView.reloadData()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        present(alert, animated: true)
    }
}
