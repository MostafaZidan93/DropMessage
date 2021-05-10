//
//  User.swift
//  DropMessage
//
//  Created by Mostafa Zidan on 5/7/21.
//  Copyright © 2021 Mostafa Zidan. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Codable, Equatable {
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(User.self, from: dictionary)
                    return user
                } catch let error {
                    print("Error decoding user from userDefaults", error.localizedDescription)
                }
            }
        }
        return nil
    }
}


//MARK: - Equatble Protocol Emplementation
extension User {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}


func saveUserLocally(_ user: User) {
    let encoder = JSONEncoder()
    
    do {
        let userDictionary = try encoder.encode(user)
        UserDefaults.standard.setValue(userDictionary, forKey: kCURRENTUSER)
    } catch let error {
        print("Cannot convert user to json: \(error)")
    }
}
