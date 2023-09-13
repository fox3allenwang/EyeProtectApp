//
//  CustomTabBarView.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit

class CustomTabBarView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var social: TabBarItemView!
    @IBOutlet weak var equipment: TabBarItemView!
    @IBOutlet weak var concentrateMode: TabBarItemView!
    @IBOutlet weak var news: TabBarItemView!
    @IBOutlet weak var personal: TabBarItemView!
    
    
    // MARK: - Variables
    var tapIndexClosure: ((Int) -> Void)?
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        addXibView()
    }
    
    // MARK: - UI Settings
    
    func setupInit() {
        social.setupInit(index: 1,
                         image: "person.2",
                         delegate: self)
        equipment.setupInit(index: 3,
                            image: "lightbulb.circle",
                            delegate: self)
        concentrateMode.setupInit(index: 2,
                                  image: "buttomColorIcon",
                                  delegate: self)
        news.setupInit(index: 0,
                                   image: "newspaper",
                                   delegate: self)
        personal.setupInit(index: 4,
                            image: "person.text.rectangle",
                            delegate: self)
        
    }
    
    func noTapAnimation(btn: TabBarItemView) {
        UIView.transition(with: btn, duration: 0.5, options: .transitionCrossDissolve) {
            btn.igvIcon.tintColor = .buttomColor
        }
    }
    
    func noTapForConcentrate(btn: TabBarItemView) {
        UIView.transition(with: btn, duration: 0.5, options: .transitionCrossDissolve) {
            btn.igvIcon.image = UIImage(named: "ButtomColor2Icon")
        }
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension

fileprivate extension CustomTabBarView {
    // 加入畫面
    func addXibView() {
        if let loadView = Bundle(for: CustomTabBarView.self)
            .loadNibNamed("CustomTabBarView",
                          owner: self,
                          options: nil)?.first as? UIView {
            addSubview(loadView)
            loadView.frame = bounds
            setupInit()
        }
    }
}

extension CustomTabBarView: TapTabBarDelegate {
    func tapTabBar(indexTap: Int) {
        switch indexTap {
        case 0:
            noTapAnimation(btn: equipment)
            noTapForConcentrate(btn: concentrateMode)
            noTapAnimation(btn: social)
            noTapAnimation(btn: personal)
        case 1:
            noTapAnimation(btn: news)
            noTapForConcentrate(btn: concentrateMode)
            noTapAnimation(btn: equipment)
            noTapAnimation(btn: personal)
        case 2:
            noTapAnimation(btn: social)
            noTapAnimation(btn: equipment)
            noTapAnimation(btn: news)
            noTapAnimation(btn: personal)
        case 3:
            noTapAnimation(btn: social)
            noTapAnimation(btn: news)
            noTapForConcentrate(btn: concentrateMode)
            noTapAnimation(btn: personal)
        default:
            noTapAnimation(btn: social)
            noTapAnimation(btn: equipment)
            noTapForConcentrate(btn: concentrateMode)
            noTapAnimation(btn: news)
        }
        
        tapIndexClosure?(indexTap)
    }
}

// MARK: - Protocol
