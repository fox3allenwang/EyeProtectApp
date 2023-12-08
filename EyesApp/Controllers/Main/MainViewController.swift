//
//  MainViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import AVFoundation
import Lottie
import SwiftEntryKit
import UIKit

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
    @IBOutlet weak var vInviteRoom: UIView!
    @IBOutlet weak var lbInviteRoomName: UILabel!
    @IBOutlet weak var tbvInviteRoomMember: UITableView!
    @IBOutlet weak var btnLeaveInviteRoom: UIButton!
    
    // MARK: - Properties
    
    let socialVC = SocialViewController()
    let equipmentVC = EquipmentViewController()
    let concentrateVC = ConcentrateViewController()
    let newsVC = NewsViewController()
    let personalVC = PersonalViewController()
    var vc: [UIViewController] = []
    let vcTitleArray = ["NEWS", "SOCIAL", "CONCENTRATE", "EQUIPMENT", "PERSIONAL"]
    var cameraMenuButtomItem: UIBarButtonItem?
    var showFriendInviteListButtonItem: UIBarButtonItem?
    var friendNotificationButtonItem: UIBarButtonItem?
    var lastVC: Int? = nil
    var friendInviteListArray: [friendInviteListInfo] = []
    var haveFriendInvite = false
    var concentrateInviteVCs: [AnserConcentrateInviteViewController] = []
    var isInviteRoomConnect = false
    var inviteRoomId = ""
    var isoValue: Float = 0.0
    private var inviteMemberList: [InviteRoomMember] = []
    
    private let captureSession = AVCaptureSession()
    private let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                      for: .video,
                                                      position: .front)
    
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
        setupCamera()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.uploadLightEnoughToGoConentrateMission),
                                               name: .goToConcentrate,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissAddfriendInviteView),
                                               name: .addFriendInviteViewDismiss,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeBellStyle),
                                               name: .reciveFriendInvite,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showConcentrateInvite(notification:)),
                                               name: .showConcentrateInvite,
                                               object: nil)
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
    
    fileprivate func setupUI() {
        setupNavigation()
        setupCustomTabBarView()
        setupAnimate()
        setupCameraMenuView()
        setupFriendInviteListView()
        setupInviteRoomView()
        setupInviteRoomMemberTableView()
    }
    
    fileprivate func setupCameraMenuView() {
        cameraManuView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cameraManuView.layer.shadowOpacity = 0.4
        cameraManuView.layer.shadowRadius = 20
        cameraManuView.alpha = 0.9
        cameraManuView.layer.cornerRadius = 20
    }
    
    fileprivate func setupAnimate() {
        let animationView = LottieAnimationView(name: "OLas")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, 
                                     y: 0,
                                     width: animateView.frame.width * 10,
                                     height: animateView.frame.height * 4)
        animationView.center = CGPoint(x: animateView.bounds.size.width * 0.53, 
                                       y: animateView.bounds.size.height * 2)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animateView.addSubview(animationView)
        animationView.play()
    }
    
    fileprivate func setupNavigation() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    
    fileprivate func setupCustomTabBarView() {
        customTabBarView.layer.cornerRadius = 25
        customTabBarView.clipsToBounds = true
        customTabBarView.layer.borderWidth = 2
        customTabBarView.layer.borderColor = UIColor.buttomColor.cgColor
        updateView(index: 2)
        customTabBarView.tapIndexClosure = { index in
            self.updateView(index: index)
        }
    }
    
    fileprivate func setupFriendInviteListView() {
        vFriendInviteList.layer.cornerRadius = 50
        vFriendInviteList.layer.shadowOffset = .zero
        vFriendInviteList.layer.shadowRadius = 10
        vFriendInviteList.layer.shadowOpacity = 0.2
        
        tbvFriendInviteList.register(FriendInviteTableViewCell.loadFromNib(), 
                                     forCellReuseIdentifier: FriendInviteTableViewCell.identifier)
        tbvFriendInviteList.tag = 0
        tbvFriendInviteList.dataSource = self
        tbvFriendInviteList.delegate = self
    }
    
    fileprivate func setupInviteRoomView() {
        vInviteRoom.layer.cornerRadius = 50
        vInviteRoom.layer.shadowOffset = .zero
        vInviteRoom.layer.shadowRadius = 10
        vInviteRoom.layer.shadowOpacity = 0.2
        
        btnLeaveInviteRoom.layer.cornerRadius = 20
        btnLeaveInviteRoom.layer.shadowOffset = .zero
        btnLeaveInviteRoom.layer.shadowRadius = 10
        btnLeaveInviteRoom.layer.shadowOpacity = 0.2
    }
    
    fileprivate func setupInviteRoomMemberTableView() {
        tbvInviteRoomMember.register(InviteRoomMemberListTableViewCell.loadFromNib(),
                                     forCellReuseIdentifier: InviteRoomMemberListTableViewCell.identifier)
        tbvInviteRoomMember.tag = 1
        tbvInviteRoomMember.dataSource = self
        tbvInviteRoomMember.delegate = self
    }
    
    fileprivate func setupCamera() {
        guard let frontCamera = frontCamera,
              let frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera) else { 
            return
        }
        let captureVideoOutput = AVCaptureVideoDataOutput()
        let quene = DispatchQueue(label: "sample buffer delegate")
        
        captureVideoOutput.setSampleBufferDelegate(self, queue: quene)
        
        captureSession.addInput(frontCameraInput)
        captureSession.addOutput(captureVideoOutput)
        
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    func updateView(index: Int) {
        // 會逐個掃描，並把 vc 裡 children 沒有的 view 放進 children 裡
        vc = [newsVC, socialVC, concentrateVC, equipmentVC, personalVC]
        if children.first(where: {
            String(describing: $0.classForCoder) == String(describing: vc[index].classForCoder)
        }) == nil {
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
            Task {
                await callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
            }
            if haveFriendInvite == true {
                friendNotificationButtonItem = UIBarButtonItem(image: UIImage(systemIcon: .bellBadgeFill),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(clickShowFriendInviteView))
                friendNotificationButtonItem?.tintColor = .yellow
            } else {
                friendNotificationButtonItem = UIBarButtonItem(image: UIImage(systemIcon: .bell),
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(clickShowFriendInviteView))
                friendNotificationButtonItem?.tintColor = .white
            }

            showFriendInviteListButtonItem = UIBarButtonItem(image: UIImage(systemIcon: .personFillBadgePlus),
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(clickFriendNotification))
            
            navigationItem.rightBarButtonItems = [showFriendInviteListButtonItem!, friendNotificationButtonItem!]
        } else {
            if vFriendInviteList.isHidden == false {
                clickShowFriendInviteView()
            }
            if #available(iOS 16.0, *) {
                cameraMenuButtomItem = UIBarButtonItem(image: UIImage(systemIcon: .vialViewfinder),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(clickCameraMenu))
            } else {
                cameraMenuButtomItem = UIBarButtonItem(image: UIImage(systemIcon: .cameraMeteringCenterWeighted),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(clickCameraMenu))
            }
            
            NotificationCenter.default.post(name: .addFriendInviteViewDismiss,object: nil)
            navigationItem.rightBarButtonItems = [cameraMenuButtomItem!]
        }
    }
    
    @objc func uploadLightEnoughToGoConentrateMission() {
        if isoValue <= 500 {
            Task {
                let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
                await callApiAddMissionComplete(missionId: UserPreferences.shared.lightEnvironmentConcentrateMissionId,
                                                accountId: UserPreferences.shared.accountId,
                                                date: now)
            }
        }
    }
    
    // MARK: - Call Backend WebSocket API
    
    func getInInviteRoom(path: ApiPathConstants, parameters: String) {
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connect(path: path,
                                        parameters: parameters,
                                        sessionDescription: "InviteRoom")
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: AddMissionComplete
    
    func callApiAddMissionComplete(missionId: String,
                                   accountId: String,
                                   date: String) async {
        let request = AddMissionCompleteRequest(missionId: UUID(uuidString: missionId)!,
                                                accountId: UUID(uuidString: accountId)!,
                                                date: date)
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addMissionComplete,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "沒有此任務") {
                    Alert.showAlert(title: "錯誤",
                                    message: result.message,
                                    vc: self,
                                    confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤",
                                message: "\(error)",
                                vc: self,
                                confirmTitle: "確認")
        }
    }
    
    // MARK: FriendInviteList
    
    func callApiFriendInviteList(accountId: UUID) async {
        let request = GetFriendInviteListRequest(accountId: accountId)
            do {
                let result: GeneralResponse<GetFriendInviteListResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                       path: .getFriendInviteList,
                                                                                                                       parameters: request,
                                                                                                                       needToken: true)
                if result.message.isEqual(to: "此帳號目前有好友邀請") {
                    friendInviteListArray = []
                    result.data.friendinviteInfo.forEach { friendInviteInfo in
                        friendInviteListArray.append(friendInviteListInfo(accountId: friendInviteInfo.accountId,
                                                                          name: friendInviteInfo.name,
                                                                          email: friendInviteInfo.email,
                                                                          image: friendInviteInfo.image))
                    }
                    friendNotificationButtonItem?.tintColor = .yellow
                    friendNotificationButtonItem?.image = UIImage(systemIcon: .bellBadgeFill)
                    haveFriendInvite = true
                    tbvFriendInviteList.reloadData()
                } else if result.message.isEqual(to: "此帳號目前沒有好友邀請") {
                    friendInviteListArray = []
                    friendNotificationButtonItem?.tintColor = .white
                    friendNotificationButtonItem?.image = UIImage(systemIcon: .bell)
                    haveFriendInvite = false
                    tbvFriendInviteList.reloadData()
                } else {
                    Alert.showAlert(title: "請確認與伺服器的連線",
                                    message: "",
                                    vc: self,
                                    confirmTitle: "確認")
                    tbvFriendInviteList.reloadData()
                }
            } catch {
                print(error)
                Alert.showAlert(title: "請確認與伺服器的連線",
                                message: "",
                                vc: self,
                                confirmTitle: "確認")
                tbvFriendInviteList.reloadData()
        }
    }
    
    // MARK: AddFriend
    
    func callApiAddFriend(reciveAccountId: String, sendAccountId: String) async {
        let request = AcceptOrRejectFriendRequest(reciveAccountId: UUID(uuidString: reciveAccountId)!,
                                                  sendAccountId: UUID(uuidString: sendAccountId)!)
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addFriend,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "新增好友成功") {
                    Alert.showToastWith(message: "加入好友成功！", 
                                        vc: self,
                                        during: .short,
                                        present: nil) {
                        Task {
                            await self.callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
                        }
                        NotificationCenter.default.post(name: .addFriend, object: nil)
                    }
                } else {
                    Alert.showAlert(title: "請確認與伺服器的連線",
                                    message: "",
                                    vc: self,
                                    confirmTitle: "確認") {
                        Task {
                            await self.callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
                        }
                    }
                }
            } catch {
                print(error)
                Alert.showAlert(title: "請確認與伺服器的連線",
                                message: "",
                                vc: self,
                                confirmTitle: "確認") {
                    Task {
                        await self.callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
                    }
                }
            }
        
    }
    
    // MARK: RejectFriendInvite
    
    func callApiRejectFriendInvite(reciveAccountId: String, sendAccountId: String) async {
        let request = AcceptOrRejectFriendRequest(reciveAccountId: UUID(uuidString: reciveAccountId)!,
                                                  sendAccountId: UUID(uuidString: sendAccountId)!)
        do {
            let _: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                         path: .rejectFriendInvite,
                                                                                         parameters: request,
                                                                                         needToken: true)
           await self.callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        } catch {
            print(error)
           await self.callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        }
    }
    
    // MARK: RefreshInviteRoomMemberList
    
    func callApiRefreshInviteRoomMemberList(inviteRoomId: String) async {
        Thread.sleep(forTimeInterval: 0.5)
        let request = RefreshInviteRoomMemberListRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!)
        
        do {
            let result: GeneralResponse<RefreshInviteRoomMemberListResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                           path: .refreshInviteRoomMemberList,
                                                                                                                           parameters: request,
                                                                                                                           needToken: true)
            if result.message.isEqual(to: "成功更新此房間的成員") {
                inviteMemberList = []
                
                result.data.memberList.forEach{ member in
                    inviteMemberList.append(InviteRoomMember(accountId: member.accountId,
                                                             name: member.name,
                                                             image: member.image))
                }
                tbvInviteRoomMember.reloadData()
            } else if  result.message.contains("找不到房間的Id") {
                Alert.showAlert(title: "房間不存在",
                                message: "請向邀請人確定房間是否開啟",
                                vc: self,
                                confirmTitle: "確認") {
                    WebSocketManager.shared.cancel()
                    self.vInviteRoom.isHidden = true
                    self.inviteMemberList = []
                }
            } else {
                Alert.showAlert(title: "發生錯誤",
                                message: result.message,
                                vc: self,
                                confirmTitle: "確認")
            }
        } catch {
            print(error)
            Alert.showAlert(title: "發生錯誤",
                            message: "請確認與伺服器的連線",
                            vc: self,
                            confirmTitle: "確認")
        }
        
    }
    
    // MARK: FindByInviteRoomIdForConcentrateAndRestTime
    
    func callApiFindByInviteRoomIdForConcentrateAndRestTime(inviteRoomId: String,
                                                            finish: ((GeneralResponse<FindByInviteRoomIdForConcentrateAndRestTimeResponse>) -> Void)? = nil) {
        let request = FindByInviteRoomIdForConcentrateAndRestTimeRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!)
        
        Task {
            do {
                let result: GeneralResponse<FindByInviteRoomIdForConcentrateAndRestTimeResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                                               path: .findByInviteRoomIdForConcentrateAndRestTime,
                                                                                                                                               parameters: request,
                                                                                                                                               needToken: true)
                
                if result.message.isEqual(to: "找到相關紀錄了") {
                    finish?(result)
                } else {
                    Alert.showAlert(title: "錯誤", 
                                    message: result.message,
                                    vc: self,
                                    confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤",
                                message: "\(error)",
                                vc: self,
                                confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - IBAction
    
    @objc func clickCameraMenu() {
        let transformValue = cameraManuView.frame.width
        if cameraMenuStatus == .open {
            UIView.animate(withDuration: 0.1) {
                self.cameraManuView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnFatigueDetection.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnEyeExcrise.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            cameraMenuStatus = .close
        } else {
            UIView.animate(withDuration: 0.1) {
                self.cameraManuView.transform = CGAffineTransform(translationX: 0 - transformValue, y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnFatigueDetection.transform = CGAffineTransform(translationX: 0 - transformValue, y: 0)
            }
            UIView.animate(withDuration: 0.1) {
                self.btnEyeExcrise.transform = CGAffineTransform(translationX: 0 - transformValue, y: 0)
            }
            cameraMenuStatus = .open
        }
    }
    
    @objc func clickFriendNotification() {
        if !SwiftEntryKit.isCurrentlyDisplaying(entryNamed: "Center Note") {
            let addFriendVC = AddFriendViewController()
            var attributes = EKAttributes()
            attributes.name = "Center Note"
            attributes.precedence = .override(priority: .low, dropEnqueuedEntries: false)
            attributes.entryInteraction = .absorbTouches
            attributes.screenInteraction = .dismiss
            attributes.windowLevel = .custom(level: UIWindow.Level.normal)
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3),
                                                                scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black,
                                                    opacity: 0.2,
                                                    radius: 10,
                                                    offset: .zero))
            attributes.statusBar = .dark
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: self.view.frame.width * 0.8),
                                                           height: .intrinsic)
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
        Task {
            await callApiFriendInviteList(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
            await MainActor.run {
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
                tbvFriendInviteList.reloadData()
            }
        }
    }
    
    @objc func showConcentrateInvite(notification: Notification) {
        if let userInfo = notification.userInfo,
           let inviteRoomId = userInfo["inviteRoomId"],
           let sendName = userInfo["sendName"] {
            let concentrateInviteVC = AnserConcentrateInviteViewController()
            concentrateInviteVC.message = "\(sendName) 寄送專注邀請給你，要加入嗎？"
            concentrateInviteVC.inviteRoomId = "\(inviteRoomId)"
            concentrateInviteVC.sendName = "\(sendName)"
            concentrateInviteVC.delegate = self
            
            concentrateInviteVC.modalTransitionStyle = .crossDissolve
            concentrateInviteVC.modalPresentationStyle = .overFullScreen
            concentrateInviteVCs.append(concentrateInviteVC)
        }
        if concentrateInviteVCs.count < 2 {
            pressentConcentrateInviteVC()
        }
    }
    
    func pressentConcentrateInviteVC() {
        guard let vc = concentrateInviteVCs.first else {
            return
        }
        self.present(vc, animated: true)
    }
    
    @objc func changeBellStyle() {
        friendNotificationButtonItem?.image = UIImage(systemIcon: .bellBadgeFill)
        friendNotificationButtonItem?.tintColor = .yellow
    }
    
    @IBAction func clickBtnEyeExercise() {
        let nextVC = EyeExerciseViewController()
        let btn = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btn
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func clickBtnFatigueDetection() {
        let nextVC = FatigueDetectionViewController()
        nextVC.backToMainVCDelegate = self
        let btn = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btn
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func clickAcceptInviteBtn(_ sender: UIButton) {
        let accountId = friendInviteListArray[sender.tag].accountId
        Task {
            await callApiAddFriend(reciveAccountId: UserPreferences.shared.accountId, sendAccountId: accountId)
        }
    }
    
    @objc func clickRejectInviteBtn(_ sender: UIButton) {
        let accountId = friendInviteListArray[sender.tag].accountId
        Task {
            await callApiRejectFriendInvite(reciveAccountId: UserPreferences.shared.accountId, sendAccountId: accountId)
        }
    }
    
    @IBAction func clickLeaveInviteRoomButton() {
        WebSocketManager.shared.cancel()
        vInviteRoom.isHidden = true
        inviteMemberList = []
    }
}

// MARK: - UIPopoverPresentationControllerExtension

extension MainViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return friendInviteListArray.count
        } else {
            return inviteMemberList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendInviteTableViewCell.identifier,
                                                           for: indexPath) as? FriendInviteTableViewCell else {
                fatalError("FriendInviteTableViewCell Load Failed")
            }
            cell.lbName.text = friendInviteListArray[indexPath.row].name
            cell.lbEmail.text = friendInviteListArray[indexPath.row].email
            if friendInviteListArray[indexPath.row].image.isEqual(to: "未設置") {
                cell.igvUserImg.image = UIImage(systemIcon: .personFill)
            } else {
                cell.igvUserImg.image = friendInviteListArray[indexPath.row].image.stringToUIImage()
            }
            cell.btnAccept.tag = indexPath.row
            cell.btnAccept.addTarget(self, action: #selector(clickAcceptInviteBtn), for: .touchUpInside)
            cell.btnReject.tag = indexPath.row
            cell.btnReject.addTarget(self, action: #selector(clickRejectInviteBtn), for: .touchUpInside)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteRoomMemberListTableViewCell.identifier,
                                                           for: indexPath) as? InviteRoomMemberListTableViewCell else {
                fatalError("InviteRoomMemberListTableViewCell Load Failed")
            }
            if inviteMemberList[indexPath.row].image.isEqual(to: "未設置") {
                cell.imgvUser.image = UIImage(systemIcon: .personFill)
            } else {
                cell.imgvUser.image = inviteMemberList[indexPath.row].image.stringToUIImage()
            }
            cell.name.text = inviteMemberList[indexPath.row].name
            return cell
        }
    }
}

