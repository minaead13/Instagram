//
//  StorageManager.swift
//  Instagram
//
//  Created by Mina on 26/04/2023.
//

import FirebaseStorage

public class StorageManager {
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum ICStorageManagerError: Error {
        case failedToDownload
    }
    
    public func uploadUserPhotoPost(model: UserPost, completion: @escaping (Result<URL,Error>) -> Void){
        
    }
    
    public func downloadImage(with refernce: String, completion: @escaping (Result<URL,Error>) -> Void){
        bucket.child(refernce).downloadURL { url, error in
            guard let url = url,  error == nil else {
                
                return
            }
            
            completion(.success(url))
        }
    }
}




