//
//  NotificationCard.swift
//  NewsApp
//
//  Created by Andrew on 3/26/23.
//

import SwiftUI

struct NotificationCard: View {
    var type: NotificationType
    
    var body: some View {
        HStack(spacing: 16) {
            Avatar(url: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", size: .medium, type: .circular)
            VStack(alignment: .leading, spacing: 4) {
                Group {
                    switch type {
                    case .post:
                        Text("**BBC News** опубликовал(-ла) пост “Lorem ipsum lorem ipsum”")
                    case .follow:
                        Text("**Modelyn Saris** подписался(-ась) на ваши обновления")
                    case .comment:
                        Text("**Omar Merditz** прокоментировал(-ла) вашу публикацию “Minting Your First NFT: A“")
                    case .like:
                        Text("**Modelyn Saris** понравилась ваша публикация “Minting Your First NFT: A")
                    }
                }
                .poppinsFont(.footnote)
                .lineLimit(2)
                .foregroundColor(.dark)
                
                Text("15м назад")
                    .poppinsFont(.callout)
                    .foregroundColor(.body)
                if type == .follow {
                    UiButton(type: .outline, size: .small, text: "Подписаться", perform: {}, leftIcon: {
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
    }
    enum NotificationType {
        case post
        case follow
        case comment
        case like
    }
}

struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NotificationCard(type: .post)
            NotificationCard(type: .follow)
            NotificationCard(type: .comment)
        }
        .padding()
    }
}
