//
//  ChatCell.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - PaddedLabel

/// Label с внутренними отступами для badge
private final class PaddedLabel: UILabel {
    
    var textInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + textInsets.left + textInsets.right
        let height = size.height + textInsets.top + textInsets.bottom
        // Минимальная ширина = высота (круг)
        return CGSize(
            width: max(width, height),
            height: height
        )
    }
}

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
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.setContentCompressionResistancePriority(
            .defaultLow, for: .horizontal
        )
        
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
    
    /// "Отлично · 5 мин." — lastMessage + время в одной строке
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .textSecondary
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(
            .defaultLow, for: .horizontal
        )
        
        return label
    }()
    
    /// Зелёная точка онлайн-статуса справа
    private let onlineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = .onlineIndicatorSize / 2
        view.isHidden = true
        
        return view
    }()
    
    /// Бейдж непрочитанных сообщений
    private let unreadBadge: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .bgAction
        label.clipsToBounds = true
        label.isHidden = true
        label.setContentHuggingPriority(
            .required, for: .horizontal
        )
        label.setContentCompressionResistancePriority(
            .required, for: .horizontal
        )
        
        return label
    }()
    
    // MARK: - Private Properties
    
    private var imageLoadTask: URLSessionDataTask?
    
    // MARK: - Initializers
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        unreadBadge.layer.cornerRadius = unreadBadge.bounds.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageLoadTask?.cancel()
        imageLoadTask = nil
        avatarImageView.image = nil
        usernameLabel.text = nil
        subtitleLabel.text = nil
        unreadBadge.isHidden = true
        unreadBadge.text = nil
        onlineIndicator.isHidden = true
        verifiedImageView.isHidden = true
    }
    
    // MARK: - Public Methods
    
    func configure(with item: ChatItem) {
        usernameLabel.text = item.username
        verifiedImageView.isHidden = !item.isVerified
        onlineIndicator.isHidden = !item.isOnline
        
        // Subtitle: "lastMessage · time"
        configureSubtitle(
            message: item.lastMessage,
            time: item.time
        )
        
        // Unread badge
        configureUnreadBadge(count: item.unreadCount)
        
        // Avatar
        if let avatarImage = item.avatarImage {
            avatarImageView.image = avatarImage
        } else {
            loadAvatar(from: item.avatarUrl)
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
            usernameLabel,
            verifiedImageView,
            subtitleLabel,
            onlineIndicator,
            unreadBadge
        ])
    }
    
    private func configureSubtitle(message: String?, time: String?) {
        var parts: [String] = []
        
        if let message, !message.isEmpty {
            parts.append(message)
        }
        
        if let time, !time.isEmpty {
            parts.append(time)
        }
        
        subtitleLabel.text = parts.joined(separator: " · ")
    }
    
    private func configureUnreadBadge(count: Int) {
        if count > 0 {
            unreadBadge.isHidden = false
            unreadBadge.text = "\(count)"
        } else {
            unreadBadge.isHidden = true
        }
    }
    
    private func loadAvatar(from urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString)
        else {
            avatarImageView.image = UIImage(
                systemName: "person.circle.fill"
            )
            avatarImageView.tintColor = .textSecondary
            return
        }
        
        imageLoadTask = URLSession.shared.dataTask(
            with: url
        ) { [weak self] data, _, _ in
            guard let data,
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
        imageLoadTask?.resume()
    }
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        setupAvatarConstraints()
        setupUsernameConstraints()
        setupVerifiedConstraints()
        setupSubtitleConstraints()
        setupOnlineIndicatorConstraints()
        setupUnreadBadgeConstraints()
    }
    
    private func setupAvatarConstraints() {
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
    
    private func setupUsernameConstraints() {
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
    
    private func setupVerifiedConstraints() {
        NSLayoutConstraint.activate([
            verifiedImageView.centerYAnchor.constraint(
                equalTo: usernameLabel.centerYAnchor
            ),
            verifiedImageView.leadingAnchor.constraint(
                equalTo: usernameLabel.trailingAnchor,
                constant: .verifiedSpacing
            ),
            verifiedImageView.trailingAnchor.constraint(
                lessThanOrEqualTo: onlineIndicator.leadingAnchor,
                constant: -.contentSpacing
            ),
            verifiedImageView.widthAnchor.constraint(
                equalToConstant: .verifiedSize
            ),
            verifiedImageView.heightAnchor.constraint(
                equalToConstant: .verifiedSize
            )
        ])
    }
    
    private func setupSubtitleConstraints() {
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: .messageTopOffset
            ),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: .contentSpacing
            ),
            subtitleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: unreadBadge.leadingAnchor,
                constant: -.contentSpacing
            ),
            subtitleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -.cellVerticalPadding
            )
        ])
    }
    
    private func setupOnlineIndicatorConstraints() {
        NSLayoutConstraint.activate([
            onlineIndicator.centerYAnchor.constraint(
                equalTo: usernameLabel.centerYAnchor
            ),
            onlineIndicator.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -.horizontalPadding
            ),
            onlineIndicator.widthAnchor.constraint(
                equalToConstant: .onlineIndicatorSize
            ),
            onlineIndicator.heightAnchor.constraint(
                equalToConstant: .onlineIndicatorSize
            )
        ])
    }
    
    private func setupUnreadBadgeConstraints() {
        NSLayoutConstraint.activate([
            unreadBadge.centerYAnchor.constraint(
                equalTo: subtitleLabel.centerYAnchor
            ),
            unreadBadge.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let horizontalPadding: Self = 16
    static let cellVerticalPadding: Self = 12
    static let avatarSize: Self = 56
    static let onlineIndicatorSize: Self = 10
    static let contentSpacing: Self = 12
    static let verifiedSpacing: Self = 4
    static let verifiedSize: Self = 16
    static let messageTopOffset: Self = 4
}

private extension String {
    
    static let verifiedIcon = "checkmark.seal.fill"
}
