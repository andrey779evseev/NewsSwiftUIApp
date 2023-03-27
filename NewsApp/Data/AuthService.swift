//
//  AuthViewModel.swift
//  NewsApp
//
//  Created by Andrew on 3/21/23.
//

import SwiftUI
import FirebaseAuth

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
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
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
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    public enum Error {
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
    }
}