// MARK: - InviteDelegate

extension MainViewController: InviteDelegate {
    
    func accept() {
        WebSocketManager.shared.cancel()
        print("Accept")
        inviteRoomId = concentrateInviteVCs[0].inviteRoomId
        concentrateInviteVCs[0].dismiss(animated: true)
        
        NotificationCenter.default.post(name: .dismissAddInviteView, object: nil)
        vInviteRoom.isHidden = false
        lbInviteRoomName.text = "\(concentrateInviteVCs[0].sendName) 的房間"
        Task {
            getInInviteRoom(path: .wsInviteRoom,
                            parameters: "\(inviteRoomId)&Member:\(UserPreferences.shared.accountId)")
            await callApiRefreshInviteRoomMemberList(inviteRoomId: inviteRoomId)
        }
        concentrateInviteVCs.removeAll()
    }
    
    func cancel() {
        print("Cancel")
        concentrateInviteVCs[0].dismiss(animated: true)
        concentrateInviteVCs.remove(at: 0)
        if !concentrateInviteVCs.isEmpty {
            pressentConcentrateInviteVC()
        }
    }
}

// MARK: - WebSocketManagerDelegate

extension MainViewController: WebSocketManagerDelegate {
    
    func webSocket(_ webSocketManager: WebSocketManager,
                   _ session: URLSession,
                   webSocketTask: URLSessionWebSocketTask,
                   didOpenWithProtocol protocol: String?) async {
        isInviteRoomConnect = true
        print("URLSessionWebSocketTask is connected")
        await WebSocketManager.shared.receive()
    }
    
