//
//  CardInfo.swift
//  NewsApp
//
//  Created by Andrew on 3/25/23.
//

import SwiftUI

struct CardInfo: View {
    var body: some View {
        HStack(spacing: 0) {
            Avatar(url: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", size: .small, type: .circular)
                .padding(.trailing, 4)
            Text("BBC News")
                .poppinsFont(.calloutBold)
                .foregroundColor(.body)
                .padding(.trailing, 12)
            Image(systemName: "clock")
                .font(.system(size: 12))
                .foregroundColor(.body)
                .padding(.trailing, 4)
            Text("4ч назад")
                .poppinsFont(.callout)
                .foregroundColor(.body)
            Spacer()
            Image(systemName: "ellipsis")
                .font(.system(size: 14))
        }
    }
}

struct CardInfo_Previews: PreviewProvider {
    static var previews: some View {
        CardInfo()
    }
}
