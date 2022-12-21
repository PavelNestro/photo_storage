//
//  UIView+FixInConteiner.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 23.08.22.
//

import Foundation
import UIKit

// будут растягивать эту вью которую передадим в эту функцию по размерам вью которое используется
extension UIView {
    
    // мы хотим привязать вью к краям вью контейнера
    func fixInContiner(_ conteiner: UIView) {
       // первое мы сравняем их frame
        self.frame = conteiner.bounds
        // добавь эту вью UIView в наш контейнер вью
        conteiner.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        //translatesAutoresizingMaskIntoConstraints это свойство отвечает за то автогенерируемые констрейны которыке икскод генерирует сам
        // мы не хотим этого и откулючим это false
        
        // пишем свои констрейны
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: conteiner , attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: conteiner , attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: conteiner , attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: conteiner , attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
    }
}

