//
//  ChatCell.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatCell

final class ChatCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let identifier = "ChatCell"
    
    // MARK: - Visual Components
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = .avatarSize / 2
        iv.backgroundColor = .bgActionSecondary
        
        return iv
    }()
    
    private let onlineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = .onlineIndicatorSize / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.bgPrimary.cgColor
        view.isHidden = true
        
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        
        return label
    }()
    
    private let verifiedImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: .verifiedIcon)
        iv.tintColor = .bgAction
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        
        return iv
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textSecondary
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textSecondary
        label.textAlignment = .right
        
        return label
    }()
    
    private let unreadBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .bgAction
        label.layer.cornerRadius = .badgeSize / 2
        label.clipsToBounds = true
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        usernameLabel.text = nil
        lastMessageLabel.text = nil
        timeLabel.text = nil
        unreadBadge.isHidden = true
        onlineIndicator.isHidden = true
        verifiedImageView.isHidden = true
    }
    
    // MARK: - Public Methods
    
    func configure(with item: ChatItem) {
        avatarImageView.image = item.avatarImage
        usernameLabel.text = item.username
        lastMessageLabel.text = item.lastMessage
        timeLabel.text = item.time
        onlineIndicator.isHidden = !item.isOnline
        verifiedImageView.isHidden = !item.isVerified
        
        if item.unreadCount > 0 {
            unreadBadge.isHidden = false
            unreadBadge.text = "\(item.unreadCount)"
        } else {
            unreadBadge.isHidden = true
        }
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupSubviews()
        configureConstraints()
    }
    
    private func setupSubviews() {
        backgroundColor = .bgPrimary
        selectionStyle = .none
        
        contentView.addSubviews([
            avatarImageView,
            onlineIndicator,
            usernameLabel,
            verifiedImageView,
            lastMessageLabel,
            timeLabel,
            unreadBadge
        ])
    }
    
    private func configureConstraints() {
        setupAvatarImageViewConstraints()
        setupOnlineIndicatorConstraints()
        setupUsernameLabelConstraints()
        setupVerifiedImageViewConstraints()
        setupLastMessageLabelConstraints()
        setupTimeLabelConstraints()
        setupUnreadBadgeConstraints()
    }
}

// MARK: - Constraints

private extension ChatCell {
    
    func setupAvatarImageViewConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: .horizontalPadding
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: .avatarSize
            ),
            avatarImageView.heightAnchor.constraint(
                equalToConstant: .avatarSize
            )
        ])
    }
    
    func setupOnlineIndicatorConstraints() {
        NSLayoutConstraint.activate([
            onlineIndicator.bottomAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: -.onlineIndicatorOffset
            ),
            onlineIndicator.leadingAnchor.constraint(
                equalTo: avatarImageView.leadingAnchor,
                constant: .onlineIndicatorOffset
            ),
            onlineIndicator.widthAnchor.constraint(
                equalToConstant: .onlineIndicatorSize
            ),
            onlineIndicator.heightAnchor.constraint(
                equalToConstant: .onlineIndicatorSize
            )
        ])
    }
    
    func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: .cellVerticalPadding
            ),
            usernameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: .contentSpacing
            )
        ])
    }
    
    func setupVerifiedImageViewConstraints() {
        NSLayoutConstraint.activate([
            verifiedImageView.centerYAnchor.constraint(
                equalTo: usernameLabel.centerYAnchor
            ),
            verifiedImageView.leadingAnchor.constraint(
                equalTo: usernameLabel.trailingAnchor,
                constant: .verifiedSpacing
            ),
            verifiedImageView.widthAnchor.constraint(
                equalToConstant: .verifiedSize
            ),
            verifiedImageView.heightAnchor.constraint(
                equalToConstant: .verifiedSize
            )
        ])
    }
    
    func setupLastMessageLabelConstraints() {
        NSLayoutConstraint.activate([
            lastMessageLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: .messageTopOffset
            ),
            lastMessageLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: .contentSpacing
            ),
            lastMessageLabel.trailingAnchor.constraint(
                equalTo: unreadBadge.leadingAnchor,
                constant: -.contentSpacing
            ),
            lastMessageLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -.cellVerticalPadding
            )
        ])
    }
    
    func setupTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(
                equalTo: usernameLabel.centerYAnchor
            ),
            timeLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
    
    func setupUnreadBadgeConstraints() {
        NSLayoutConstraint.activate([
            unreadBadge.centerYAnchor.constraint(
                equalTo: lastMessageLabel.centerYAnchor
            ),
            unreadBadge.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -.horizontalPadding
            ),
            unreadBadge.heightAnchor.constraint(
                equalToConstant: .badgeSize
            ),
            unreadBadge.widthAnchor.constraint(
                greaterThanOrEqualToConstant: .badgeSize
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let horizontalPadding: Self = 16
    static let cellVerticalPadding: Self = 12
    static let avatarSize: Self = 56
    static let onlineIndicatorSize: Self = 14
    static let onlineIndicatorOffset: Self = 2
    static let contentSpacing: Self = 12
    static let verifiedSpacing: Self = 4
    static let verifiedSize: Self = 16
    static let messageTopOffset: Self = 4
    static let badgeSize: Self = 24
}

private extension String {
    
    static let verifiedIcon = "checkmark.seal.fill"
}
