//
//  Input.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

extension Input where LeftIcon == EmptyView {
    init(
        value: Binding<String>,
        label: String? = nil,
        placeholder: String,
        disabled: Bool = false,
        required: Bool = false,
        isPassword: Bool = false,
        autocapitalization: Bool = true,
        error: String? = nil,
        rightIconPerform: (() -> Void)? = nil,
        leftIconPerform: (() -> Void)? = nil,
        rightIcon: @escaping () -> RightIcon
    ) {
        self.init(
            value: value,
            label: label,
            placeholder: placeholder,
            disabled: disabled,
            required: required,
            isPassword: isPassword,
            autocapitalization: autocapitalization,
            error: error,
            rightIconPerform: rightIconPerform,
            leftIconPerform: leftIconPerform,
            rightIcon: rightIcon,
            leftIcon: {EmptyView()}
        )
    }
}

extension Input where RightIcon == EmptyView {
    init(
        value: Binding<String>,
        label: String? = nil,
        placeholder: String,
        disabled: Bool = false,
        required: Bool = false,
        isPassword: Bool = false,
        autocapitalization: Bool = true,
        error: String? = nil,
        rightIconPerform: (() -> Void)? = nil,
        leftIconPerform: (() -> Void)? = nil,
        leftIcon: @escaping () -> LeftIcon
    ) {
        self.init(
            value: value,
            label: label,
            placeholder: placeholder,
            disabled: disabled,
            required: required,
            isPassword: isPassword,
            autocapitalization: autocapitalization,
            error: error,
            rightIconPerform: rightIconPerform,
            leftIconPerform: leftIconPerform,
            rightIcon: {EmptyView()},
            leftIcon: leftIcon
        )
    }
}

extension Input where RightIcon == EmptyView, LeftIcon == EmptyView {
    init(
        value: Binding<String>,
        label: String? = nil,
        placeholder: String,
        disabled: Bool = false,
        required: Bool = false,
        isPassword: Bool = false,
        autocapitalization: Bool = true,
        error: String? = nil,
        rightIconPerform: (() -> Void)? = nil,
        leftIconPerform: (() -> Void)? = nil
    ) {
        self.init(
            value: value,
            label: label,
            placeholder: placeholder,
            disabled: disabled,
            required: required,
            isPassword: isPassword,
            autocapitalization: autocapitalization,
            error: error,
            rightIconPerform: rightIconPerform,
            leftIconPerform: leftIconPerform,
            rightIcon: {EmptyView()},
            leftIcon: {EmptyView()}
        )
    }
}

/// if you provide custom side icon you must also provide side icon perform function

struct Input<LeftIcon: View, RightIcon: View>: View {
    init(
        value: Binding<String>,
        label: String? = nil,
        placeholder: String,
        disabled: Bool = false,
        required: Bool = false,
        isPassword: Bool = false,
        autocapitalization: Bool = true,
        error: String? = nil,
        rightIconPerform: (() -> Void)? = nil,
        leftIconPerform: (() -> Void)? = nil,
        rightIcon: @escaping () -> RightIcon,
        leftIcon: @escaping () -> LeftIcon
    ) {
        self._value = value
        self.label = label
        self.placeholder = placeholder
        self.disabled = disabled
        self.required = required
        self.isPassword = isPassword
        self.autocapitalization = autocapitalization
        self.error = error
        self.rightIconPerform = rightIconPerform
        self.leftIconPerform = leftIconPerform
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }
    
    @Binding var value: String
    var label: String?
    var placeholder: String
    var disabled = false
    var required = false
    var isPassword = false
    var autocapitalization = true
    var error: String? = nil
    var rightIconPerform: (() -> Void)? = nil
    var leftIconPerform: (() -> Void)? = nil
    @ViewBuilder var leftIcon: () -> LeftIcon
    @ViewBuilder var rightIcon: () -> RightIcon
    @FocusState private var isFocused: Bool
    @State private var isActive = false
    @State private var isHidden = true
    
    var isError: Bool {
        error != nil
    }
    
    var hasLeftIcon: Bool {
//        leftIconPerform != nil
        !(
            leftIcon() is EmptyView
        )
    }
    
