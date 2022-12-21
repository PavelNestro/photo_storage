//
//  swipeRecognaizer.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 18.08.22.
//

import Foundation
class SwipeRecognaizer {
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeRight.direction = UISwipeGestureRecognizer.Direction.right
    self.view.addGestureRecognizer(swipeRight)

    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
    swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
    self.view.addGestureRecognizer(swipeLeft)
}
