//
//  PostSheet.swift
//  NewsApp
//
//  Created by Andrew on 4/1/23.
//

import SwiftUI

struct PostSheet: View {
    @EnvironmentObject var auth: AuthService
    @Binding var post: ExtendedPostModel
    @Environment(\.dismiss) var dismiss
    @State private var isCommentsScreen = false
    
    @State private var followed: FollowModel? = nil
    @State private var isLoadingFollowModel = true
    
    @State private var liked: LikeModel? = nil
    @State private var commentsCount: Int = 0
    
    var label: String {
        if let _ = followed {
            return "Отписаться"
        } else {
            return "Подписаться"
        }
    }
    
    var isLiked: Bool {
        liked != nil
    }
    
    @ViewBuilder
    var body: some View {
        Group {
            if isCommentsScreen {
                PostCommentSheet(postId: post.id!, count: $commentsCount) {
                    withAnimation {
                        isCommentsScreen = false
                    }
                }
                .environmentObject(auth)
            } else {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                                .foregroundColor(.body)
                                .onTapGesture {
                                    dismiss()
                                }
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18))
                                .foregroundColor(.body)
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .foregroundColor(.body)
                                .rotationEffect(.degrees(90))
                        }
                        HStack(spacing: 4) {
                            Avatar(url: post.user.photo, size: .average, type: .circular)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(post.user.name)
                                    .poppinsFont(.footnoteBold)
                                    .foregroundColor(.dark)
                                Text(formatDate(post.createdAt))
                                    .poppinsFont(.caption)
                                    .foregroundColor(.body)
                            }
                            Spacer()
                            
                            UiButton(type: .primary, size: .small, text: label, isLoading: isLoadingFollowModel) {
                                if let followed = followed {
                                    FollowRepository.unfollow(followed.id!, with: auth.user!.id!, by: auth.user!.uid)
                                    self.followed = nil
                                } else {
                                    self.followed = FollowRepository.follow(post.userUid, with: auth.user!.id!, by: auth.user!.uid)
                                }
                            }
                        }
                        
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 16) {
                                RemoteImage(url: post.image, width: .max, height: .constant(248))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                
                                Text(post.title)
                                    .poppinsFont(.title3)
                                    .foregroundColor(.dark)
                                
                                Text(post.text)
                                    .poppinsFont(.footnote)
                                    .foregroundColor(.body)
                            }
                        }
                    }
                    .padding([.top, .leading, .trailing], 24)
                    HStack(spacing: 4) {
                        Group {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 20))
                                .foregroundColor(isLiked ? .error : .dark)
                            Text(post.likesAmount.shorted())
                                .poppinsFont(.footnote)
                                .foregroundColor(.dark)
                                .padding(.trailing, 26)
                        }
                        .onTapGesture {
                            Task {
                                if isLiked {
                                    await LikeRepository.unlike(liked!.id!, in: post.id!)
                                    withAnimation(.spring()) {
                                        liked = nil
                                        post.decrementLikes()
                                    }
                                } else {
                                    let model = await LikeRepository.like(post.id!, by: auth.user!.uid)
                                    withAnimation(.spring()) {
                                        liked = model
                                        post.incrementLikes()
                                    }
                                }
                            }
                        }
                        Group {
                            Image(systemName: "ellipsis.message")
                                .font(.system(size: 20))
                                .foregroundColor(.dark)
                            Text(commentsCount.shorted())
                                .poppinsFont(.footnote)
                                .foregroundColor(.dark)
                        }
                        .onTapGesture {
                            withAnimation {
                                isCommentsScreen = true
                            }
                        }
                        Spacer()
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 30)
                    .frame(height: 64)
                    .barShadow()
                }
            }
        }
        .background(Color.white)
        .task {
            followed = await FollowRepository.getFollowed(post.userUid, by: auth.user!.id!)
            isLoadingFollowModel = false
            liked = await LikeRepository.isLiked(post.id!, by: auth.user!.uid)
            commentsCount = await CommentRepository.count(by: post.id!)
        }
    }
}

struct PostSheet_Previews: PreviewProvider {
    static var previews: some View {
        PostSheet(post: .constant(TestExtendedPostModel))
    }
}
