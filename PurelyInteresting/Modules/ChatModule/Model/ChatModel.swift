//
//  ChatModel.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 01.03.26.
//

import UIKit

// MARK: - Message

struct Message {
    
    let text: String
    let isIncoming: Bool
    let timestamp: Date
}

// MARK: - ChatUser

struct ChatUser {
    
    let username: String
    let avatarImage: UIImage?
    let lastSeenStatus: String
    let subscriptionStatus: String
    let registrationDate: String
}
