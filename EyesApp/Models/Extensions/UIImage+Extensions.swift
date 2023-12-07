//
//  UIImage+Extensions.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/1.
//

import UIKit

extension UIImage {
    
    func imageToBase64() -> String {
        let imageData: Data? = self.jpegData(compressionQuality: 0.1)
        let str: String = imageData!.base64EncodedString()
        return str
    }
}
