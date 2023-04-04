//
//  AuthForm.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI

struct AuthForm: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var auth: AuthService
    var isLogin: Bool
    @State var email = ""
    @State var password = ""
    @State var error: AuthService.Error = .none
    @State var isLoading = false
    @State var rememberMe = true
    
    func validate () -> Bool {
        if email.isEmpty {
            error = .emptyEmail
            return false
        }
        if password.isEmpty {
            error = .emptyPassword
            return false
        }
        if password.count < 8 {
            error = .shortPassword
            return false
        }
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capitalTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard capitalTest.evaluate(with: password) else {
            error = .weakPasswordCapital
            return false
        }
        let numberRegEx  = ".*[0-9]+.*"
        let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard numberTest.evaluate(with: password) else {
            error = .weakPasswordNumber
            return false
        }
        return true
    }
    
    func login () {
        let valid = validate()
        if !valid {
            return
        } else {
            error = .none
            isLoading = true
        }
        if isLogin {
            auth.signIn(email: email, password: password) { error in
                if let error = error {
                    self.error = error
                }
                isLoading = false
            }
        } else {
            auth.signUp(email: email, password: password) { error in
                if let error = error {
                    print(error)
                    self.error = error
                }
                isLoading = false
            }
        }
    }
    
    var emailError: String? {
        switch error {
        case .invalidEmailFormat:
            return "Неверный формат email"
        case .userDoesNotExist:
            return "Неверный email"
        case .emptyEmail:
            return "Введите email"
        case .alreadyExist:
            return "Аккаунт с этим email уже зарегистрирован"
        default:
            return nil
        }
    }
    
    var passwordError: String? {
        switch error {
        case .userDoesNotExist:
            return "Неверный пароль"
        case .emptyPassword:
            return "Введите пароль"
        case .shortPassword:
            return "Пароль должен быть не менее 8 символов"
        case .weakPasswordCapital:
            return "Пароль должен содержать заглавную букву"
        case .weakPasswordNumber:
            return "Пароль должен содержать цифру"
        default:
            return nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                Text("Привет,")
                    .poppinsFont(.largeTitle)
                    .foregroundColor(isLogin ? .dark : .blue)
                if isLogin {
                    Text("Снова!")
                        .poppinsFont(.largeTitle)
                        .foregroundColor(.info)
                }
                Text(isLogin ? "С возвращением, мы скучали" : "Зарегистрируйтесь чтобы начать")
                    .poppinsFont(.headline)
                    .foregroundColor(.body)
                    .padding(.leading, 4)
            }
            .padding(.bottom, 64)
            Input(
                value: $email,
                label: "Email",
                placeholder: "Введите ваш email",
                required: true,
                autocapitalization: false,
                error: emailError
            )
            .padding(.bottom, 16)
            
            Input(
                value: $password,
                label: "Пароль",
                placeholder: "Введите ваш пароль",
                required: true,
                isPassword: true,
                error: passwordError,
                enterPerform: login
            )
            
            
            Checkbox(value: $rememberMe, label: "Запомнить меня")
            .padding(.vertical, 16)
            
            UiButton(type: .primary, size: .big, text: isLogin ? "Войти" : "Зарегистрироваться", isLoading: isLoading, perform: login)
            
            Text("или продолжить с")
                .poppinsFont(.caption)
                .foregroundColor(.body)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 30) {
                UiButton(type: .secondary, size: .medium, text: "Facebook", perform: {}) {
                    Image("Facebook")
                }
                UiButton(type: .secondary, size: .medium, text: "Google", perform: {}) {
                    Image("Google")
                }
            }
            .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Text(isLogin ? "еще нет акаунта ? " : "Уже есть аккаунт ? ")
                    .poppinsFont(.caption)
                    .foregroundColor(.body)
                Text(isLogin ? "Зарегистрироваться" : "Войти")
                    .poppinsFont(.captionBold)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        router.go(isLogin ? .registration : .login)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.all, 24)
    }
}

struct AuthForm_Previews: PreviewProvider {
    static var previews: some View {
        AuthForm(isLogin: true)
        AuthForm(isLogin: false)
    }
}
