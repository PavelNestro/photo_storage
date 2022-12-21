//
//  User.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 7.08.22.
//

import Foundation
import UIKit
class User: Codable {
    var name = ""
    var password = ""
    var likeImage:Bool = false
    var nameImageforLike: String = ""
    var comments = [Comments]()
    static let sheard = User()
    
 
    
   
   
    
    func save(_ user: [User], _ forKey: UserDefaultsKeys)  {
        let data = user.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: forKey.rawValue)
    }

    func load(_ forkey: UserDefaultsKeys) -> [User] {
        guard let encodedData = UserDefaults.standard.array(forKey: forkey.rawValue) as? [Data] else {
            return []
        }
       
        return encodedData.map { try! JSONDecoder().decode(User.self, from: $0)}
    }
    

    
    
    
}


