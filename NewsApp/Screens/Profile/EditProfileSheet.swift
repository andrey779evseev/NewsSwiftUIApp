//
//  EditProfileSheet.swift
//  NewsApp
//
//  Created by Andrew on 3/31/23.
//

import SwiftUI

struct EditProfileSheet: View {
    @EnvironmentObject var auth: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading = false
    @State private var error: EditProfile.Error = .none
    @State private var nickname = ""
    @State private var name = ""
    @State private var about = ""
    @State private var site = ""
    @State private var photo: URL? = nil
    
    func save() {
        isLoading = true
        auth.user!.update(
            nickname: nickname,
            name: name,
            about: about,
            site: site,
            photo: photo!.absoluteString
        )
        UserRepository.updateUser(auth.user!) {
            isLoading = false
            dismiss()
        }
    }
 
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.dark)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Text("Редактировать профиль")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                Spacer()
                if isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20))
                        .foregroundColor(.dark)
                        .onTapGesture {
                            save()
                        }
                }
            }
            EditProfile(nickname: $nickname, name: $name, about: $about, site: $site, photo: $photo, error: $error)
                .environmentObject(auth)
            Spacer()
        }
        .padding(.all, 24)
        .background(Color.white)
        .onAppear {
            nickname = auth.user!.nickname
            name = auth.user!.name
            about = auth.user!.about
            site = auth.user!.site
            photo = URL(string: auth.user!.photo)
        }
    }
}

struct EditProfileSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSheet()
    }
}
