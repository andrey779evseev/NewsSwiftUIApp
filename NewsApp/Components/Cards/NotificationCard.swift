//
//  NotificationCard.swift
//  NewsApp
//
//  Created by Andrew on 3/26/23.
//

import SwiftUI

struct NotificationCard: View {
    @EnvironmentObject var auth: AuthService
    var notification: ExtendedNotificationModel
    
    @State private var followed: FollowModel?
    @State private var isLoading = true
    
    var isFollowed: Bool {
        followed != nil
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Avatar(url: notification.user.photo, size: .medium, type: .circular)
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    switch notification.type {
                    case .post:
                        Text("**\(notification.user.name)** опубликовал(-ла) пост “\(notification.postName!)”")
                    case .follow:
                        Text("**\(notification.user.name)** подписался(-ась) на ваши обновления")
                    case .comment:
                        Text("**\(notification.user.name)** прокоментировал(-ла) вашу публикацию “\(notification.postName!)“")
                    case .like:
                        Text("**\(notification.user.name)** понравилась ваша публикация “\(notification.postName!)")
                    }
                }
                .poppinsFont(.footnote)
                .lineLimit(2)
                .foregroundColor(.dark)
                
                Text(formatDate(notification.createdAt))
                    .poppinsFont(.callout)
                    .foregroundColor(.body)
                if notification.type == .follow {
                    UiButton(
                        type: .outline,
                        size: .small,
                        text: isFollowed ? "Отписаться" : "Подписаться",
                        isLoading: isLoading,
                        perform: {
                            Task {
                                isLoading = true
                                if isFollowed {
                                    await FollowRepository.unfollow(followed!.id!, from: auth.user!.id!, by: followed!.uid)
                                    followed = nil
                                } else {
                                    self.followed = await FollowRepository.follow(notification.fromUserUid, with: auth.user!.id!, by: auth.user!.uid)
                                }
                                isLoading = false
                            }
                        },
                        leftIcon: {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        })
                    .padding(.top, 12)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 14)
        .background(Color.gray20)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .task {
            followed = await FollowRepository.getFollowed(notification.fromUserUid, by: auth.user!.id!)
            isLoading = false
        }
    }
    enum NotificationType {
        case post
        case follow
        case comment
        case like
    }
}

//struct NotificationCard_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            NotificationCard(type: .post)
//            NotificationCard(type: .follow)
//            NotificationCard(type: .comment)
//        }
//        .padding()
//    }
//}
