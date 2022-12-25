//
//  ViewControllerFactory.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 8.08.22.
//

import Foundation
import UIKit

class ViewControllerFactory {
    static let sheard = ViewControllerFactory()
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    private init() {}
    
    func createViewController() -> ViewControllerSelectPhoto? {
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewControllerSelectPhoto") as? ViewControllerSelectPhoto
        return viewController
    }
    
    func createCommentViewController() -> CommentViewController {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController else {
            return CommentViewController()
        }
        return viewController
    }
    
    
}
