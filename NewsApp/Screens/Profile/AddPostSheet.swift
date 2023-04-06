//
//  AddPostSheet.swift
//  NewsApp
//
//  Created by Andrew on 4/3/23.
//

import SwiftUI
import PhotosUI

struct AddPostSheet: View {
    @EnvironmentObject var auth: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var image: String?
    
    @State private var name = ""
    @State private var text = ""
    @State private var isUploadingImage = false
    @State private var isLoading = false
    
    func loadImage(_ data: Data) {
        FirebaseStorage.uploadImage(data, with: auth.user!.uid, at: .posts) { url in
            if let url = url {
                image = url.absoluteString
                isUploadingImage = false
            }
        }
    }
    
    func publish () {
        guard !isUploadingImage && image != nil else {return}
        
        let model = PostModel(image: image!, title: name, text: text, userUid: auth.user!.uid)
        Task {
            isLoading = true
            await PostRepository.createPost(model)
            isLoading = false
            dismiss()
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 20))
                            .foregroundColor(.body)
                            .onTapGesture {
                                dismiss()
                            }
                        Spacer()
                        Text("Создать Новость")
                            .poppinsFont(.footnote)
                            .foregroundColor(.dark)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(.body)
                            .rotationEffect(.degrees(90))
                    }
                    
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if let image = image {
                                RemoteImage(url: image, width: .max, height: .constant(184))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            } else {
                                ZStack {
                                    let rect = RoundedRectangle(cornerRadius: 6)
                                    rect.fill(Color.gray20)
                                    rect
                                        .strokeBorder(style: StrokeStyle(dash: [10], dashPhase: 10))
                                        .foregroundColor(.body)
                                    if isUploadingImage {
                                        ProgressView()
                                            .tint(.blue)
                                            .scaleEffect(3)
                                    } else {
                                        VStack(spacing: 8) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 20))
                                                .foregroundColor(.body)
                                            Text("Добавить обложку")
                                                .poppinsFont(.caption)
                                                .foregroundColor(.body)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 184)
                            }
                        }
                        .onChange(of: selectedImage) { newItem in
                            Task {
                                isUploadingImage = true
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    loadImage(data)
                                }
                            }
                        }
                    
                    VStack(spacing: 0) {
                        TextField("", text: $name)
                            .poppinsFont(.title3)
                            .foregroundColor(.dark)
                            .placeholder(when: name.isEmpty) {
                                Text("Заголовок новости")
                                    .poppinsFont(.title3)
                                    .foregroundColor(.placeholder)
                            }
                        Rectangle()
                            .foregroundColor(.gray40)
                            .frame(height: 1)
                    }
                    Editor(text: $text)
                        .frame(height: UIScreen.main.bounds.size.height / 2 - 80)
                }
                .padding([.top, .leading, .trailing], 24)
            }
            
            
            HStack(spacing: 24) {
                Group {
                    Image(systemName: "textformat.alt")
                    Image(systemName: "text.alignleft")
                    Image(systemName: "photo")
                    Image(systemName: "ellipsis")
                }
                .font(.system(size: 20))
                .foregroundColor(.body)
                
                UiButton(type: .secondary, size: .big, text: "Опубликовать", isLoading: isLoading) {
                    publish()
                }
            }
            .frame(height: 78)
            .padding(.horizontal, 24)
            .barShadow()
        }
        .background(Color.white)
    }
}

struct AddPostSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPostSheet()
    }
}
