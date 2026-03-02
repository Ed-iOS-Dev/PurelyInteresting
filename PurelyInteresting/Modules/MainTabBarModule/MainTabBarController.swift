//
//  MainTabBarController.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - MainTabBarController

final class MainTabBarController: UITabBarController {
    
    // MARK: - Visual Components
    
    /// Floating tab bar
    private let floatingBar: UIView = {
        let view = UIView()
        view.backgroundColor = .bgActionSecondary
        view.layer.cornerRadius = .barHeight / 2
        view.clipsToBounds = true
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        
        return sv
    }()
    
    /// Кнопка "+"
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: 22, weight: .bold
        )
        button.setImage(
            UIImage(
                systemName: .createIcon,
                withConfiguration: imageConfig
            ),
            for: .normal
        )
        button.tintColor = .white
        button.backgroundColor = .bgAction
        button.layer.cornerRadius = .createButtonSize / 2
        
        return button
    }()
    
    /// Аватарка профиля
    private let profileAvatarView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = .profileAvatarSize / 2
        iv.backgroundColor = .bgPrimary
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .textSecondary
        
        return iv
    }()
    
    // MARK: - Private Properties
    
    /// Кнопки табов (без create и profile)
    private var tabButtons: [UIButton] = []
    
    private let tabIcons: [(normal: String, selected: String)] = [
        ("house", "house.fill"),
        ("heart", "heart.fill"),
        ("bubble.left.and.bubble.right", "bubble.left.and.bubble.right.fill")
    ]
    
    /// Маппинг: индекс кнопки -> индекс viewController
    /// 0=feed, 1=saved, create(skip), 2=messages(vc index 3), profile(vc index 4)
    private let buttonToVCIndex = [0, 1, 3]
    
    // MARK: - Public Methods
    
    func setFloatingBarHidden(_ hidden: Bool, animated: Bool = true) {
        guard animated else {
            floatingBar.alpha = hidden ? 0 : 1
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.floatingBar.alpha = hidden ? 0 : 1
        }
    }
    
    func setProfileAvatar(_ image: UIImage?) {
        profileAvatarView.image = image ?? UIImage(
            systemName: "person.circle.fill"
        )
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stripNativeTabBarItems()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateFloatingBarFrame()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        hideNativeTabBar()
        setupFloatingBar()
        setupTabButtons()
        setupCreateButton()
        setupProfileButton()
        updateSelection()
    }
    
    private func hideNativeTabBar() {
        tabBar.isHidden = true
        
        // Прозрачный appearance — убирает подписи и фон
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        // Убираем текст и иконки всех item-ов
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.clear
        ]
        itemAppearance.normal.iconColor = .clear
        itemAppearance.selected.iconColor = .clear
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    /// Убираем заголовки и иконки у нативных tabBarItem
    private func stripNativeTabBarItems() {
        viewControllers?.forEach { vc in
            vc.tabBarItem.title = nil
            vc.tabBarItem.image = nil
            vc.tabBarItem.selectedImage = nil
        }
    }
    
    private func setupFloatingBar() {
        view.addSubview(floatingBar)
        floatingBar.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: floatingBar.topAnchor
            ),
            stackView.bottomAnchor.constraint(
                equalTo: floatingBar.bottomAnchor
            ),
            stackView.leadingAnchor.constraint(
                equalTo: floatingBar.leadingAnchor,
                constant: .barHorizontalPadding
            ),
            stackView.trailingAnchor.constraint(
                equalTo: floatingBar.trailingAnchor,
                constant: -.barHorizontalPadding
            )
        ])
    }
    
    private func setupTabButtons() {
        for (index, icon) in tabIcons.enumerated() {
            let button = makeTabButton(
                iconName: icon.normal,
                tag: index
            )
            button.addTarget(
                self,
                action: #selector(tabButtonTapped(_:)),
                for: .touchUpInside
            )
            stackView.addArrangedSubview(button)
            tabButtons.append(button)
        }
    }
    
    private func setupCreateButton() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createButton.widthAnchor.constraint(
                equalToConstant: .createButtonSize
            ),
            createButton.heightAnchor.constraint(
                equalToConstant: .createButtonSize
            )
        ])
        
        createButton.addTarget(
            self,
            action: #selector(createButtonTapped),
            for: .touchUpInside
        )
        
        // Вставляем после saved (index 1), перед messages (index 2)
        stackView.insertArrangedSubview(createButton, at: 2)
    }
    
    private func setupProfileButton() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(
                equalToConstant: .tabButtonSize
            ),
            container.heightAnchor.constraint(
                equalToConstant: .tabButtonSize
            )
        ])
        
        container.addSubview(profileAvatarView)
        profileAvatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileAvatarView.centerXAnchor.constraint(
                equalTo: container.centerXAnchor
            ),
            profileAvatarView.centerYAnchor.constraint(
                equalTo: container.centerYAnchor
            ),
            profileAvatarView.widthAnchor.constraint(
                equalToConstant: .profileAvatarSize
            ),
            profileAvatarView.heightAnchor.constraint(
                equalToConstant: .profileAvatarSize
            )
        ])
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(profileTapped)
        )
        container.addGestureRecognizer(tap)
        container.isUserInteractionEnabled = true
        
        stackView.addArrangedSubview(container)
    }
    
    private func makeTabButton(iconName: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .medium
        )
        button.setImage(
            UIImage(
                systemName: iconName,
                withConfiguration: config
            ),
            for: .normal
        )
        button.tintColor = .textSecondary
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(
                equalToConstant: .tabButtonSize
            ),
            button.heightAnchor.constraint(
                equalToConstant: .tabButtonSize
            )
        ])
        
        return button
    }
    
    private func updateFloatingBarFrame() {
        let barWidth = view.bounds.width - (.barSideInset * 2)
        let bottomSafe = view.safeAreaInsets.bottom
        let y = view.bounds.height - .barHeight - .barBottomInset - bottomSafe
        
        floatingBar.frame = CGRect(
            x: .barSideInset,
            y: y,
            width: barWidth,
            height: .barHeight
        )
    }
    
    private func updateSelection() {
        let config = UIImage.SymbolConfiguration(
            pointSize: 20, weight: .medium
        )
        
        for (index, button) in tabButtons.enumerated() {
            let vcIndex = buttonToVCIndex[index]
            let isSelected = vcIndex == selectedIndex
            let iconName = isSelected
                ? tabIcons[index].selected
                : tabIcons[index].normal
            
            button.setImage(
                UIImage(
                    systemName: iconName,
                    withConfiguration: config
                ),
                for: .normal
            )
            button.tintColor = isSelected ? .white : .textSecondary
        }
        
        // Profile border
        profileAvatarView.layer.borderWidth = selectedIndex == 4 ? 2 : 0
        profileAvatarView.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - @objc Methods
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let vcIndex = buttonToVCIndex[sender.tag]
        selectedIndex = vcIndex
        updateSelection()
    }
    
    @objc private func profileTapped() {
        selectedIndex = 4
        updateSelection()
    }
    
    @objc private func createButtonTapped() {
        // TODO: - Обработка нажатия на "+"
    }
}

// MARK: - Constants

private extension CGFloat {
    
    static let barHeight: Self = 60
    static let barSideInset: Self = 16
    static let barBottomInset: Self = 8
    static let barHorizontalPadding: Self = 20
    static let createButtonSize: Self = 50
    static let tabButtonSize: Self = 44
    static let profileAvatarSize: Self = 32
}

private extension String {
    
    static let createIcon = "plus"
}
