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
    
    static func showAlert(title: String,
                          message: String,
                          vc: UIViewController,
                          confirmTitle: String,
                          cancelTitle: String,
                          confirm: (() -> Void)? = nil,
                          cancel: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle,
                                          style: .cancel) { action in
            confirm?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle,
                                         style: .default) { action in
            cancel?()
        }
        confirmAction.setValue(UIColor.buttomColor, forKey: "titleTextColor")
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        vc.present(alertController, animated: true)
    }
    
    /// enum Toast 顯示時長
    enum ToastDisplayInterval {
        
        /// 顯示 Toast 1.5 秒後，移除 Toast
        case short
        
        /// 顯示 Toast 3 秒後，移除 Toast
        case long
        
        /// 自定義要顯示 Toast 幾秒後，移除 Toast
        case custom(Double)
    }
    
    /// 用 UIAlertController 顯示 Toast
    /// - Parameters:
    ///   - message: 要顯示在 Toast 上的訊息
    ///   - vc: 要在哪個畫面跳出來
    ///   - during: Toast 要顯示多久
    ///   - present: Toast 顯示出來後要做的事，預設為 nil
    ///   - dismiss: Toast 顯示消失後要做的事，預設為 nil
    class func showToastWith(message: String?,
                             vc: UIViewController,
                             during: ToastDisplayInterval,
                             present: (() -> Void)? = nil,
                             dismiss: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil,
                                                    message: message,
                                                    preferredStyle: .alert)
            vc.present(alertController, animated: true, completion: present)
            
            switch during {
            case .short:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    vc.dismiss(animated: true, completion: dismiss)
                }
            case .long:
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    vc.dismiss(animated: true, completion: dismiss)
                }
            case .custom(let interval):
                DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                    vc.dismiss(animated: true, completion: dismiss)
                }
            }
        }
    }
}

