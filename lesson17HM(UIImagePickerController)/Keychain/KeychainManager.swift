//
//  KeychainManager.swift
//  lesson17HM(UIImagePickerController)
//
//  Created by Pavel Nesterenko on 10.01.23.
//

import Foundation
import SwiftyKeychainKit

class KeychainManager {
    static let sheard = KeychainManager()
    private lazy var keychain = Keychain(service: "PNestere.lesson17HM-UIImagePickerController-")
    private let passwordKey = KeychainKey<String>(key: "password")
    private var arrayPasswordKey = [String]()
    private init() {}

    func validatePassword(_ password: String) -> Bool {
        do {
            let value = try keychain.get(passwordKey)
            return password == value
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    func savePassword(_ password: String) {
        do {
            try keychain.set(password, for: passwordKey)
            arrayPasswordKey.append(password)
            print("Password was saved")
        } catch {
            print(error.localizedDescription)
        }
    }

    func clear() {
        do {
            try keychain.removeAll()
            print("Password was removed")
        } catch {
            print(error.localizedDescription)
        }
    }
    func getPassword() -> String? {
        let value = try? keychain.get(passwordKey)
        return value
    }
}
