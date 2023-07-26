//
//  Text+Extension.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/26.
//

import UIKit

extension UITextField {
    // 設定 TextField 圖標
    func setTextFieldImage(systemImageName: String,
                           imageX: Int,
                           imageY: Int,
                           imageWidth: Int,
                           imageheight: Int) {
        let imageView = UIImageView(frame: CGRect(x:imageX, y: imageY, width: imageWidth, height: imageheight))
        
        imageView.image = UIImage(systemName: systemImageName)
        imageView.tintColor = .buttomColor
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageViewContainerView.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        leftView = imageViewContainerView
        leftViewMode = .always
        self.tintColor = .buttomColor
    }
}

