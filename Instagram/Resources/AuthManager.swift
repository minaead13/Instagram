//
//  AuthManager.swift
//  Instagram
//
//  Created by Mina on 26/04/2023.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared  = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         - Check if username is available
         - Check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 - Creat account
                 - Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { result , error in
                    guard result != nil, error ==  nil  else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                        }
                        else{
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                // either username or email does not exist
                completion(false)
            }
            
        }
    }
    
    public func loginUser(username: String? , email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { authResult,  error in
                guard authResult != nil, error ==  nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
        else if let username = username {
            print(username)
        }
    }
    
    public func logOut(completion: (Bool) -> Void){
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch{
            completion(false)
            print(false)
            return
        }
    }
}
