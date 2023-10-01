//
//  String+Extension.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/1.
//

import UIKit

extension String {
    func stringToUIImage() -> UIImage {
        let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        let image = base64ToImage(imageData: imageData)
        return image
    }
    
    private func base64ToImage(imageData: Data?) -> UIImage {
        let uiimage: UIImage = UIImage.init(data: imageData!)!
        return uiimage
    }
}

