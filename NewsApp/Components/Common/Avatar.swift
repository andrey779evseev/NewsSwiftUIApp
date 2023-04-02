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
        case .large:
            return 140
        case .big:
            return 100
        case .medium:
            return 70
        case .average:
            return 50
        case .little:
            return 40
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
        /// 140
        case large
        /// 100
        case big
        /// 70
        case medium
        /// 50
        case average
        /// 40
        case little
        /// 20
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
            Avatar(url: "https://images.unsplash.com/photo-1678398315175-32e77ac02145?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2486&q=80", size: .large, type: .circular)
            Avatar(url: "https://images.unsplash.com/photo-1678398315175-32e77ac02145?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2486&q=80", size: .large, type: .rectangular)
        }
    }
}
