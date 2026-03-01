//
//  ChatViewController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatViewProtocol

protocol ChatViewProtocol: AnyObject {}

// MARK: - ChatViewController

final class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ChatPresenterProtocol?
    
    private let chatUser: ChatUser
    
    // MARK: - Visual Components
    
    private let chatView = ChatView()
    
    // MARK: - Initializers
    
    init(chatUser: ChatUser) {
        self.chatUser = chatUser
        super.init(nibName: nil, bundle: nil)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardNotifications()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupNavigationBar()
        setupContent()
        setupTableView()
        setupActions()
        setupDismissKeyboardGesture()
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
        chatView.addGestureRecognizer(tapGesture)
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
        // TODO: - Передать в presenter
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
        
        return 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        return UITableViewCell()
    }
}

// MARK: - MessageInputViewDelegate

extension ChatViewController: MessageInputViewDelegate {
    
    func messageInputView(
        _ view: MessageInputView,
        didSendMessage text: String
    ) {
        // TODO: - Передать в presenter
    }
}

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {}
