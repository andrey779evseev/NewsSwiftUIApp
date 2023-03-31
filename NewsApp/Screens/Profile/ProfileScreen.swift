//
//  ProfileScreen.swift
//  NewsApp
//
//  Created by Andrew on 3/29/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    @State private var isEdit = false
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\t")
                Spacer()
                Text("Профиль")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                Image(systemName: "gear")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                    .onTapGesture {
                        router.go(.settings)
                    }
            }
            UserProfile(user: auth.user!, type: .own) {
                isEdit = true
            }
            .sheet(isPresented: $isEdit) {
                EditProfileSheet()
                    .environmentObject(auth)
            }
        }
        .padding([.top, .leading, .trailing], 24)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}