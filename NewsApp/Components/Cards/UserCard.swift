//
//  UserCard.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct UserCard: View {
    var user: UserModel
    var isFollowed: Bool
    var hideButton = false
    var perform: () -> Void
    
    @State private var followersCount = 0
    
    var body: some View {
        HStack(spacing: 0) {
            Avatar(url: user.photo, size: .medium, type: .circular)
                .padding(.trailing, 4)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name.isEmpty ? user.email : user.name)
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Text("\(followersCount.shorted()) Подписчиков")
                    .poppinsFont(.caption)
                    .foregroundColor(.body)
            }
            Spacer()
            if !hideButton {
                if isFollowed {
                    UiButton(type: .primary, size: .small, text: "Отписаться", perform: perform
                    )
                } else {
                    UiButton(type: .outline, size: .small, text: "Подписаться", perform: perform, leftIcon: {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                        .foregroundColor(.blue)})
                }
            }
        }
        .task {
            self.followersCount = await FollowRepository.getFollowersCount(user.id!)
        }
    }
}

struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UserCard(user: TestUserModel, isFollowed: true, perform: {})
            UserCard(user: TestUserModel, isFollowed: false, perform: {})
            
        }
        .padding()
    }
}