    func webSocket(_ webSocketManager: WebSocketManager,
                   _ session: URLSession,
                   webSocketTask: URLSessionWebSocketTask,
                   didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                   reason: Data?) {
        isInviteRoomConnect = false
        if let reason = reason,
           let string = String(data: reason, encoding: .utf8) {
            print(string)
        } else {
            print("error")
        }
    }
    
    func webSocket(_ webSocketManager: WebSocketManager, didReceive message: String) {
        if message.contains("房主") && message.contains("離開了") {
            Alert.showAlert(title: "房主已離開房間",
                            message: "房間已關閉",
                            vc: self,
                            confirmTitle: "確認") {
                self.vInviteRoom.isHidden = true
                WebSocketManager.shared.cancel()
                self.inviteMemberList = []
                self.tbvInviteRoomMember.reloadData()
            }
        } else if message.contains("進入專注模式") {
            self.vInviteRoom.isHidden = true
            WebSocketManager.shared.cancel()
            // 寫一個閉包打 API 獲取專注時間和休息時間，並在閉包裡做跳頁並帶值的事情
            callApiFindByInviteRoomIdForConcentrateAndRestTime(inviteRoomId: inviteRoomId) { result in
                let nextVC = MutipleConcentrateMemberVersionViewController()
                nextVC.inviteRoomId = self.inviteRoomId
                nextVC.inviteMemberList = self.inviteMemberList
                nextVC.concentrateTime = "\(result.data.concentrateTime):00"
                nextVC.restTime = String(result.data.restTime.prefix(2))
                self.inviteMemberList = []
                
                nextVC.isModalInPresentation = true
                self.present(nextVC, animated: true)
            }
        } else {
            Task {
                await callApiRefreshInviteRoomMemberList(inviteRoomId: inviteRoomId)
            }
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.isoValue = self.frontCamera?.iso ?? 0
            print(self.isoValue)
            if self.isoValue > 750 {
                Alert.showAlert(title: "警示",
                                message: "環境亮度低，即將自動啟用檯燈",
                                vc: self,
                                confirmTitle: "確認",
                                cancelTitle: "取消") {
                    UserPreferences.shared.isoLowValue = true
                    EquipmentViewController().isoValue(vc: self)
                } cancel: {
                    UserPreferences.shared.isoLowValue = false
                }
            }
        }
    }
}

// MARK: - FatigueDetectionBackToMainVCDelegate

extension MainViewController: FatigueDetectionBackToMainVCDelegate {
    
    func startCatchISO() {
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
}
