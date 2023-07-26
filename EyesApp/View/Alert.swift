//
//  Alert.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import UIKit

class Alert {
    static func showAlert(title: String,
                          message: String,
                          vc: UIViewController,
                          confirmTitle: String,
                          confirm: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle,
                                          style: .default) { action in
            confirm?()
        }
        confirmAction.setValue(UIColor.buttomColor, forKey: "titleTextColor")
        alertController.addAction(confirmAction)
        vc.present(alertController, animated: true)
    }
}

