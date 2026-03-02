//
//  ChatViewController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatViewProtocol

protocol ChatViewProtocol: AnyObject {
    
    func reloadMessages()
    func scrollToBottom()
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

// MARK: - ChatViewController

final class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ChatPresenterProtocol?
    
    private let chatUser: ChatUser
    
    // MARK: - Visual Components
    
    private let chatView = ChatView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    // MARK: - Initializers
    
    init(chatUser: ChatUser) {
        self.chatUser = chatUser
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
        
        // Скрываем floating tab bar
        if let tabBar = tabBarController as? MainTabBarController {
            tabBar.setFloatingBarHidden(true, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
        presenter?.viewWillDisappear()
        
        // Показываем floating tab bar
        if let tabBar = tabBarController as? MainTabBarController {
            tabBar.setFloatingBarHidden(false, animated: true)
        }
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupNavigationBar()
        setupContent()
        setupTableView()
        setupActions()
        setupDismissKeyboardGesture()
        setupActivityIndicator()
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        chatView.navigationBarView.configure(with: chatUser)
    }
    
    private func setupContent() {
        chatView.emptyStateView.configure(with: chatUser)
        chatView.showEmptyState(true)
    }
    
    private func setupTableView() {
        chatView.messagesTableView.delegate = self
        chatView.messagesTableView.dataSource = self
        chatView.messagesTableView.register(
            MessageCell.self,
            forCellReuseIdentifier: MessageCell.identifier
        )
        chatView.messagesTableView.separatorStyle = .none
    }
    
    private func setupActions() {
        chatView.navigationBarView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        chatView.emptyStateView.viewProfileButton.addTarget(
            self,
            action: #selector(viewProfileTapped),
            for: .touchUpInside
        )
        
        chatView.messageInputView.delegate = self
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        chatView.messagesTableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupActivityIndicator() {
        chatView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: chatView.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: chatView.centerYAnchor
            )
        ])
    }
    
    // MARK: - Keyboard
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @objc Methods
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func viewProfileTapped() {
        presenter?.viewProfileTapped()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? CGRect else { return }
        
        let bottomInset = view.safeAreaInsets.bottom
        chatView.updateInputBottomConstraint(
            keyboardHeight: keyboardFrame.height - bottomInset
        )
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        chatView.updateInputBottomConstraint(keyboardHeight: 0)
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter?.messages.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MessageCell.identifier,
            for: indexPath
        ) as? MessageCell,
              let message = presenter?.messages[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.configure(
            with: message,
            avatarUrl: chatUser.avatarUrl
        )
        
        return cell
    }
}

// MARK: - MessageInputViewDelegate

extension ChatViewController: MessageInputViewDelegate {
    
    func messageInputView(
        _ view: MessageInputView,
        didSendMessage text: String
    ) {
        presenter?.sendMessage(text)
    }
}

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {
    
    func reloadMessages() {
        let hasMessages = presenter?.messages.isEmpty == false
        chatView.showEmptyState(!hasMessages)
        chatView.messagesTableView.reloadData()
    }
    
    func scrollToBottom() {
        guard let count = presenter?.messages.count,
              count > 0
        else { return }
        
        let lastIndexPath = IndexPath(row: count - 1, section: 0)
        chatView.messagesTableView.scrollToRow(
            at: lastIndexPath,
            at: .bottom,
            animated: true
        )
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
