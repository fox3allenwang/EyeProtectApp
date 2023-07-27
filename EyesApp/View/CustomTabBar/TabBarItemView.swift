//
//  TabBarItemView.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import Lottie

class TabBarItemView: UIView {
    
    // MARK: - IBOutlet
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var igvIcon: UIImageView!
    @IBOutlet weak var animateView: UIView!
    
    
    // MARK: - Variables
    var tapIndex: Int?
    var delegate: TapTabBarDelegate?
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        addXibView()
    }
    
    // MARK: - UI Settings
    
    func setupInit(index: Int,
                   image: String,
                   delegate: TapTabBarDelegate) {
        if index == 2 {
            igvIcon.image = UIImage(named: image)
        } else {
            igvIcon.image = UIImage(systemName: image)
        }
        igvIcon.tintColor = .buttomColor
        btnTap.tag = index
        self.delegate = delegate
    }
    
    func tapAnimation(indexTap: Int) {
        let animationView = LottieAnimationView(name: "tabTap")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: animateView.frame.width * 1.2, height: animateView.frame.height * 1.2)
        animationView.center = CGPoint(x: self.bounds.size.width * 0.5, y:  self.bounds.size.height * 0.5)
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 3
        animateView.addSubview(animationView)
        animationView.play()
        if indexTap == 2 {
            UIView.transition(with: igvIcon, duration: 0.5, options: .transitionCrossDissolve) {
                self.igvIcon.image = UIImage(named: "ButtomColorIcon")
            }
        } else {
            UIView.transition(with: igvIcon, duration: 0.5, options: .transitionCrossDissolve) {
                self.igvIcon.tintColor = .themeColor
            }
        }
       
    }
    
    // MARK: - IBAction
    @IBAction func clickButton() {
        tapAnimation(indexTap: btnTap.tag)
        delegate?.tapTabBar(indexTap: btnTap.tag)
    }
    
}

// MARK: - Extension

fileprivate extension TabBarItemView {
    // 加入畫面
    func addXibView() {
        if let loadView = Bundle(for: TabBarItemView.self)
            .loadNibNamed("TabBarItemView",
                          owner: self,
                          options: nil)?.first as? UIView {
            addSubview(loadView)
            loadView.frame = bounds
        }
    }
}

// MARK: - Protocol
protocol TapTabBarDelegate {
    func tapTabBar(indexTap: Int)
}
