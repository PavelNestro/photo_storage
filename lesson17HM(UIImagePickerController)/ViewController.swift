//
//  ViewController.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 7.08.22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var informationTextLabel: UILabel!
    @IBOutlet weak var visualEffectBlur: UIVisualEffectView!
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!

    let userDefault = UserDefaults.standard
    let user = User()
    let userNameProfile = UserNameProfile()
    var arrayUserProfile = [UserNameProfile]()
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        informationTextLabel.isHidden = true
        if textFieldUserName == nil, textFieldPassword == nil {
            createAlertTextFields()
        }
        arrayUserProfile = userNameProfile.loadUserProfile(.keyUserProfile)
        textFieldUserName.text = arrayUserProfile.last?.name
        textFieldPassword.isSecureTextEntry = true
    }

    @IBAction func singInButtonPressed(_ sender: Any) {
        createAlertTextFields()
    }

    @IBAction func logOutButtonPressed(_ sender: Any) {
        textFieldUserName.text = ""
        textFieldPassword.text = ""
        KeychainManager.sheard.clear()
    }
    @IBAction func buttonPressedOk(_ sender: UIButton) {

        if let name = textFieldUserName.text, name.isEmpty == false {
            
            if let password = textFieldPassword.text, password.isEmpty == false {

                if arrayUserProfile.filter({$0.password == password}).first != nil && arrayUserProfile.filter({$0.name == name}).first != nil {
                    KeychainManager.sheard.savePassword(password)
                    if KeychainManager.sheard.validatePassword(password) {
                        informationTextLabel.textColor = .green
                        informationTextLabel.text = "Вход разрешен"
                        informationTextLabel.isHidden = false
                        guard let viewController = ViewControllerFactory.sheard.createViewController() else {
                            print("nil")
                            return
                        }
                        navigationController?.pushViewController(viewController, animated: true)
                    }
                } else {
                    informationTextLabel.textColor = .red
                    informationTextLabel.text = "Ошибка, Вы ввели неверное имя пользователя или пароль."
                    informationTextLabel.isHidden = false
                }
            }
    }
    }

    func savePassword(_ password: String) {
        UserDefaults.standard.setValue(password, forKey: .password)
    }

    func createAlertTextFields() {
        visualEffectBlur.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let userProfileObject = UserNameProfile()
        let alert = UIAlertController(title: "Sign in with ID", message: "Please sign in to your account to continue", preferredStyle: .alert)
                present(alert, animated: true)
                let okAction = UIAlertAction(title: "Has already", style: .cancel) { (_) in
                    self.blurAnimation()
                    print("Ok")
                }

        let createAction = UIAlertAction(title: "Create", style: .default) { (_) in
            guard let fields = alert.textFields, fields.count == 2 else {
                return
            }

            let nameField = fields[0]
            let passwordField = fields[1]
            self.blurAnimation()
            guard let name = nameField.text, name.isEmpty == false,
                  let password = passwordField.text, password.isEmpty == false else {
                return
            }
            userProfileObject.name = name
            userProfileObject.password = password
            KeychainManager.sheard.savePassword(password)
            self.arrayUserProfile.append(userProfileObject)
            print(self.arrayUserProfile.count)
            self.userNameProfile.saveUserProfile(self.arrayUserProfile, .keyUserProfile)

            self.textFieldUserName.text = name
            self.textFieldPassword.text = password
        }
                alert.addTextField { field in
                    field.placeholder = "User name"
                    field.returnKeyType = .continue
                }
                alert.addTextField { field in
                    field.placeholder = "Password"
                    field.returnKeyType = .done
                    field.isSecureTextEntry = true
                }
                alert.addAction(createAction)
                alert.addAction(okAction)
    }

    func blurAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
        self.visualEffectBlur.alpha = 0
        } completion: { (_) in
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should return")
        // textField.resignFirstResponder() resignFirstResponder() это объкет на котором сфокусирован пользователь
        if textField == self.textFieldUserName {
            textFieldPassword.becomeFirstResponder()
        } else if textField == self.textFieldPassword {
            textField.resignFirstResponder()
        }
        return true
    }
}
