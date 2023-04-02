//
//  PostComment.swift
//  NewsApp
//
//  Created by Andrew on 4/2/23.
//

import SwiftUI

struct PostComment: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Avatar(url: "https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj", size: .little, type: .circular)
            VStack(alignment: .leading, spacing: 4) {
                Text("BBC News")
                    .poppinsFont(.footnoteBold)
                    .foregroundColor(.dark)
                Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry.")
                    .poppinsFont(.footnote)
                    .foregroundColor(.dark)
                HStack(spacing: 12) {
                    Text("4н")
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.error)
                        Text("125 лайков")
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.body)
                        Text("поделиться")
                    }
                }
                .poppinsFont(.callout)
                .foregroundColor(.body)
            }
        }
        .padding(.all, 8)
    }
}

struct PostComment_Previews: PreviewProvider {
    static var previews: some View {
        PostComment()
    }
}
