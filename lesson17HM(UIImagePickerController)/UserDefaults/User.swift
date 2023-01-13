//
//  User.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 7.08.22.
//

import Foundation
import UIKit
class User: Codable {
    var likeImage: Bool = false
    var nameImageforLike: String = ""
    var comments = [Comments]()
    static let sheard = User()

    func save(_ user: [User], _ forKey: UserDefaultsKeys) {
        let arrayData = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(arrayData, forKey: forKey.rawValue)
    }

    func load(_ forkey: UserDefaultsKeys) -> [User] {
        if let encodedData = UserDefaults.standard.value(forKey: forkey.rawValue) as? Data {
            do {
                let arrayUser = try JSONDecoder().decode([User].self, from: encodedData)
                return arrayUser
            } catch {
                print(error.localizedDescription)
                return []
            }
        }
        return []
    }
}
// func save(_ user: [User], _ forKey: UserDefaultsKeys) {
//    let data = user.map { try? JSONEncoder().encode($0) }
//    UserDefaults.standard.set(data, forKey: forKey.rawValue)
// }
// return encodedData.map { try! JSONDecoder().decode(User.self, from: $0) }
