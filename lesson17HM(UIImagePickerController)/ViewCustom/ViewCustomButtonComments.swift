//
//  ViewCustomButtonComments.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 11.11.22.
//

import Foundation
import UIKit

@IBDesignable
class ViewCustomButtonComments: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var viewContainer: UIView!

    @IBInspectable var cornerRadius: CGFloat {

        get {
            return self.layer.cornerRadius
        }
        set { // вызывает когда мы присваиваем новое значение

            self.layer.cornerRadius = newValue
        }
    }

    var imageDidTapHandler: (() -> ())?
    var image: UIImage? = UIImage(systemName: "bubble.left.fill") {
        didSet {
            self.imageView.image = image

        }
    }

    override init(frame: CGRect) { // инициализатор с какой то рамкой внутри которого у нас отобразится наш вью
        super .init(frame: frame) // вызываем init родительского класса
        setup()
    }

    required init?(coder: NSCoder) { // он обязательный
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        Bundle(for: ViewCustomButtonComments.self).loadNibNamed(String(describing: ViewCustomButtonComments.self), owner: self, options: nil)
        #if TARGET_INTERFACE_BUILDER //
        // owner - владелец пердадим self
        viewContainer.frame = self.bounds
        self.addSubview(viewContainer)
        #else
        viewContainer.fixInContiner(self) // посетим наш контент вью и закрепим со всех сторон констрейнами
        self.layer.masksToBounds = true // чтобы закруглился наш контент вью если мы этого не сделаем то закрушление проихойдет только с вью а контент вьб которое лежит на ней не закруглится
        #endif
       setupTapGesture()
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        imageDidTapHandler?()
    }

}
