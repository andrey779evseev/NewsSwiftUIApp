//
//  VerticalCard.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct VerticalCard: View {
    @EnvironmentObject var auth: AuthService
    @Binding var post: ExtendedPostModel
    @State private var isShowPost = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RemoteImage(url:  post.image, width: .max, height: .constant(183))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.bottom, 8)
            Text(post.title)
                .poppinsFont(.footnote)
                .foregroundColor(.dark)
                .padding(.bottom, 4)
            CardInfo(user: post.user, createdAt: post.createdAt)
                
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

struct VerticalCard_Previews: PreviewProvider {
    static var previews: some View {
        VerticalCard(post: .constant(TestExtendedPostModel))
    }
}
