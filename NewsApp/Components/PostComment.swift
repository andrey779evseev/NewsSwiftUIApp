//
//  PostComment.swift
//  NewsApp
//
//  Created by Andrew on 4/2/23.
//

import SwiftUI

struct PostComment: View {
    var comment: ExtendedCommentModel
    
    @State private var isLiked = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Avatar(url: comment.user.photo, size: .little, type: .circular)
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.user.name)
                    .poppinsFont(.footnoteBold)
                    .foregroundColor(.dark)
                Text(comment.text)
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Group {
                    Text(formatDate(comment.createdAt))
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 12))
                                .foregroundColor(isLiked ? .error : .dark)
                            Text("125 лайков")
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isLiked = !isLiked
                            }
                        }
                        HStack(spacing: 4) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .font(.system(size: 12))
                                .foregroundColor(.body)
                            Text("поделиться")
                        }
                    }
                }
                .poppinsFont(.callout)
                .foregroundColor(.body)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 8)
    }
}

struct PostComment_Previews: PreviewProvider {
    static var previews: some View {
        PostComment(comment: TestExtendedCommentModel)
    }
}
