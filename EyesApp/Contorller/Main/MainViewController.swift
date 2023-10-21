//
//  MainViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import Lottie
import SwiftEntryKit

class MainViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var customTabBarView: CustomTabBarView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var animateView: UIView!
    @IBOutlet weak var cameraManuView: UIView!
    @IBOutlet weak var btnFatigueDetection: UIButton!
    @IBOutlet weak var btnEyeExcrise: UIButton!
    @IBOutlet weak var vFriendInviteList: UIView!
    @IBOutlet weak var tbvFriendInviteList: UITableView!
    
    
    // MARK: - Variables
    let socialVC = SocialViewController()
    let equipmentVC = EquipmentViewController()
    let concentrateVC = ConcentrateViewController()
    let NewsVC = NewsViewController()
    let personalVC = PersonalViewController()
    var vc: [UIViewController] = []
    let vcTitleArray = ["NEWS", "SOCILA", "CONCENTRATE", "EQUIPMENT", "PERSIONAL"]
    var cameraMenuButtomItem: UIBarButtonItem?
    var showFriendInviteListButtonItem: UIBarButtonItem?
    var friendNotificationButtonItem: UIBarButtonItem?
    var lastVC: Int? = nil
    var friendInviteListArray: [friendInviteListInfo] = []
    var haveFriendInvite = false
    
    
    var cameraMenuStatus: CameraMenueStatus = .close
    enum CameraMenueStatus {
        case open
        case close
    }
    
    struct friendInviteListInfo {
        var accountId: String
        var name: String
        var email: String
        var image: String
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissAddfriendInviteView), name: .addFriendInviteViewDismiss, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeBellStyle), name: .reciveFriendInvite, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNavigation()
        setupCustomTabBarView()
        setupAnimate()
        setupCameraMenuView()
        setupFriendInviteListView()
    }
    
    func setupCameraMenuView() {
        cameraManuView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cameraManuView.layer.shadowOpacity = 0.4
        cameraManuView.layer.shadowRadius = 20
        cameraManuView.alpha = 0.9
        cameraManuView.layer.cornerRadius = 20
    }
    
    func setupAnimate() {
        let animationView = LottieAnimationView(name: "OLas")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: animateView.frame.width * 10, height: animateView.frame.height * 4)
        animationView.center = CGPoint(x: animateView.bounds.size.width * 0.53, y:  animateView.bounds.size.height * 2)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animateView.addSubview(animationView)
        animationView.play()
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    
    func setupCustomTabBarView() {
        customTabBarView.layer.cornerRadius = 25
        customTabBarView.clipsToBounds = true
        customTabBarView.layer.borderWidth = 2
        customTabBarView.layer.borderColor = UIColor.buttomColor?.cgColor
        updateView(index: 2)
        customTabBarView.tapIndexClosure = { index in
            self.updateView(index: index)
        }
    }
    
    func setupFriendInviteListView() {
        vFriendInviteList.layer.cornerRadius = 50
        vFriendInviteList.layer.shadowOffset = .zero
        vFriendInviteList.layer.shadowRadius = 10
        vFriendInviteList.layer.shadowOpacity = 0.2
        
        tbvFriendInviteList.register(UINib(nibName: "FriendInviteTableViewCell", bundle: nil), forCellReuseIdentifier: FriendInviteTableViewCell.identified)
        tbvFriendInviteList.dataSource = self
        tbvFriendInviteList.delegate = self
    }
    
    func updateView(index: Int) {
        // 會逐個掃描，並把 vc 裡 children 沒有的 view 放進 children 裡
        vc = [NewsVC, socialVC, concentrateVC, equipmentVC, personalVC]
        if children.first(where: { String(describing: $0.classForCoder) == String(describing: vc[index].classForCoder) }) == nil {
            addChild(vc[index])
            vc[index].view.frame = containerView.bounds
        }
        navigationItem.title = vcTitleArray[index]
        // 將中間的 container 替換成閉包, delegate 帶進來的值
        for i in 0 ... 4 {
            if i != index {
                vc[i].view.removeFromSuperview()
            }
        }
        containerView.addSubview(vc[index].view)
        if index == 1 {
            callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
            if haveFriendInvite == true {
                friendNotificationButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.badge.fill"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(clickShowFriendInviteView))
                friendNotificationButtonItem?.tintColor = .orange
            } else {
                friendNotificationButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(clickShowFriendInviteView))
                friendNotificationButtonItem?.tintColor = .white
            }
           
            showFriendInviteListButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill.badge.plus"), style: .plain, target: self, action: #selector(clickFriendNotification))
            
            navigationItem.rightBarButtonItems = [showFriendInviteListButtonItem!, friendNotificationButtonItem!]
        } else {
            if vFriendInviteList.isHidden == false {
                clickShowFriendInviteView()
            }
            cameraMenuButtomItem = UIBarButtonItem(image: UIImage(systemName: "vial.viewfinder"), style: .done, target: self, action: #selector(clickCameraMenu))
            NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
            navigationItem.rightBarButtonItems = [cameraMenuButtomItem!]
        }
    }
    
    // MARK: - CallAPIFriendInviteList
    
    func callApiFriendInviteList(accountId: UUID) {
        friendInviteListArray = []
        let request = GetFriendInviteListRequest(accountId: accountId)
        
        Task {
            do {
                let result: GeneralResponse<GetFriendInviteListResponse> = try await NetworkManager().requestData(method: .post,
                                                                                                         path: .getFriendInviteList,
                                                                                                         parameters: request,
                                                                                                         needToken: true)
                if result.message == "此帳號目前有好友邀請" {
                    result.data?.friendinviteInfo.forEach({ friendinviteInfo in
                        friendInviteListArray.append(friendInviteListInfo(accountId: friendinviteInfo.accountId,
                                                                          name: friendinviteInfo.name,
                                                                          email: friendinviteInfo.email,
                                                                          image: friendinviteInfo.image))
                    })
                    friendNotificationButtonItem?.tintColor = .yellow
                    friendNotificationButtonItem?.image = UIImage(systemName: "bell.badge.fill")
                    haveFriendInvite = true
                } else if result.message == "此帳號目前沒有好友邀請" {
                    haveFriendInvite = false
                } else {
                    Alert.showAlert(title: "請確認與伺服器的連線", message: "", vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "請確認與伺服器的連線", message: "", vc: self, confirmTitle: "確認")
            }
        }
        tbvFriendInviteList.reloadData()
    }
    
    // MARK: - IBAction
    
    @objc func clickCameraMenu() {
        let transformValue = cameraManuView.frame.width
        if cameraMenuStatus == .open {
            UIView.animate(withDuration: 0.1) {
                self.cameraManuView.transform = CGAffineTransform(translationX: 0,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnFatigueDetection.transform = CGAffineTransform(translationX: 0,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnEyeExcrise.transform = CGAffineTransform(translationX: 0,
                                                              y: 0)
            }
            cameraMenuStatus = .close
        } else {
            UIView.animate(withDuration: 0.1) {
                self.cameraManuView.transform = CGAffineTransform(translationX: 0 - transformValue,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnFatigueDetection.transform = CGAffineTransform(translationX: 0 - transformValue,
                                                              y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnEyeExcrise.transform = CGAffineTransform(translationX: 0 - transformValue,
                                                              y: 0)
            }
            cameraMenuStatus = .open
        }
    }
    
    @objc func clickFriendNotification() {
        if SwiftEntryKit.isCurrentlyDisplaying(entryNamed: "Center Note") {
            
        } else {
            let addFriendVC = AddFriendViewController()
            var attributes = EKAttributes()
            attributes.name = "Center Note"
            attributes.precedence = .override(priority: .low, dropEnqueuedEntries: false)
            attributes.entryInteraction = .absorbTouches
            attributes.screenInteraction = .dismiss
            attributes.windowLevel = .custom(level: UIWindow.Level.normal)
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.2, radius: 10, offset: .zero))
            attributes.statusBar = .dark
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: self.view.frame.width * 0.8 ), height: .intrinsic)
            attributes.position = .center
            attributes.displayDuration = .infinity
            attributes.roundCorners = .all(radius: 50)
            
            let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20)
            let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset)
            attributes.positionConstraints.keyboardRelation = keyboardRelation
            
            SwiftEntryKit.display(entry: addFriendVC, using: attributes)
          
        }
       
        
        
    }
    
    @objc func dismissAddfriendInviteView() {
        SwiftEntryKit.dismiss()
    }
    
    @objc func clickShowFriendInviteView() {
        tbvFriendInviteList.reloadData()
        if vFriendInviteList.isHidden == true {
            UIView.transition(with: vFriendInviteList,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vFriendInviteList.isHidden = false
            }
        } else {
            UIView.transition(with: vFriendInviteList,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vFriendInviteList.isHidden = true
            }
        }
    }
    
    
    @objc func changeBellStyle() {
        friendNotificationButtonItem?.image = UIImage(systemName: "bell.badge.fill")
        friendNotificationButtonItem?.tintColor = .yellow
    }
    
    @IBAction func clickBtnEyeExercise() {
        let nextVC = EyeExerciseViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

// MARK: - UIPopoverPresentationControllerExtension

extension MainViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - FriendInviteListTableViewExtension

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendInviteListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendInviteTableViewCell.identified, for: indexPath) as! FriendInviteTableViewCell
        cell.lbName.text = friendInviteListArray[indexPath.row].name
        cell.lbEmail.text = friendInviteListArray[indexPath.row].email
        if friendInviteListArray[indexPath.row].image == "未設置" {
            cell.igvUserImg.image = UIImage(systemName: "person.fill")
        } else {
            cell.igvUserImg.image = friendInviteListArray[indexPath.row].image.stringToUIImage()
        }
       
        return cell
    }
    
    
}

// MARK: - Protocol
