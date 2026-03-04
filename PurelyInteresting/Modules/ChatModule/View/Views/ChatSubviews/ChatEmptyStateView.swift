//
//  ChatEmptyStateView.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatEmptyStateView

final class ChatEmptyStateView: UIView {
    
    // MARK: - Visual Components
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = .avatarSize / 2
        iv.backgroundColor = .bgActionSecondary
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.medium, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 14)
        label.textColor = .textSecondary
        label.textAlignment = .center
        
        return label
    }()
    
    let viewProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.viewProfileTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .roboto(.regular, size: 14)
        button.backgroundColor = .bgActionSecondary
        button.layer.cornerRadius = .buttonCornerRadius
        
        return button
    }()
    
    private let registrationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 16)
        label.textColor = .textSecondary
        label.textAlignment = .center
        
        return label
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
    
    // MARK: - Public Methods
    
    func configure(with user: ChatUser) {
        avatarImageView.image = user.avatarImage
        usernameLabel.text = user.username
        subscriptionLabel.text = user.subscriptionStatus
        registrationDateLabel.text = user.registrationDate
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupSubviews()
        configureConstraints()
    }
    
    private func setupSubviews() {
        addSubviews([
            avatarImageView,
            usernameLabel,
            subscriptionLabel,
            viewProfileButton,
            registrationDateLabel
        ])
    }
    
    private func configureConstraints() {
        setupAvatarImageViewConstraints()
        setupUsernameLabelConstraints()
        setupSubscriptionLabelConstraints()
        setupViewProfileButtonConstraints()
        setupRegistrationDateLabelConstraints()
    }
}

// MARK: - Constraints

private extension ChatEmptyStateView {
    
    func setupAvatarImageViewConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            avatarImageView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: .avatarSize
            ),
            avatarImageView.heightAnchor.constraint(
                equalToConstant: .avatarSize
            )
        ])
    }
    
    func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: .usernameTopOffset
            ),
            usernameLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            )
        ])
    }
    
    func setupSubscriptionLabelConstraints() {
        NSLayoutConstraint.activate([
            subscriptionLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: .subscriptionTopOffset
            ),
            subscriptionLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            )
        ])
    }
    
    func setupViewProfileButtonConstraints() {
        NSLayoutConstraint.activate([
            viewProfileButton.topAnchor.constraint(
                equalTo: subscriptionLabel.bottomAnchor,
                constant: .buttonTopOffset
            ),
            viewProfileButton.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            viewProfileButton.widthAnchor.constraint(
                equalToConstant: .buttonWidth
            ),
            viewProfileButton.heightAnchor.constraint(
                equalToConstant: .buttonHeight
            )
        ])
    }
    
    func setupRegistrationDateLabelConstraints() {
        NSLayoutConstraint.activate([
            registrationDateLabel.topAnchor.constraint(
                equalTo: viewProfileButton.bottomAnchor,
                constant: .dateTopOffset
            ),
            registrationDateLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            registrationDateLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let avatarSize: Self = 100
    static let usernameTopOffset: Self = 12
    static let subscriptionTopOffset: Self = 6
    static let buttonTopOffset: Self = 16
    static let buttonWidth: Self = 200
    static let buttonHeight: Self = 40
    static let buttonCornerRadius: Self = 20
    static let dateTopOffset: Self = 24
}

private extension String {
    
    static let viewProfileTitle = "Посмотреть профиль"
}
