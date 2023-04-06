//
//  CardInfo.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct CardInfo: View {
    var user: UserModel = TestUserModel
    var createdAt: Date = Date.now.addingTimeInterval(-15000)
    var body: some View {
        HStack(spacing: 0) {
            Avatar(url: user.photo, size: .small, type: .circular)
                .padding(.trailing, 4)
            Text(user.name)
                .poppinsFont(.calloutBold)
                .foregroundColor(.body)
                .padding(.trailing, 12)
            Image(systemName: "clock")
                .font(.system(size: 12))
                .foregroundColor(.body)
                .padding(.trailing, 4)
            Text(formatDate(createdAt))
                .poppinsFont(.callout)
                .foregroundColor(.body)
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: 14))
        }
    }
}

struct CardInfo_Previews: PreviewProvider {
    static var previews: some View {
        CardInfo()
    }
}
