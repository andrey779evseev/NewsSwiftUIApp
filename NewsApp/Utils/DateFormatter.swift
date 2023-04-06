//
//  DateFormatter.swift
//  NewsApp
//
//  Created by Andrew on 4/6/23.
//

import Foundation


func formatDate (_ date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.locale = Locale(identifier: "ru-RU")

    return formatter.localizedString(for: date, relativeTo: Date.now)
}
