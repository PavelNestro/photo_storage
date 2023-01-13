//
//  Stored.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 6.09.22.
//

import Foundation
class Stored {

    static let sheard = Stored()
    var imageUser = [User]()

//    func getUserClass() -> [User] {
//        if let imagesData = UserDefaults.standard.value(forKey: .keyForImageLike) as? Data {
//            do {
//                let array = try JSONDecoder().decode([User].self, from: imagesData)
//                return array
//            } catch {
//                print(error.localizedDescription)
//                return []
//            }
//        }
//        return []
//    }

    func getUserObject(for uid: String) -> User {
        if let imagesData = UserDefaults.standard.value(forKey: .keyForUserArray) as? Data {
        if let imageObject = try? JSONDecoder().decode([User].self,
        from: imagesData).filter({$0.nameImageforLike == uid}).first {
                return imageObject
            } else {
                return User()
            }
        }
        return User()
    }

    func cgangeLike(_ uid: String) {
        let imgeObject = getUserObject(for: uid)
        print("то что вытащили \(imgeObject.nameImageforLike)")
        imgeObject.likeImage = !imgeObject.likeImage
        imageUser.append(imgeObject)
        print(imageUser.count)
        let arrayImageData = try?JSONEncoder().encode(imageUser)
//        UserDefaults.standard.set(arrayImageData, forKey: UserDefaultsKeys.keyForImageLike.rawValue)
    }

}
