//
//  Input.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

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
        rightIconPerform: (() -> Void)? = nil
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
            rightIcon: {EmptyView()}
        )
    }
}

/// if you provide custom right icon you must also provide right icon perform function

struct Input<RightIcon: View>: View {
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
        rightIcon: @escaping () -> RightIcon
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
    @ViewBuilder var rightIcon: () -> RightIcon
    @FocusState private var isFocused: Bool
    @State private var isActive = false
    @State private var isHidden = true
    
    var isError: Bool {
        error != nil
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
                    .padding(.leading, 10)
                    .padding(.trailing, 48)
                    .placeholder(when: value == "") {
                        Text(placeholder)
                            .poppinsFont(.caption)
                            .foregroundColor(.body)
                            .padding(.leading, 10)
                    }
                    .background(background)
                    .overlay(
                        isActive || isPassword || rightIconPerform != nil ?
                        HStack {
                            if rightIcon() is EmptyView {
                                Image(systemName: isPassword ? isHidden ? "eye.slash" : "eye" : "xmark")
                                    .foregroundColor(isError ? .errorDark : .body)
                                    .font(.system(.body, weight: .bold))
                            } else {
                                rightIcon()
                            }
                        }
                            .frame(width: 48, height: 48, alignment: .center)
                            .position(x: geometry.size.width - 24, y: 24)
                            .onTapGesture {
                                if let rightIconPerform = rightIconPerform {
                                    rightIconPerform()
                                } else if isPassword {
                                    isHidden = !isHidden
                                } else {
                                    value.removeAll()
                                }
                            }
                            .transition(.opacity)
                        : nil
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
            Input(value: .constant(""), label: "Email", placeholder: "Введите Email", required: true, rightIconPerform: {print("gg")}) {
                Image(systemName: "pencil")
            }
            Input(value: .constant("adfdsa"), label: "Пароль", placeholder: "Введите пароль", required: true, isPassword: true)
            Input(value: .constant(""), label: "Email", placeholder: "Введите email", required: true, error: "Неверный email")
            Input(value: .constant(""), label: "Email", placeholder: "Введите Email", disabled: true)
        }
        .padding()
    }
}
