//
//  PostCommentSheet.swift
//  NewsApp
//
//  Created by Andrew on 4/7/23.
//

import SwiftUI

struct PostCommentSheet: View {
    @EnvironmentObject var auth: AuthService
    var post: ExtendedPostModel
    @Binding var count: Int
    var back: () -> Void
    
    @State private var comment = ""
    @State private var comments: [ExtendedCommentModel] = []
    @State private var isLoading = true
    @State private var isSendingComment = false
    
    func postComment () async {
        isSendingComment = true
        let model = CommentModel(text: comment, userUid: auth.user!.uid, createdAt: Date.now)
        if let result = await CommentRepository.addComment(model, for: post) {
            let extendedModel = ExtendedCommentModel(model: result, user: auth.user!)
            withAnimation(.spring()) {
                comments.append(extendedModel)
            }
        }
        count += 1
        isSendingComment = false
        comment = ""
    }
    
    @ViewBuilder
    var btn: some View {
        if isSendingComment {
            ProgressView()
                .tint(.white)
        } else {
            Image(systemName: "paperplane")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
                        .onTapGesture {
                            back()
                        }
                    Spacer()
                    Text("Комментарии")
                        .poppinsFont(.footnote)
                        .foregroundColor(.dark)
                    Spacer()
                    Text("\t")
                }
                if isLoading {
                    Spacer()
                    ProgressView()
                        .tint(.blue)
                        .scaleEffect(3)
                    Spacer()
                } else if comments.count == 0 {
                    Text("У этого поста еще нет комментариев")
                        .poppinsFont(.title2)
                        .foregroundColor(.dark)
                        .padding(.vertical, 80)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(comments) { comment in
                                PostComment(comment: comment)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding([.top, .leading, .trailing], 24)
            HStack(spacing: 4) {
                Input(value: $comment, placeholder: "Введите ваш комменатрий")
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.blue)
                    .frame(width: 50, height: 50)
                    .overlay(
                        btn
                    )
                    .onTapGesture {
                        Task {
                            await postComment()
                        }
                    }
            }
            .padding(.horizontal, 24)
            .frame(height: 78)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .transition(.move(edge: .trailing))
        .task {
            comments = await CommentRepository.getComments(post.id!)
            isLoading = false
        }
    }
}

struct PostCommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        PostCommentSheet(post: TestExtendedPostModel, count: .constant(1)) {}
    }
}
