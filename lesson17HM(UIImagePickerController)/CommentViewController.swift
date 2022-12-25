//
//  CommentViewController.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 22.12.22.
//

import UIKit

class CommentViewController: UIViewController {
    var user = User()
    var arrayUserClass  = [User]()
    var name = ""
    private var messages = [Comments]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        commentTextField.delegate = self
        let nib = UINib(nibName: String(describing: MessageTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MessageTableViewCell.identifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        guard let lastValueName =  UserDefaults.standard.value(forKey: .test) as? String else {
            return
        }
      name = lastValueName
        loadComment(name)
        
       print("название картинки для комментария\(name)")
       print("количество комментариев для этой картинки \(messages)")
        
    }
    
    @objc func handleShowKeyBoard(_ notification: Notification) {if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
         let inset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
         scrollView.contentInset = inset
         }
     }
    
    @objc func handleHideKeyboard(_ notification: Notification) {
        scrollView.contentInset = .zero
    }

    func saveComment(_ stringNamePng: String) {
        arrayUserClass = user.load(.keyForUserArray)
        guard let objectUser = arrayUserClass.filter({$0.nameImageforLike == stringNamePng}).first else {
            return
        }
        if let coment = commentTextField.text, coment.isEmpty == false {
            let stringComment = Comments(comment: coment, data: Date())
            messages.append(stringComment)
            objectUser.comments = messages
        }
        user.save(arrayUserClass, .keyForUserArray)
    }
    
    func loadComment(_ stringNamePng: String) {
        arrayUserClass = user.load(.keyForUserArray)
        print("колличество объектов класса \(arrayUserClass.count)")
        print(arrayUserClass.map({$0.nameImageforLike}))
        guard let objectUser = arrayUserClass.filter({$0.nameImageforLike == stringNamePng}).first else {
            return
        }
        messages = objectUser.comments
    }
    
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: messages[indexPath.row])
        
        return cell
    }
    
    
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.commentTextField {
            saveComment(name)
            textField.resignFirstResponder()
            print(messages.count)
        }
        return true
    }
}
