//
//  NotificationRepository.swift
//  NewsApp
//
//  Created by Andrew on 4/11/23.
//

import Foundation


struct NotificationRepository {
    public static func saveNotification(from fromUserUid: String, postName: String? = nil, to toUserUid: String, type: NotificationModel.NotificationType) async {
        let toUser = await UserRepository.getUser(toUserUid)!
        let notification = NotificationModel(fromUserUid: fromUserUid, createdAt: Date.now, type: type, postName: postName)
        do {
            try db.collection("users").document(toUser.id!).collection("notifications").addDocument(from: notification)
        } catch {
            print("Error while saving notification: \(error.localizedDescription)")
        }
    }
    
    public static func getNotifications (_ userId: String) async -> [ExtendedNotificationModel] {
        do {
            let snapshot = try await db.collection("users").document(userId).collection("notifications").getDocuments()
            let result = snapshot.documents.compactMap { document in
                do {
                    return try document.data(as: NotificationModel.self)
                } catch {
                    print("error when parsing following model \(error)")
                    return nil
                }
            }
            var extendedModels: [ExtendedNotificationModel] = []
            for doc in result {
                let user = await UserRepository.getUser(doc.fromUserUid)!
                extendedModels.append(ExtendedNotificationModel(model: doc, user: user))
            }
            return extendedModels
        } catch {
            print("Error while getting notifications: \(error.localizedDescription)")
            return []
        }
    }
}
