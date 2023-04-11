//
//  NotificationModel.swift
//  NewsApp
//
//  Created by Andrew on 4/11/23.
//

import Foundation
import FirebaseFirestoreSwift


struct NotificationModel: Codable, Identifiable {
    @DocumentID var id: String?
    var fromUserUid: String
    var createdAt: Date
    var type: NotificationType
    
    var postName: String? // for like, comment, post
    
    enum NotificationType: String, Codable {
        case like = "like"
        case comment = "comment"
        case follow = "follow"
        case post = "post"
    }
}

struct ExtendedNotificationModel: Identifiable {
    internal init(model: NotificationModel, user: UserModel) {
        self.id = model.id!
        self.fromUserUid = model.fromUserUid
        self.createdAt = model.createdAt
        self.type = model.type
        self.postName = model.postName
        self.user = user
    }
    
    var id: String
    var fromUserUid: String
    var createdAt: Date
    var type: NotificationModel.NotificationType
    
    var postName: String?
    
    var user: UserModel
}
