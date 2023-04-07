//
//  HorizontalCard.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct HorizontalCard: View {
    @EnvironmentObject var auth: AuthService
    @Binding var post: ExtendedPostModel
    @State private var isShowPost = false
    var body: some View {
        HStack(spacing: 4) {
            RemoteImage(url: post.image, width: .constant(96), height: .constant(96))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .leading, spacing: 4) {
                Text(post.title)
                    .lineLimit(2)
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                CardInfo(user: post.user, createdAt: post.createdAt)
            }
        }
        .padding(.all, 8)
        .onTapGesture {
            isShowPost = true
        }
        .sheet(isPresented: $isShowPost) {
            PostSheet(post: $post)
                .environmentObject(auth)
        }
    }
}

struct HorizontalCard_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalCard(post: .constant(TestExtendedPostModel))
    }
}
