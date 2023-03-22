//
//  PoppinsFont.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import Foundation
import SwiftUI

struct PoppinsFont: ViewModifier {
    var textStyle: TextStyle

    var name: String {
        switch textStyle {
        case .largeTitle, .title, .title2, .title3:
            return "Poppins Bold"
        case .body, .subheadline, .footnote, .caption, .headline, .callout:
            return "Poppins Regular"
        case .headlineBold, .subheadlineBold, .footnoteBold, .captionBold, .calloutBold:
            return "Poppins SemiBold"
        }
    }

    var size: CGFloat {
        switch textStyle {
        case .largeTitle:
            return 48
        case .title:
            return 32
        case .title2:
            return 28
        case .title3:
            return 24
        case .body:
            return 17
        case .headline:
            return 20
        case .headlineBold:
            return 20
        case .subheadline:
            return 18
        case .subheadlineBold:
            return 18
        case .footnote:
            return 16
        case .footnoteBold:
            return 16
        case .caption:
            return 14
        case .captionBold:
            return 14
        case .callout:
            return 13
        case .calloutBold:
            return 13
        }
    }

    var relative: Font.TextStyle {
        switch textStyle {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .body:
            return .body
        case .headline:
            return .headline
        case .headlineBold:
            return .headline
        case .subheadline:
            return .subheadline
        case .subheadlineBold:
            return .subheadline
        case .footnote:
            return .footnote
        case .footnoteBold:
            return .footnote
        case .caption:
            return .caption
        case .captionBold:
            return .caption
        case .callout:
            return .callout
        case .calloutBold:
            return .callout
        }
    }

    func body(content: Content) -> some View {
        content.font(.custom(name, size: size, relativeTo: relative))
    }
}

extension View {
    func poppinsFont(_ textStyle: TextStyle) -> some View {
        modifier(PoppinsFont(textStyle: textStyle))
    }
}

enum TextStyle {
    case largeTitle
    case title
    case title2
    case title3
    case body
    case headline
    case headlineBold
    case subheadline
    case subheadlineBold
    case footnote
    case footnoteBold
    case caption
    case captionBold
    case callout
    case calloutBold
}
