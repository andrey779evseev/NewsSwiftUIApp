//
//  AuthViewModel.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FacebookLogin
import FBSDKLoginKit


final class AuthService: ObservableObject {
    @Published var session: User? = nil
    @Published var user: UserModel? = nil
    @Published var isInitialized = false
    
    var isAuthenticated: Bool {
        user != nil
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            guard let user = user else {
                withAnimation {
                    self.isInitialized = true
                }
                return
            }
            self.session = user
            UserRepository.getUser(user.uid) { userModel in
                if let userModel = userModel {
                    self.user = userModel
                    withAnimation {
                        self.isInitialized = true
                    }
                } else {
                    self.user = UserModel.fromSession(user)
                    let id = UserRepository.createUser(self.user!)
                    if let id = id {
                        self.user!.setId(id)
                        withAnimation {
                            self.isInitialized = true
                        }
                    }
                }
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    completion(.invalidEmailFormat)
                case "There is no user record corresponding to this identifier. The user may have been deleted.",
                    "The password is invalid or the user does not have a password.":
                    completion(.userDoesNotExist)
                default:
                    print("an error occurred: " + error.localizedDescription)
                    completion(.unexpected(error: error.localizedDescription))
                }
            } else {
                completion(nil)
            }
            return
        }
    }
    
    func googleSignIn(completion: @escaping (_ error: Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        guard let root = screen.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: root) { signResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = signResult?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _, error in
                if let _ = error {
                    completion(.oautherror)
                } else {
                    completion(nil)
                }
                return
            }
            
        }
    }
    
    func facebookSignIn(completion: @escaping (_ error: Error?) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(configuration: LoginConfiguration(tracking: .enabled)) { result in
            switch result {
            case .cancelled:
                print("facebook login was canceled")
            case .failed:
                completion(.oautherror)
            case .success(_, _, let token):
                Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: token!.tokenString)) { _, error in
                    if let _ = error {
                        completion(.oautherror)
                    } else {
                        completion(nil)
                    }
                    return
                }
            }
        }
    }
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (_ error: Error?) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                switch error.localizedDescription {
                case "The email address is already in use by another account.":
                    completion(.alreadyExist)
                case "The email address is badly formatted.":
                    completion(.invalidEmailFormat)
                default:
                    print("an error occurred: " + error.localizedDescription)
                    completion(.unexpected(error: error.localizedDescription))
                }
            } else {
                completion(nil)
            }
            return
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    static func forTest() -> AuthService {
        let auth = AuthService()
        auth.user = TestUserModel
        auth.user?.setId("5HLX7eBb7EehowD2g4Sv")
        return auth
    }
    
    public enum Error: Equatable {
        case invalidEmailFormat
        case userDoesNotExist
        case unexpected(error: String)
        case none
        case emptyEmail
        case emptyPassword
        case shortPassword
        case weakPasswordCapital
        case weakPasswordNumber
        case alreadyExist
        case oautherror
    }
}
