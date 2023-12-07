//
//  BlueLightFilterViewController.swift
//  EyesApp
//
//  Created by imac-2437 on 2023/5/19.
//

import UIKit

class BlueLightFilterViewController: UIViewController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 創建一個視圖來顯示藍光過濾效果
        let filterView = UIView(frame: view.bounds)
        filterView.backgroundColor = .systemBlue.withAlphaComponent(0.5) // 使用藍色半透明顏色模擬藍光過濾效果
        view.addSubview(filterView)
        
        setupNotificationCenterObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 在進入前景時禁用藍光過濾效果
        disableBlueLightFilter()
    }
    
    // MARK: - UI Settings
    
    private func setupUI() {
        
    }
    
    // MARK: - Function
    
    private func setupNotificationCenterObserver() {
        // 註冊通知，在 App 進入背景時啟用藍光過濾效果
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enableBlueLightFilter),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        // 註冊通知，在 App 返回前景時禁用藍光過濾效果
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(disableBlueLightFilter),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func enableBlueLightFilter() {
        // 將這個視圖的顏色設定為藍光過濾效果
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
    }
    
    @objc func disableBlueLightFilter() {
        // 將這個視圖的顏色還原為原來的顏色
        view.backgroundColor = .white
    }
}
