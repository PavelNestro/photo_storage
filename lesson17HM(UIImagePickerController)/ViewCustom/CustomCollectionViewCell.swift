//
//  CustomCollectionViewCell.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 29.09.22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let sheard = CustomCollectionViewCell()
    static let identifier = String(describing: CustomCollectionViewCell.self)
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    var imageViewFunc: (() -> ())?
    override func prepareForReuse() {

    }
}
