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
    
    @State private var nickname = ""
    @State private var name = ""
    @State private var about = ""
    @State private var site = ""
    @State private var photo: URL? = nil
    @State private var isUploadingImage = false
    @State private var isLoading = false
    @State private var error: Error = .none
    @State private var selectedItem: PhotosPickerItem? = nil
    
    func loadImage(_ data: Data) {
        FirebaseStorage.uploadAvatar(data, with: auth.user!.uid) { url in
            if let url = url {
                photo = url
                isUploadingImage = false
            }
        }
    }
    
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
                HStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            GeometryReader { geometry in
                                Group {
                                    if let photo = photo {
                                        Avatar(url: photo.absoluteString, size: .big, type: .circular)
                                    } else {
                                        Circle()
                                            .fill(Color.gray20)
                                            .frame(width: 140, height: 140)
                                            .overlay(
                                                Group {
                                                    if isUploadingImage {
                                                        ProgressView()
                                                            .tint(Color.blue)
                                                            .scaleEffect(2)
                                                    } else {                 
                                                        Image(systemName: "plus")
                                                            .resizable()
                                                            .frame(width: 30, height: 30)
                                                    }
                                                }
                                            )
                                    }
                                }
                                .frame(width: 140, height: 140)
                                
                                Image(systemName: "pencil")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 16, height: 16)
                                    .background(
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 30, height: 30)
                                    )
                                    .position(x: 105, y: 125)
                            }
                            .frame(width: 140, height: 140)
                        }
                        .onChange(of: selectedItem) { newItem in
                            isUploadingImage = true
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    loadImage(data)
                                }
                            }
                        }
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                Input(
                    value: $nickname,
                    label: "Имя пользователя",
                    placeholder: "Введите имя пользователя",
                    required: true,
                    autocapitalization: false,
                    error: error == .nickname ? "Введите имя пользователя" : nil
                )
                Input(
                    value: $name,
                    label: "Полное имя",
                    placeholder: "Введите полное имя",
                    required: true,
                    error: error == .name ? "Введите полное имя" : nil
                )
                Input(
                    value: $about,
                    label: "О себе",
                    placeholder: "Введите краткое описание"
                )
                Input(
                    value: $site,
                    label: "Сайт",
                    placeholder: "Введите адрес вашего сайта",
                    autocapitalization: false
                )
                
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
                    auth.user!.initialize(
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
            .background(Color.white
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: -2)
                .mask(Rectangle().padding(.top, -20))
            )
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if !auth.user!.photo.isEmpty {
                photo = URL(string: auth.user!.photo)
            }
        }
    }
    
    enum Error {
        case nickname
        case name
        case none
    }
}

struct InitializationSecondStep_Previews: PreviewProvider {
    static var previews: some View {
        InitializationSecondStep() {}
    }
}
