//
//  Button.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

extension UiButton where LeftIcon == EmptyView {
    init(
        type: ButtonType,
        size: ButtonSize,
        text: String,
        isLoading: Bool = false,
        perform: @escaping () -> Void
    ) {
        self.init(type: type, size: size, text: text, isLoading: isLoading, perform: perform, leftIcon: {EmptyView()})
    }
}

struct UiButton<LeftIcon: View>: View {
    init(
        type: ButtonType,
        size: ButtonSize,
        text: String,
        isLoading: Bool = false,
        perform: @escaping () -> Void,
        leftIcon: @escaping () -> LeftIcon
    ) {
        self.type = type
        self.size = size
        self.text = text
        self.isLoading = isLoading
        self.perform = perform
        self.leftIcon = leftIcon
    }
    
    var type: ButtonType
    var size: ButtonSize
    var text: String
    var isLoading: Bool = false
    var perform: () -> Void
    @ViewBuilder var leftIcon: () -> LeftIcon
    
    var height: CGFloat {
        switch size {
        case .big:
            return 50
        case .medium:
            return 48
        case .small:
            return 28
        }
    }
    var colors: (Color, Color, Color) {
        switch type {
        case .primary:
            return (.blue, .white, .white)
        case .secondary:
            return (.buttonSecondary, .button, .button)
        case .outline:
            return (.blue, .blue, .blue)
        }
    }
    
    var rect: RoundedRectangle {
        RoundedRectangle(cornerRadius: 6)
    }
    
    var hasLeftIcon: Bool {
        !(
            leftIcon() is EmptyView
        )
    }
    
    @ViewBuilder
    var body: some View {
        let btn = Button {
            perform()
        } label: {
            ZStack {
                
                if type == .outline {
                    rect.stroke(colors.0)
                } else {
                    rect.fill(colors.0)
                }
                    
                HStack(spacing: 10) {
                    if hasLeftIcon {
                        leftIcon()
                    }
                    if isLoading {
                        ProgressView()
                            .tint(colors.2)
                    } else {
                        Text(text)
                            .poppinsFont(size == .small ? .calloutBold : .footnoteBold)
                            .foregroundColor(colors.1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 8)
            }
            .frame(height: height)
        }
        if size == .small {
            btn.fixedSize()
        } else {
            btn
        }
    }
    
    public enum ButtonType {
        case primary
        case secondary
        case outline
    }
    
    public enum ButtonSize {
        case big
        case medium
        case small
    }
}

struct UiButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            UiButton(type: .primary, size: .big, text: "Войти", perform: { })
            UiButton(type: .primary, size: .big, text: "Войти", isLoading: true, perform: { })
            UiButton(type: .secondary, size: .medium, text: "Войти", perform: { })
            UiButton(type: .secondary, size: .big, text: "Войти", isLoading: true, perform: { })
            UiButton(type: .outline, size: .medium, text: "Войти", perform: { })
            UiButton(type: .outline, size: .medium, text: "Войти", isLoading: true, perform: { })
            UiButton(type: .outline, size: .small, text: "Войти", perform: { })
        }
        .padding()
    }
}
