//
//  NavigationTitle.swift
//  NewsApp
//
//  Created by Andrew on 3/27/23.
//

import SwiftUI

struct NavigationTitle: View {
    var text: String
    var back: () -> Void
    var body: some View {
        HStack {
            Image(systemName: "arrow.backward")
                .font(.system(size: 20))
                .foregroundColor(.body)
                .onTapGesture {
                    back()
                }
            Spacer()
            Text(text)
                .poppinsFont(.footnoteBold)
                .foregroundColor(.dark)
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.body)
                .rotationEffect(.degrees(90))
        }
        .padding(.horizontal, 8)
    }
}

struct NavigationTitle_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTitle(text: "GG") {}
    }
}
