//
//  UserNameProfile.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 10.01.23.
//

import Foundation

class UserNameProfile: Codable {
    static let sheard = UserNameProfile()
    var name = ""
    var password = ""
    var user = [User]()

    func saveUserProfile(_ userProfile: [UserNameProfile], _ forKey: UserDefaultsKeys) {
        let arrayData = try? JSONEncoder().encode(userProfile)
        UserDefaults.standard.set(arrayData, forKey: forKey.rawValue)
    }

    func loadUserProfile(_ forkey: UserDefaultsKeys) -> [UserNameProfile] {
        if let encodedData = UserDefaults.standard.value(forKey: forkey.rawValue) as? Data {
            do {
                let arrayUserProfile = try JSONDecoder().decode([UserNameProfile].self, from: encodedData)
                return arrayUserProfile
            } catch {
                print(error.localizedDescription)
                return []
            }
        }
        return []
    }
}
