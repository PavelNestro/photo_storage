//
//  MessageTableViewCell.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 23.12.22.
//

import Foundation
import UIKit

class MessageTableViewCell: UITableViewCell {

    static let identifier = "MassageTableViewCell"

    @IBOutlet weak var messageContentView: UIView!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var textLable: UILabel!
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale =  Locale(identifier: "ru")
        return dateFormatter
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    private func setup() {
          messageContentView.layer.cornerRadius = 14
      }

    func setup(with message: Comments) {
        self.textLable.text = message.comment
        self.timeLable.text = dateFormatter.string(from: message.data)
    }
}
