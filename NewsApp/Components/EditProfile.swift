//
//  EditProfile.swift
//  NewsApp
//
//  Created by Andrew on 3/31/23.
//

import SwiftUI
import PhotosUI

struct EditProfile: View {
    @EnvironmentObject var auth: AuthService
    @Binding var nickname: String
    @Binding var name: String
    @Binding var about: String
    @Binding var site: String
    @Binding var photo: URL?
    @Binding var error: Error
    @State private var isUploadingImage = false
    @State private var selectedItem: PhotosPickerItem? = nil
    
    func loadImage(_ data: Data) {
        FirebaseStorage.uploadImage(data, with: auth.user!.uid, at: .avatars) { url in
            if let url = url {
                photo = url
                isUploadingImage = false
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        GeometryReader { geometry in
                            Group {
                                if let photo = photo {
                                    Avatar(url: photo.absoluteString, size: .large, type: .circular)
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
        }
    }
    
    enum Error {
        case nickname
        case name
        case none
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(nickname: .constant(""), name: .constant(""), about: .constant(""), site: .constant(""), photo: .constant(nil), error: .constant(.none))
    }
}
