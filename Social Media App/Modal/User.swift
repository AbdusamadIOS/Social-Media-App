//
//  User.swift
//  Social Media App
//
//  Created by Abdusamad Mamasoliyev on 15/01/24.
//

import SwiftUI
import FirebaseFirestore

struct User: Identifiable, Codable {
   
    @DocumentID var id: String?
    var userName: String
    var userBio: String
    var userBioLink: String
    var userUID: String
    var userEmail: String
    var userProfileURL: URL
    
   
//   enum CodingKeys: CodingKey  {
//        case id
//        case username
//        case userBio
//        case userBioLink
//        case userUID
//        case userEmail
//        case userProfileURL
//        
//    }
    
}

enum CodingKeys: CodingKey  {
     case id
     case username
     case userBio
     case userBioLink
     case userUID
     case userEmail
     case userProfileURL
     
 }
