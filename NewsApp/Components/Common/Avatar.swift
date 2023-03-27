//
//  Avatar.swift
//  NewsApp
//
//  Created by Andrew on 3/22/23.
//

import SwiftUI

struct Avatar: View {
    let url: String
    let size: AvatarSize
    let type: AvatarType
    
    var sizeValue: CGFloat {
        switch size {
        case .big:
            return 140
        case .medium:
            return 70
        case .small:
            return 20
        }
    }

    @ViewBuilder
    var body: some View {
        let img = RemoteImage(url: url, width: .constant(sizeValue), height: .constant(sizeValue))
        
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
        case small
    }
    enum AvatarType {
        case circular
        case rectangular
    }
}
struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Avatar(url: "https://images.unsplash.com/photo-1678398315175-32e77ac02145?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2486&q=80", size: .big, type: .circular)
            Avatar(url: "https://images.unsplash.com/photo-1678398315175-32e77ac02145?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2486&q=80", size: .big, type: .rectangular)
        }
    }
}
