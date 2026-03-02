//
//  MessageCell.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 02.03.26.
//

import UIKit

// MARK: - MessageCell

final class MessageCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let identifier = "MessageCell"
    
    // MARK: - Visual Components
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = .avatarSize / 2
        iv.backgroundColor = .bgActionSecondary
        iv.isHidden = true
        
        return iv
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = .bubbleCornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        
        return label
    }()
    
    // MARK: - Private Properties
    
    private var imageLoadTask: URLSessionDataTask?
    
    /// Incoming constraints
    private var bubbleLeadingToAvatar: NSLayoutConstraint!
    private var bubbleLeadingToEdge: NSLayoutConstraint!
    
    /// Outgoing constraints
    private var bubbleTrailing: NSLayoutConstraint!
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageLoadTask?.cancel()
        imageLoadTask = nil
        avatarImageView.image = nil
        avatarImageView.isHidden = true
        messageLabel.text = nil
        timeLabel.text = nil
    }
    
    // MARK: - Public Methods
    
    func configure(with message: ChatMessage, avatarUrl: String?) {
        messageLabel.text = message.content
        timeLabel.text = DateFormatHelper.messageTime(
            from: message.timestamp
        )
        
        if message.isIncoming {
            configureIncoming(avatarUrl: avatarUrl)
        } else {
            configureOutgoing()
        }
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupSubviews()
        configureConstraints()
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubviews([
            avatarImageView,
            bubbleView,
            timeLabel
        ])
        
        bubbleView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureIncoming(avatarUrl: String?) {
        // Стиль bubble
        bubbleView.backgroundColor = .bgActionSecondary
        messageLabel.textColor = .white
        timeLabel.textColor = .textSecondary
        timeLabel.textAlignment = .left
        
        // Аватарка
        avatarImageView.isHidden = false
        loadAvatar(from: avatarUrl)
        
        // Layout: avatar + bubble слева
        bubbleLeadingToAvatar.isActive = true
        bubbleLeadingToEdge.isActive = false
        bubbleTrailing.isActive = false
    }
    
    private func configureOutgoing() {
        // Стиль bubble
        bubbleView.backgroundColor = .bgAction
        messageLabel.textColor = .white
        timeLabel.textColor = .textSecondary
        timeLabel.textAlignment = .right
        
        // Без аватарки
        avatarImageView.isHidden = true
        
        // Layout: bubble справа
        bubbleLeadingToAvatar.isActive = false
        bubbleLeadingToEdge.isActive = false
        bubbleTrailing.isActive = true
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
        // Avatar — внизу слева
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: .horizontalPadding
            ),
            avatarImageView.bottomAnchor.constraint(
                equalTo: bubbleView.bottomAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: .avatarSize
            ),
            avatarImageView.heightAnchor.constraint(
                equalToConstant: .avatarSize
            )
        ])
        
        // Bubble — top
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: .verticalSpacing
            ),
            bubbleView.widthAnchor.constraint(
                lessThanOrEqualTo: contentView.widthAnchor,
                multiplier: .maxBubbleWidthRatio
            )
        ])
        
        // Incoming: bubble после avatar
        bubbleLeadingToAvatar = bubbleView.leadingAnchor.constraint(
            equalTo: avatarImageView.trailingAnchor,
            constant: .avatarBubbleSpacing
        )
        
        // Fallback (не используется, но нужен для деактивации)
        bubbleLeadingToEdge = bubbleView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: .horizontalPadding
        )
        
        // Outgoing: bubble справа
        bubbleTrailing = bubbleView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -.horizontalPadding
        )
        
        // Message label внутри bubble
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(
                equalTo: bubbleView.topAnchor,
                constant: .bubblePaddingVertical
            ),
            messageLabel.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor,
                constant: .bubblePaddingHorizontal
            ),
            messageLabel.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor,
                constant: -.bubblePaddingHorizontal
            ),
            messageLabel.bottomAnchor.constraint(
                equalTo: bubbleView.bottomAnchor,
                constant: -.bubblePaddingVertical
            )
        ])
        
        // Time label под bubble
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(
                equalTo: bubbleView.bottomAnchor,
                constant: .timeTopSpacing
            ),
            timeLabel.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor
            ),
            timeLabel.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor
            ),
            timeLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -.verticalSpacing
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let horizontalPadding: Self = 12
    static let verticalSpacing: Self = 4
    static let avatarSize: Self = 32
    static let avatarBubbleSpacing: Self = 8
    static let bubbleCornerRadius: Self = 16
    static let bubblePaddingVertical: Self = 10
    static let bubblePaddingHorizontal: Self = 14
    static let maxBubbleWidthRatio: Self = 0.7
    static let timeTopSpacing: Self = 2
}
