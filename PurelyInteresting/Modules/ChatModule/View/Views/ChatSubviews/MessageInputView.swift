//
//  MessageInputView.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MessageInputViewDelegate

protocol MessageInputViewDelegate: AnyObject {
    
    func messageInputView(
        _ view: MessageInputView,
        didSendMessage text: String
    )
}

// MARK: - MessageInputView

final class MessageInputView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MessageInputViewDelegate?
    
    // MARK: - Visual Components
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgActionSecondary
        view.layer.cornerRadius = .containerCornerRadius
        
        return view
    }()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.font = .roboto(.regular, size: 14)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: .placeholder,
            attributes: [
                .foregroundColor: UIColor.textSecondary
            ]
        )
        textField.returnKeyType = .send
        
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 18, weight: .semibold
        )
        button.setImage(
            UIImage(
                systemName: .sendIcon,
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .bgAction
        
        return button
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
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupSubviews()
        configureConstraints()
        setupActions()
    }
    
    private func setupSubviews() {
        backgroundColor = .bgPrimary
        
        addSubviews([containerView])
        
        containerView.addSubviews([
            messageTextField,
            sendButton
        ])
    }
    
    private func configureConstraints() {
        setupContainerViewConstraints()
        setupMessageTextFieldConstraints()
        setupSendButtonConstraints()
    }
    
    private func setupActions() {
        sendButton.addTarget(
            self,
            action: #selector(sendButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func sendButtonTapped() {
        guard let text = messageTextField.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }
        
        delegate?.messageInputView(self, didSendMessage: text)
        messageTextField.text = nil
    }
}

// MARK: - Constraints

private extension MessageInputView {
    
    func setupContainerViewConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: .containerVerticalPadding
            ),
            containerView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: .containerHorizontalPadding
            ),
            containerView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -.containerHorizontalPadding
            ),
            containerView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -.containerVerticalPadding
            ),
            containerView.heightAnchor.constraint(
                equalToConstant: .containerHeight
            )
        ])
    }
    
    func setupMessageTextFieldConstraints() {
        NSLayoutConstraint.activate([
            messageTextField.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: .textFieldHorizontalPadding
            ),
            messageTextField.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            ),
            messageTextField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: -.textFieldSpacing
            )
        ])
    }
    
    func setupSendButtonConstraints() {
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -.sendButtonTrailing
            ),
            sendButton.centerYAnchor.constraint(
                equalTo: containerView.centerYAnchor
            ),
            sendButton.widthAnchor.constraint(
                equalToConstant: .sendButtonSize
            ),
            sendButton.heightAnchor.constraint(
                equalToConstant: .sendButtonSize
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let containerHorizontalPadding: Self = 16
    static let containerVerticalPadding: Self = 8
    static let containerHeight: Self = 44
    static let containerCornerRadius: Self = 22
    static let textFieldHorizontalPadding: Self = 16
    static let textFieldSpacing: Self = 8
    static let sendButtonTrailing: Self = 8
    static let sendButtonSize: Self = 32
}

private extension String {
    
    static let placeholder = "Сообщение..."
    static let sendIcon = "paperplane.fill"
}
