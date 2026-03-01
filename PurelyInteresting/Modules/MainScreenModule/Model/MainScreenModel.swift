//
//  MainScreenModel.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - ChatItem

struct ChatItem {
    
    let username: String
    let avatarImage: UIImage?
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let isOnline: Bool
    let isVerified: Bool
}
