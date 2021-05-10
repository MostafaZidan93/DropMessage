//
//  FirebaseUserLestiner.swift
//  DropMessage
//
//  Created by Mostafa Zidan on 5/8/21.
//  Copyright © 2021 Mostafa Zidan. All rights reserved.
//

import Foundation
import Firebase


class FirebaseUserLestiner {
    static let shared = FirebaseUserLestiner()
    
    private init() {}
    
    
    //MARK: - Login
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil && authDataResult!.user.isEmailVerified {
                self.downloadUserFromFirebaseBy(userId: authDataResult!.user.uid, email: email)
                completion(error, true)
            } else {
                print("May be your email is not verified!!!")
                completion(error, false)
            }
        }
    }
    
    //MARK: - Register
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error ) in
            completion(error)
            if error == nil {
                //Send verification email
                authDataResult!.user.sendEmailVerification { (err) in
                    print("auth verification email was sent with error: ", err?.localizedDescription)
                }
                
                //Create  user and save it
                if authDataResult?.user != nil {
                    let user = User(id: authDataResult!.user.uid, username: email, email: email, pushId: "", avatarLink: "", status: "Hi there I'm using DropMessage")
                    
                    //Save User Locally to UserDefaults
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    
    //MARK: - Save users
    func saveUserToFirestore(_ user: User) {
        do {
            try FirebaseReference(.User).document(user.id).setData(from: user)
        } catch let error {
            print(error.localizedDescription, "Adding user")
        }
    }
    
    
    //MARK: - Download User
    func downloadUserFromFirebaseBy(userId: String, email: String? = nil) {
        FirebaseReference(.User).document(userId).getDocument { (querySnapsot, error) in
            guard let document = querySnapsot else {
                print("Error: No Document from this user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("No user object exists after decoding")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    
    //MARK: - Resend verification link
    func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                completion(error)
            })
        })
    }
    
    
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
}
