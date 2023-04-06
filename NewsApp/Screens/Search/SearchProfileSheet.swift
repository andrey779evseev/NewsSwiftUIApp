//
//  SearchProfileScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/28/23.
//

import SwiftUI

struct SearchProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    var user: UserModel
    var isFollowed: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitle(text: "") {
                dismiss()
            }
            UserProfile(user: user, type: isFollowed ? .followed : .unfollowed, auth: AuthService.forTest()) {}
        }
        .padding(.all, 24)
        .background(Color.white)
    }
}

struct SearchProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        SearchProfileSheet(user: TestUserModel, isFollowed: true)
    }
}
