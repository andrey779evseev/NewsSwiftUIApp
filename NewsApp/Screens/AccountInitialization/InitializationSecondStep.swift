//
//  InitializationSecondStep.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI
import PhotosUI


struct InitializationSecondStep: View {
    @EnvironmentObject var auth: AuthService
    @EnvironmentObject var router: Router
    var back: () -> Void
    
    @State private var isLoading = false
    @State private var error: EditProfile.Error = .none
    @State private var nickname = ""
    @State private var name = ""
    @State private var about = ""
    @State private var site = ""
    @State private var photo: URL? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20))
                        .onTapGesture {
                            back()
                        }
                    Spacer()
                    Text("Заполните ваш профиль")
                        .poppinsFont(.footnoteBold)
                        .foregroundColor(.dark)
                    Spacer()
                }
                EditProfile(nickname: $nickname, name: $name, about: $about, site: $site, photo: $photo, error: $error)
                    .environmentObject(auth)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            VStack {
                UiButton(type: .primary, size: .big, text: "Далее") {
                    if nickname.isEmpty {
                        error = .nickname
                        return
                    }
                    if name.isEmpty {
                        error = .name
                        return
                    }
                    auth.user!.update(
                        nickname: nickname,
                        name: name,
                        about: about,
                        site: site,
                        photo: photo!.absoluteString
                    )
                    UserRepository.updateUser(auth.user!) {                    
                        router.go(.home)
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
            .barShadow()
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if !auth.user!.photo.isEmpty {
                photo = URL(string: auth.user!.photo)
            }
        }
    }
}

struct InitializationSecondStep_Previews: PreviewProvider {
    static var previews: some View {
        InitializationSecondStep() {}
    }
}
