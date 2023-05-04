//
//  DatabaseManager.swift
//  Instagram
//
//  Created by Mina on 26/04/2023.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared  = DatabaseManager()
    
    public let database = Database.database().reference()
    
    /// Check if username and email is available
    /// - Parameters:
    ///   - email: String representing email
    ///   - username: String representing username
    public func canCreateNewUser(with email :String, username: String , completion: @escaping (Bool) -> Void) {
        completion(true)
        
    }
    
    /// Inserts new user data to database
    /// - Parameters:
    ///   - email: String representing email
    ///   - username: String representing username
    ///   - completion: Async callback for result if database entry succeded
    public func insertNewUser(with email :String, username: String, completion: @escaping (Bool) -> Void ){
        let key = email.safeDatabaseKey()
        database.child(key).setValue(["username": username]) { error, _ in
            if error == nil {
                //succeeded
                completion(true)
                return
            }
            else {
                completion(false)
                return
            }
        }
    }
    
    
}

