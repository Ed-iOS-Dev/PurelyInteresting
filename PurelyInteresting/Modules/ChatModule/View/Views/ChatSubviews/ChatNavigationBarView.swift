//
//  ChatNavigationBarView.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatNavigationBarView

final class ChatNavigationBarView: UIView {
    
    // MARK: - Visual Components
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 18, weight: .semibold
        )
        button.setImage(
            UIImage(
                systemName: .backIcon,
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        
        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = .navAvatarSize / 2
        iv.backgroundColor = .bgActionSecondary
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.medium, size: 16)
        label.textColor = .white
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(.regular, size: 14)
        label.textColor = .textSecondary
        
        return label
    }()
    
    // MARK: - Private Properties
    
    private var imageLoadTask: URLSessionDataTask?
    
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
        usernameLabel.text = user.username
        statusLabel.text = user.lastSeenStatus
        
        if let avatarImage = user.avatarImage {
            avatarImageView.image = avatarImage
        } else {
            loadAvatar(from: user.avatarUrl)
        }
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupSubviews()
        configureConstraints()
    }
    
    private func setupSubviews() {
        addSubviews([
            backButton,
            avatarImageView,
            usernameLabel,
            statusLabel
        ])
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
        
        imageLoadTask?.cancel()
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
    
    private func configureConstraints() {
        setupBackButtonConstraints()
        setupAvatarImageViewConstraints()
        setupUsernameLabelConstraints()
        setupStatusLabelConstraints()
    }
}

// MARK: - Constraints

private extension ChatNavigationBarView {
    
    func setupBackButtonConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: .horizontalPadding
            ),
            backButton.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            backButton.widthAnchor.constraint(
                equalToConstant: .backButtonSize
            ),
            backButton.heightAnchor.constraint(
                equalToConstant: .backButtonSize
            )
        ])
    }
    
    func setupAvatarImageViewConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: backButton.trailingAnchor,
                constant: .avatarLeadingOffset
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: .navAvatarSize
            ),
            avatarImageView.heightAnchor.constraint(
                equalToConstant: .navAvatarSize
            )
        ])
    }
    
    func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: .textLeadingOffset
            ),
            usernameLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -.textVerticalOffset
            ),
            usernameLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
    
    func setupStatusLabelConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.leadingAnchor.constraint(
                equalTo: usernameLabel.leadingAnchor
            ),
            statusLabel.topAnchor.constraint(
                equalTo: centerYAnchor,
                constant: .textVerticalOffset
            ),
            statusLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let horizontalPadding: Self = 16
    static let backButtonSize: Self = 28
    static let navAvatarSize: Self = 40
    static let avatarLeadingOffset: Self = 8
    static let textLeadingOffset: Self = 10
    static let textVerticalOffset: Self = 1
}

private extension String {
    
    static let backIcon = "chevron.left"
}
