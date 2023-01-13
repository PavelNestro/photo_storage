//
//  Comments.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 18.10.22.
//

import Foundation
import UIKit

class Comments: Codable {
    var data: Date
    var comment: String
    init(comment: String, data: Date) {
        self.comment = comment
        self.data = data
    }
    enum CodingKeys: String, CodingKey {
        case data = " data"
        case comment = "comment"
    }
}
