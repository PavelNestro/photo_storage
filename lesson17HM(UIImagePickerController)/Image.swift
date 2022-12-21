//
//  Image.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 6.09.22.
//

import Foundation

class Image: Codable {
    var uid = UUID().uuidString
    var image = ""
    var likeImage = false
}
