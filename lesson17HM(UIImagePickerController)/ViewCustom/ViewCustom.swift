//
//  ViewCustom.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 9.08.22.
//

import UIKit
@IBDesignable
class ViewCustom: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var conteinerView: UIView!
static let sheard = ViewCustom()
    @IBInspectable var cornerRadius: CGFloat {

        get {
            return self.layer.cornerRadius
        }
        set { // вызывает когда мы присваиваем новое значение
//
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat { // borderWidth толщина границы

        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor { // цвет границы границы

        get {
            if let cgColor = self.layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return UIColor.black
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }

    var imageDidTapHandler: (() -> ())?
    var image: UIImage? = UIImage(systemName: "heart.fill") {
        didSet {
            self.imageView.image = image
        }
    }

    override init(frame: CGRect) { // это метод родительского класса UIView который мы хотим дополнить

        super.init(frame: frame)
        setup()
    }
 // используется сторибордами
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       setup()
    }

    private func setup() {
        Bundle(for: ViewCustom.self).loadNibNamed(String(describing: ViewCustom.self), owner: self, options: nil)
        #if TARGET_INTERFACE_BUILDER //
        conteinerView.frame = self.bounds
        self.addSubview(conteinerView)
        #else
        conteinerView.fixInContiner(self)
        self.layer.masksToBounds = true
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