    var hasRightIcon: Bool {
//        rightIconPerform != nil
        !(
            rightIcon() is EmptyView
        )
    }
    
    @ViewBuilder
    var field: some View {
        if isPassword && isHidden {
            SecureField("", text: $value)
        } else {
            TextField("", text: $value)
        }
    }
    
    @ViewBuilder
    var background: some View {
        let rect = RoundedRectangle(cornerRadius: 10)
        
        if disabled {
            ZStack {
                rect.fill(Color.disabled)
                rect.stroke(Color.button.opacity(0.5))
            }
        } else {
            ZStack {
                if isError {
                    rect.fill(Color.errorLight)
                }
                rect.stroke(isError ? Color.errorDark : Color.body)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = label {
                HStack(spacing: 1) {
                    Text(label)
                        .foregroundColor(.body)
                    if required {
                        Text("*")
                            .foregroundColor(.errorDark)
                    }
                }
                .poppinsFont(.caption)
            }
            GeometryReader { geometry in
                field
                    .textInputAutocapitalization(!autocapitalization || isPassword ? .never : nil)
                    .autocorrectionDisabled(isPassword)
                    .foregroundColor(.dark)
                    .disabled(disabled)
                    .focused($isFocused)
                    .onChange(of: isFocused) { bool in
                        withAnimation {
                            isActive = bool
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .padding(.leading, hasLeftIcon ? 44 : 10)
                    .padding(.trailing, 44)
                    .placeholder(when: value == "") {
                        Text(placeholder)
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                            .padding(.leading, hasLeftIcon ? 44 : 10)
                    }
                    .background(background)
                    .overlay(
                        Group {
                            if isActive || isPassword || hasRightIcon {
                                HStack {
                                    if hasRightIcon {
                                        rightIcon()
                                    } else {
                                        Image(systemName: isPassword ? isHidden ? "eye.slash" : "eye" : "xmark")
                                            .foregroundColor(isError ? .errorDark : .body)
                                            .font(.system(.body, weight: .bold))
                                    }
                                }
                                .frame(width: 40, height: 48, alignment: .center)
                                .position(x: geometry.size.width - 24, y: 24)
                                .onTapGesture {
                                    if hasRightIcon {
                                        rightIconPerform!()
                                    } else if isPassword {
                                        isHidden = !isHidden
                                    } else {
                                        value.removeAll()
                                    }
                                }
                                .transition(.opacity)
                            }
                            if hasLeftIcon {
                                HStack {
                                   leftIcon()
                                }
                                .frame(width: 40, height: 48, alignment: .center)
                                .position(x: 24, y: 24)
                                .onTapGesture {
                                    leftIconPerform!()
                                }
                            }
                        }
                    )
            }
            .frame(height: 48)
            if isError {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.errorDark)
                    Text(error!)
                        .poppinsFont(.caption)
                        .foregroundColor(.errorDark)
                }
                .padding(.top, 2)
            }
        }
    }
}

struct Input_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Input(value: .constant("Sfgsdf"), label: "Email", placeholder: "Введите Email", autocapitalization: true)
            Input(value: .constant(""), label: "Email", placeholder: "Введите Email", required: true)
            Input(value: .constant(""), label: "Email", placeholder: "Введите Email", required: true, rightIconPerform: {print("gg")}, rightIcon: {Image(systemName: "pencil")})
            Input(
                value: .constant(""),
                label: "Email",
                placeholder: "Введите Email",
                required: true,
                rightIconPerform: {print("gg")},
                leftIconPerform: {print("gg")},
                rightIcon: {
                    Image(systemName: "pencil")
                }, leftIcon: {
                    Image(systemName: "pencil")
                }
            )
            Input(value: .constant("adfdsa"), label: "Пароль", placeholder: "Введите пароль", required: true, isPassword: true)
            Input(value: .constant(""), label: "Email", placeholder: "Введите email", required: true, error: "Неверный email")
            Input(value: .constant(""), label: "Email", placeholder: "Введите Email", disabled: true)
        }
        .padding()
    }
}
