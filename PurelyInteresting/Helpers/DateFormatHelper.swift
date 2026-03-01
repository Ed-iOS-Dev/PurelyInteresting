//
//  DateFormatHelper.swift
//  PurelyInteresting
//
//  Created by Эдгар Карапетян on 02.03.26.
//

import Foundation

// MARK: - DateFormatHelper

enum DateFormatHelper {
    
    // MARK: - Private Properties
    
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()
    
    private static let isoFallbackFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    // MARK: - Public Methods
    
    /// Парсит ISO 8601 строку в Date
    static func date(from string: String) -> Date? {
        isoFormatter.date(from: string)
            ?? isoFallbackFormatter.date(from: string)
    }
    
    /// Короткое время для списка чатов: "14:30" или "01.03.26"
    static func shortTime(from dateString: String) -> String? {
        guard let date = date(from: dateString) else { return nil }
        
        if Calendar.current.isDateInToday(date) {
            return timeFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Вчера"
        } else {
            return dateFormatter.string(from: date)
        }
    }
    
    /// Текст "был(а) в сети" для профиля собеседника
    static func lastSeenText(from dateString: String) -> String? {
        guard let date = date(from: dateString) else { return nil }
        
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 {
            return "В сети"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "Был(а) \(minutes) мин. назад"
        } else if Calendar.current.isDateInToday(date) {
            return "Был(а) сегодня в \(timeFormatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Был(а) вчера в \(timeFormatter.string(from: date))"
        } else {
            return "Был(а) \(dateFormatter.string(from: date))"
        }
    }
    
    /// Проверяет, был ли пользователь онлайн в последние 5 минут
    static func isRecentlyOnline(dateString: String) -> Bool {
        guard let date = date(from: dateString) else { return false }
        return Date().timeIntervalSince(date) < 300
    }
    
    /// Дата регистрации для профиля: "1 марта 2026"
    static func registrationDate(from dateString: String) -> String? {
        guard let date = date(from: dateString) else { return nil }
        return fullDateFormatter.string(from: date)
    }
    
    /// Время сообщения: "14:30"
    static func messageTime(from date: Date) -> String {
        timeFormatter.string(from: date)
    }
}
