//
//  PostSheet.swift
//  NewsApp
//
//  Created by Andrew on 4/1/23.
//

import SwiftUI

struct PostSheet: View {
    @EnvironmentObject var auth: AuthService
    var post: ExtendedPostModel = TestExtendedPostModel
    @Environment(\.dismiss) var dismiss
    @State private var isCommentsScreen = false
    
    @State private var comment = ""
    @State private var followed: FollowModel? = nil
    @State private var isLoadingFollowModel = true
    
    var label: String {
        if let _ = followed {
            return "Отписаться"
        } else {
            return "Подписаться"
        }
    }
    
    @ViewBuilder
    var body: some View {
        Group {
            if isCommentsScreen {
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                                .foregroundColor(.body)
                                .onTapGesture {
                                    withAnimation {
                                        isCommentsScreen = false
                                    }
                                }
                            Spacer()
                            Text("Комментарии")
                                .poppinsFont(.footnote)
                                .foregroundColor(.dark)
                            Spacer()
                            Text("\t")
                        }
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 8) {
                                PostComment()
                                PostComment()
                                PostComment()
                                PostComment()
                                PostComment()
                                PostComment()
                                PostComment()
                                PostComment()
                                PostComment()
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
                                Image(systemName: "paperplane")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.horizontal, 24)
                    .frame(height: 78)
                }
                .transition(.move(edge: .trailing))
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
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.error)
                        Text("24.5K")
                            .poppinsFont(.footnote)
                            .foregroundColor(.dark)
                            .padding(.trailing, 26)
                        Group {
                            Image(systemName: "ellipsis.message")
                                .font(.system(size: 20))
                                .foregroundColor(.dark)
                            Text("1K")
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
        }
    }
}

struct PostSheet_Previews: PreviewProvider {
    static var previews: some View {
        PostSheet()
    }
}
