//
//  Alert.swift
//  EyesApp
//
//  Created by imac-2626 on 2023/5/26.
//

import UIKit

@MainActor class Alert: NSObject {
    
    class func showAlertWith(title: String,
                             message: String,
                             vc: UIViewController,
                             confirmTitle: String,
                             confirm: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirm?()
        }
        alertController.addAction(confirmAction)
        vc.present(alertController, animated: true)
    }
}
