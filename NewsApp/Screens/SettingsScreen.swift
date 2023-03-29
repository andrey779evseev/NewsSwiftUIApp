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
    @State private var nightTheme = false
    struct ListItem {
        var icon: String
        var name: String
    }
    private var list = [
        ListItem(icon: "bell", name: "Уведомления"),
        ListItem(icon: "lock", name: "Безопасность"),
        ListItem(icon: "questionmark.circle", name: "Помощь")
    ]
    var body: some View {
        VStack(spacing: 48) {
            HStack {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 24))
                    .foregroundColor(.dark)
                    .onTapGesture {
                        router.go(.profile)
                    }
                Spacer()
                Text("Настройки")
                    .poppinsFont(.subheadline)
                    .foregroundColor(.dark)
                Spacer()
                Text("\t")
            }
            ForEach(list, id: \.name) { item in
                HStack(spacing: 4) {
                    Image(systemName: item.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.dark)
                    Text(item.name)
                        .poppinsFont(.footnote)
                        .foregroundColor(.dark)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.dark)
                }
            }
            HStack(spacing: 4) {
                Image(systemName: "moon")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                Text("Темный режим")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                Toggle("", isOn: $nightTheme)
            }
            HStack(spacing: 4) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                Text("Выйти")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
            }
            .onTapGesture {
                auth.signOut()
                router.go(.login)
            }
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
