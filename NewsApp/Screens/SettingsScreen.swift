//
//  SettingsScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/29/23.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var router: Router
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isTouchedDarkMode") private var isTouchedDarkMode = false
    struct ListItem {
        var icon: String
        var name: String
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                    .onTapGesture {
                        router.go(.profile)
                    }
                Spacer()
                Text("Настройки")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                Text("\t")
            }
            .padding(.bottom, 24)
            Group {
                HStack(spacing: 4) {
                    Image(systemName: "moon")
                        .font(.system(size: 20))
                        .foregroundColor(.dark)
                    Text("Темный режим")
                        .poppinsFont(.footnote)
                        .foregroundColor(.dark)
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            if !isTouchedDarkMode {
                                isTouchedDarkMode = true
                            }
                        }
                }
                HStack(spacing: 4) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20))
                        .foregroundColor(.dark)
                    Text("Выйти")
                        .poppinsFont(.footnote)
                        .foregroundColor(.dark)
                    Spacer()
                    Text("\t")
                }
                .onTapGesture {
                    auth.signOut()
                    router.go(.login)
                }
            }
            .padding(.vertical, 24)
            Spacer()
        }
        .padding(.all, 24)
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
