//
//  Avatar.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI

struct Avatar: View {
    let url: URL
    let size: AvatarSize
    let type: AvatarType
    
    var sizeValue: CGFloat {
        switch size {
        case .big:
            return 140
        case .medium:
            return 70
        }
    }
    

    @ViewBuilder
    var body: some View {
        let img = AsyncImage(
            url: url,
            transaction: Transaction(animation: .easeInOut)
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .tint(Color.blue)
                    .scaleEffect(2)
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
        .frame(width: sizeValue, height: sizeValue)
        .background(Color.gray20)
        
        if type == .circular {
            img
                .clipShape(Circle())
        } else {
            img
                .clipShape(Rectangle())
        }
    }
    
    enum AvatarSize {
        case big
        case medium
    }
    enum AvatarType {
        case circular
        case rectangular
    }
}
//struct Avatar_Previews: PreviewProvider {
//    static var previews: some View {
//        Avatar()
//    }
//}
