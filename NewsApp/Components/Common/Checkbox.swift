//
//  Checkbox.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

struct Checkbox: View {
    @Binding var value: Bool
    var label: String?
    
    var rect: RoundedRectangle {
        RoundedRectangle(cornerRadius: 3)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if value {
                rect
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
            } else {
                rect
                    .stroke(Color.button.opacity(0.3), lineWidth: 2)
                    .frame(width: 20, height: 20)
            }
            if let label = label {
                Text(label)
                    .poppinsFont(.caption)
                    .foregroundColor(.body)
            }
        }
        .onTapGesture {
            withAnimation {
                value.toggle()                
            }
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Checkbox(value: .constant(true))
            Checkbox(value: .constant(false))
        }
    }
}
