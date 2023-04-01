//
//  RemoteImage.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct RemoteImage: View {
    let url: String
    let width: RemoteImageWidth
    let height: RemoteImageHeight
    @State private var opacity = 0.5
    
    @ViewBuilder
    var img: some View {
        if url.isEmpty {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(.gray20)
                .overlay(
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 20))
                        .foregroundColor(.error)
                )
        } else {
            AsyncImage(
                url: URL(string: url),
                transaction: Transaction(animation: .easeInOut)
            ) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                self.opacity = 0.1
                            }
                        }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.scale(scale: 0.001, anchor: .center))
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
    
    @ViewBuilder
    var rect: some View {
        let rect = Rectangle()
            .foregroundColor(Color.clear)
        switch width {
        case .max:
            switch height {
            case .max:
                rect
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .constant(let height):
                rect
                    .frame(maxWidth: .infinity)
                    .frame(height: height)
            }
        case .constant(let width):
            switch height {
            case .max:
                rect
                    .frame(width: width)
                    .frame(maxHeight: .infinity)
            case .constant(let height):
                rect
                    .frame(width: width, height: height)
            }
        }
    }
    
    var body: some View {
        rect
            .overlay(img)
            .clipShape(Rectangle())
    }
    
    enum RemoteImageWidth {
        case max
        case constant(_ width: CGFloat)
    }
    enum RemoteImageHeight {
        case max
        case constant(_ height: CGFloat)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RemoteImage(url:  "https://unsplash.com/photos/_Qv-KHHj8Vw/download?force=true", width: .constant(200), height: .constant(200))
            RemoteImage(url:  "https://unsplash.com/photos/_Qv-KHHj8Vw/download?force=true", width: .max, height: .constant(200))
            RemoteImage(url: "https://images.coolhouseplans.com/plans/44207/44207-b600.jpg", width: .max, height: .constant(210))
//                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding()
    }
}
