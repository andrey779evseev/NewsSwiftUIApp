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
    @State private var isCreatePostSheet = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                .environmentObject(auth)
                .sheet(isPresented: $isEdit) {
                    EditProfileSheet()
                        .environmentObject(auth)
                }
            }
            
            Circle()
                .foregroundColor(.blue)
                .frame(width: 54, height: 54)
                .overlay(
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                )
                .padding(.bottom, 27)
                .onTapGesture {
                    isCreatePostSheet = true
                }
                .sheet(isPresented: $isCreatePostSheet) {
                    AddPostSheet()
                }
        }
        .padding([.top, .leading, .trailing], 24)
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        let auth = AuthService.forTest()
        ProfileScreen()
            .environmentObject(auth)
    }
}
