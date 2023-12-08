//
//  BaseViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit

@MainActor class BaseViewController: UIViewController {
    
    func setNavigationbar(backgroundcolor: UIColor?,
                          tintColor: UIColor = .white,
                          foregroundColor: UIColor = .white) {
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.backgroundColor = backgroundcolor
        
        appearence.titleTextAttributes = [
            .foregroundColor : foregroundColor,
            .font : UIFont(name: "a Astro Space", size: 20)!
        ]
        
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.standardAppearance = appearence
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.backButtonTitle = ""
    }
}
