//
//  InitializationFirstStep.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI
import WrappingStack

struct InitializationFirstStep: View {
    init(
        auth: AuthService,
        next: @escaping () -> Void
    ) {
        self.next = next
        self.auth = auth
        self._model = StateObject(wrappedValue: AccountInitializationViewModel(userId: auth.user!.id!, uid: auth.user!.uid))
    }
    
    var next: () -> Void
    @ObservedObject var auth: AuthService
    @StateObject private var model: AccountInitializationViewModel
    @State private var search = ""
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("Выберите источники новостей")
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Input(value: $search, placeholder: "Поиск", rightIconPerform: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.body)
                }
                .onChange(of: search) { value in
                    withAnimation {
                        model.getSuggestions(value)
                    }
                }
                .padding(.vertical, 16)
                ScrollView(showsIndicators: false) {
                    WrappingHStack(id: \.uid, alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
                        ForEach(model.suggestions, id: \.uid) {user in
                            VStack(spacing: 0) {
                                VStack {
                                    if user.photo.isEmpty {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.body)
                                    } else {
                                        Avatar(url: URL(string: user.photo)!, size: .medium, type: .rectangular)
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(Color.gray20)
                                Text(user.name.isEmpty ? user.email : user.name)
                                    .poppinsFont(.footnote)
                                    .foregroundColor(.dark)
                                    .padding(.bottom, 8)
                                if let _ = model.following.first { $0.uid == user.uid} {
                                    UiButton(type: .primary, size: .small, text: "Отписаться") {
                                        model.unfollow(user.uid)
                                    }
                                } else {
                                    UiButton(type: .outline, size: .small, text: "Подписаться") {
                                        print("Button clicked")
                                        model.follow(user.uid)
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 5)
                            .background(Color.gray10)
                            .frame(width: 109)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 24)
            VStack {
                UiButton(type: .primary, size: .big, text: "Далее") {
                    next()
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
            .background(Color.white
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: -2)
                .mask(Rectangle().padding(.top, -20))
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 24)
    }
}

struct InitializationFirstStep_Previews: PreviewProvider {
    static var previews: some View {
        InitializationFirstStep(auth: AuthService()) {}
    }
}