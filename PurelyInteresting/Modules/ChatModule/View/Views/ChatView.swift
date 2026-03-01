//
//  ChatView.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatView

final class ChatView: UIView {
    
    // MARK: - Visual Components
    
    let navigationBarView = ChatNavigationBarView()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .textSecondary.withAlphaComponent(0.3)
        
        return view
    }()
    
    let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .bgPrimary
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    let emptyStateView = ChatEmptyStateView()
    
    let messageInputView = MessageInputView()
    
    // MARK: - Properties
    
    private var messageInputBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Public Methods
    
    func updateInputBottomConstraint(keyboardHeight: CGFloat) {
        messageInputBottomConstraint.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
    func showEmptyState(_ show: Bool) {
        emptyStateView.isHidden = !show
        messagesTableView.isHidden = show
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupSubviews()
        configureConstraints()
    }
    
    private func setupSubviews() {
        backgroundColor = .bgPrimary
        
        addSubviews([
            navigationBarView,
            separatorView,
            messagesTableView,
            emptyStateView,
            messageInputView
        ])
    }
    
    private func configureConstraints() {
        setupNavigationBarViewConstraints()
        setupSeparatorViewConstraints()
        setupMessagesTableViewConstraints()
        setupEmptyStateViewConstraints()
        setupMessageInputViewConstraints()
    }
}

// MARK: - Constraints

private extension ChatView {
    
    func setupNavigationBarViewConstraints() {
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),
            navigationBarView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            navigationBarView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            navigationBarView.heightAnchor.constraint(
                equalToConstant: .navBarHeight
            )
        ])
    }
    
    func setupSeparatorViewConstraints() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                equalTo: navigationBarView.bottomAnchor
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
    
    func setupMessagesTableViewConstraints() {
        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(
                equalTo: separatorView.bottomAnchor
            ),
            messagesTableView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            messagesTableView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            messagesTableView.bottomAnchor.constraint(
                equalTo: messageInputView.topAnchor
            )
        ])
    }
    
    func setupEmptyStateViewConstraints() {
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            emptyStateView.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -.emptyStateVerticalOffset
            )
        ])
    }
    
    func setupMessageInputViewConstraints() {
        messageInputBottomConstraint = messageInputView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor
        )
        
        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            messageInputView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            messageInputBottomConstraint
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let navBarHeight: Self = 56
    static let separatorHeight: Self = 0.5
    static let emptyStateVerticalOffset: Self = 40
}
