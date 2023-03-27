//
//  SearchScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct SearchScreen: View {
    init(
        auth: AuthService,
        namespace: Namespace.ID
    ) {
        self.auth = auth
        self._model = StateObject(wrappedValue: FollowViewModel(userId: auth.user!.id!, uid: auth.user!.uid))
        self.namespace = namespace
    }
    var namespace: Namespace.ID
    @ObservedObject var auth: AuthService
    @StateObject private var model: FollowViewModel
    @EnvironmentObject var router: Router
    @State private var search = ""
    @State private var tab: Tabs = .news
    
    var body: some View {
        VStack(spacing: 16) {
            Input(
                value: $search,
                placeholder: "Поиск",
                autocapitalization: false,
                rightIconPerform: {
                    router.go(.home)
                },
                leftIconPerform: {},
                rightIcon: {
                Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
            }, leftIcon: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.body)
            })
            .matchedGeometryEffect(id: "input", in: namespace)
            .onChange(of: search) { value in
                if tab == .authors {
                    withAnimation {
                        model.getSuggestions(value)
                    }
                }
            }
            HStack(alignment: .top, spacing: 24) {
                VStack(spacing: 8) {
                    Text("Новости")
                        .poppinsFont(.footnote)
                        .foregroundColor(tab == .news ? .dark : .body)
                    if tab == .news {
                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(.blue)
                    }
                }
                .fixedSize()
                .onTapGesture {
                    tab = .news
                }
                VStack(spacing: 8) {
                    Text("Авторы")
                        .poppinsFont(.footnote)
                        .foregroundColor(tab == .authors ? .dark : .body)
                    if tab == .authors {
                        Rectangle()
                            .frame(height: 4)
                            .foregroundColor(.blue)
                    }
                }
                .fixedSize()
                .onTapGesture {
                    tab = .authors
                }
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    if tab == .news {
                        HorizontalCard()
                        HorizontalCard()
                        HorizontalCard()
                        HorizontalCard()
                        HorizontalCard()
                        HorizontalCard()
                    } else {
                        ForEach(model.suggestions, id: \.uid) { user in
                            UserCard(user: user, isFollowed: model.following.contains(where: { $0.uid == user.uid })) {
                                if model.following.contains(where: { $0.uid == user.uid }) {
                                    model.unfollow(user.uid)
                                } else {
                                    model.follow(user.uid)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.all, 24)
    }
    
    enum Tabs {
        case news
        case authors
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(auth: AuthService(), namespace: Namespace().wrappedValue)
    }
}
