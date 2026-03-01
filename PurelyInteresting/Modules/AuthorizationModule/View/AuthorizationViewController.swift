//
//  AuthorizationViewController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 28.02.26.
//

import UIKit

// MARK: - AuthorizationViewProtocol

protocol AuthorizationViewProtocol: AnyObject {}

// MARK: - AuthorizationViewController

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: AuthorizationPresenterProtocol?
    
    // MARK: - Visual Components
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .authorization)
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = .title
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = .subtitle
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.loginButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .bgAction
        button.layer.cornerRadius = .buttonCornerRadius
        
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.registerButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .bgActionSecondary
        button.layer.cornerRadius = .buttonCornerRadius
        
        return button
    }()
    
    private let policyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = .policyText
        label.textColor = .textSecondary
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        
        setupSubviews()
        configureConstraints()
        setupActions()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .bgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubviews([
            logoImageView,
            titleLabel,
            subtitleLabel,
            loginButton,
            registerButton,
            policyLabel
        ])
    }
    
    private func configureConstraints() {
        setupLogoImageViewConstraints()
        setupTitleLabelConstraints()
        setupSubtitleLabelConstraints()
        setupLoginButtonConstraints()
        setupRegisterButtonConstraints()
        setupPolicyLabelConstraints()
    }
    
    private func setupActions() {
        loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped),
            for: .touchUpInside
        )
        
        registerButton.addTarget(
            self,
            action: #selector(registerButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - @objc Methods
    
    @objc private func loginButtonTapped() {
        presenter?.loginButtonTapped()
    }
    
    @objc private func registerButtonTapped() {
        presenter?.registerButtonTapped()
    }
}

// MARK: - AuthorizationViewProtocol

extension AuthorizationViewController: AuthorizationViewProtocol {}

// MARK: - Constraints

private extension AuthorizationViewController {
    
    func setupLogoImageViewConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: .logoTopOffset
            ),
            logoImageView.widthAnchor.constraint(
                equalTo: view.widthAnchor
            ),
            logoImageView.heightAnchor.constraint(
                equalToConstant: .logoHeight
            )
        ])
    }
    
    func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: .titleTopOffset
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: .horizontalPadding
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
    
    func setupSubtitleLabelConstraints() {
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: .subtitleTopOffset
            ),
            subtitleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: .horizontalPadding
            ),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
    
    func setupLoginButtonConstraints() {
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(
                equalTo: registerButton.topAnchor,
                constant: -.buttonSpacing
            ),
            loginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: .horizontalPadding
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -.horizontalPadding
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: .buttonHeight
            )
        ])
    }
    
    func setupRegisterButtonConstraints() {
        NSLayoutConstraint.activate([
            registerButton.bottomAnchor.constraint(
                equalTo: policyLabel.topAnchor,
                constant: .registerBottomOffset
            ),
            registerButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: .horizontalPadding
            ),
            registerButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -.horizontalPadding
            ),
            registerButton.heightAnchor.constraint(
                equalToConstant: .buttonHeight
            )
        ])
    }
    
    func setupPolicyLabelConstraints() {
        NSLayoutConstraint.activate([
            policyLabel.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: .policyBottomOffset
            ),
            policyLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: .horizontalPadding
            ),
            policyLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -.horizontalPadding
            )
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let horizontalPadding: Self = 24
    static let logoTopOffset: Self = 80
    static let logoHeight: Self = 322
    static let titleTopOffset: Self = 40
    static let subtitleTopOffset: Self = 12
    static let buttonHeight: Self = 52
    static let buttonSpacing: Self = 12
    static let policyBottomOffset: Self = -16
    static let registerBottomOffset: Self = -24
    static let buttonCornerRadius: Self = 12
}

private extension String {
    
    static let title = "Вход в учетную запись"
    static let subtitle = "Вход в приложение осуществляется\nчерез аккаунт в Telegram"
    static let loginButton = "Войти в приложение"
    static let registerButton = "Зарегистрироваться"
    static let policyText = "При входе или регистрации вы соглашаетесь\nс нашей Политикой использования"
}
