//
//  ConcentrateViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import FlexibleSteppedProgressBar
import ProgressHUD
import SwiftHelpers
import UIKit

class ConcentrateViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var concentrateView: UIImageView!
    @IBOutlet weak var concentrateShadowView: UIView!
    @IBOutlet weak var missionBackgroundView: UIView!
    @IBOutlet weak var lbEveryDayMission: UILabel!
    @IBOutlet weak var missionTableView: UITableView!
    @IBOutlet weak var vConcentrateTime: UIView!
    @IBOutlet weak var btnConcentrateTimeConfirm: UIButton!
    @IBOutlet weak var btnConcentrateTimeCancel: UIButton!
    @IBOutlet weak var pkvConcentrateTime: UIPickerView!
    @IBOutlet weak var btnConcentrateTime: UIButton!
    @IBOutlet weak var pkvRestTime: UIPickerView!
    @IBOutlet weak var btnRestConfirm: UIButton!
    @IBOutlet weak var btnRestCancel: UIButton!
    @IBOutlet weak var btnRestTime: UIButton!
    @IBOutlet weak var vRestTime: UIView!
    @IBOutlet weak var vAddInvite: UIView!
    @IBOutlet weak var tbvFriendList: UITableView!
    @IBOutlet weak var tbvInviteRoomList: UITableView!
    @IBOutlet weak var btnStartConcentrate: UIButton!
    @IBOutlet weak var btnCancelConcentrate: UIButton!
    @IBOutlet weak var btnAddInvite: UIButton!
    @IBOutlet weak var vInviteRoomSelect: UIView!
    @IBOutlet weak var scvInviteRoomSelect: UIScrollView!
    
    // MARK: - Properties
    
    private let formatter = Formatter()
    
    var progressBar: FlexibleSteppedProgressBar!
    var missionList: [MissionList] = []
    let hourArray = [Int](0...2)
    let minArray = [Int](0 ... 59)
    var contrateTimeHour = "00"
    var contrateTimeMin = "50"
    var restTimeMin = "10"
    var inviteRoomId = ""
    var isInviteRoomConnect = false
    var concentrateTimeCount = 0
    private var friendListArray: [InviteFriendListInfo] = []
    private var inviteMemberList: [InviteRoomMember] = []
    
    private struct InviteFriendListInfo {
        var accountId: String
        var name: String
        var image: String
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotificationCenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ConcentrateViewController")
        reloadMissionStatus()
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
        setupConcentrateView()
        setupProgress()
        setupMissionTableView()
        setupConcentrateTimePicker()
        setupConcentrateTimeView()
        setupRestTimePicker()
        setupRestTimeView()
        setupAddInviteView()
        setupInviteSelectView()
        setupFriendListTableView()
        setupInviteRoomListTableView()
    }
    
    func setupProgress() {
        progressBar = FlexibleSteppedProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        missionBackgroundView.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: missionBackgroundView.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: lbEveryDayMission.bottomAnchor, constant: 0),
            progressBar.widthAnchor.constraint(equalTo: missionBackgroundView.widthAnchor, multiplier: 0.8),
            progressBar.heightAnchor.constraint(equalTo: missionBackgroundView.heightAnchor, multiplier: 0.05)
        ])
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 6
        progressBar.lineHeight = 9
        progressBar.radius = 15
        progressBar.progressRadius = 25
        progressBar.progressLineHeight = 3
        progressBar.selectedBackgoundColor = .buttom2Color!
        progressBar.currentSelectedCenterColor = .clear
        progressBar.selectedOuterCircleStrokeColor = .buttom2Color!
        progressBar.delegate = self
    }
    
    func setupConcentrateView() {
        concentrateView.layer.cornerRadius = 10
        concentrateShadowView.layer.shadowOffset = CGSize(width: 10, height: 10)
        concentrateShadowView.layer.shadowOpacity = 0.9
        concentrateShadowView.layer.shadowRadius = 20
        concentrateShadowView.layer.shadowColor = UIColor.systemGreen.cgColor
        missionBackgroundView.layer.cornerRadius = 10
        missionBackgroundView.layer.shadowOffset = CGSize(width: 10, height: 10)
        missionBackgroundView.layer.shadowOpacity = 0.2
        missionBackgroundView.layer.shadowRadius = 20
    }
    
    func setupMissionTableView() {
        missionTableView.register(UINib(nibName: "MissionTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: MissionTableViewCell.identifier)
        missionTableView.tag = 0
        missionTableView.dataSource = self
        missionTableView.delegate = self
    }
    
    func setupConcentrateTimePicker() {
        pkvConcentrateTime.delegate = self
        pkvConcentrateTime.dataSource = self
        pkvConcentrateTime.selectRow(0, inComponent: 0, animated: true)
        pkvConcentrateTime.selectRow(50, inComponent: 2, animated: true)
        pkvConcentrateTime.tag = 0
    }
    
    func setupRestTimePicker() {
        pkvRestTime.delegate = self
        pkvRestTime.dataSource = self
        pkvRestTime.selectRow(10, inComponent: 0, animated: true)
        pkvRestTime.tag = 1
    }
    
    func setupConcentrateTimeView() {
        vConcentrateTime.layer.cornerRadius = 20
        vConcentrateTime.layer.shadowOffset = CGSize(width: 0, height: 5)
        vConcentrateTime.layer.shadowRadius = 10
        vConcentrateTime.layer.shadowOpacity = 0.4
        
        btnConcentrateTimeCancel.layer.cornerRadius = 20
        btnConcentrateTimeConfirm.layer.cornerRadius = 20
    }
    
    func setupRestTimeView() {
        vRestTime.layer.cornerRadius = 20
        vRestTime.layer.shadowOffset = CGSize(width: 0, height: 5)
        vRestTime.layer.shadowRadius = 10
        vRestTime.layer.shadowOpacity = 0.4
        
        btnRestCancel.layer.cornerRadius = 20
        btnRestConfirm.layer.cornerRadius = 20
    }
    
    func setupAddInviteView() {
        vAddInvite.layer.cornerRadius = 20
        vAddInvite.layer.shadowOffset = CGSize(width: 0, height: 5)
        vAddInvite.layer.shadowRadius = 10
        vAddInvite.layer.shadowOpacity = 0.4
        
        btnStartConcentrate.layer.cornerRadius = 20
        btnCancelConcentrate.layer.cornerRadius = 20
    }
    
    func setupInviteSelectView() {
        vInviteRoomSelect.layer.cornerRadius = 20
        vInviteRoomSelect.layer.shadowOffset = CGSize(width: 0, height: 5)
        vInviteRoomSelect.layer.shadowOpacity = 0.2
        vInviteRoomSelect.layer.shadowRadius = 10
        vInviteRoomSelect.backgroundColor = .white
        scvInviteRoomSelect.delegate = self
    }
    
    func setupFriendListTableView() {
        tbvFriendList.tag = 2
        tbvFriendList.register(UINib(nibName: "InviteFriendsTableViewCell", bundle: nil),
                               forCellReuseIdentifier: InviteFriendsTableViewCell.identifier)
        tbvFriendList.delegate = self
        tbvFriendList.dataSource = self
    }
    
    func setupInviteRoomListTableView() {
        tbvInviteRoomList.tag = 1
        tbvInviteRoomList.register(UINib(nibName: "InviteRoomListTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: InviteRoomListTableViewCell.identified)
        tbvInviteRoomList.delegate = self
        tbvInviteRoomList.dataSource = self
    }
    
    // MARK: - Function
    
    fileprivate func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissAddInviteView),
                                               name: .dismissAddInviteView,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadMissionStatus),
                                               name: .reloadMissionStatus,
                                               object: nil)
    }
    
    @objc func reloadMissionStatus() {
        let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd")
        Task {
            await callApiGetMissionList()
            do {
                try await callFindTodayMissionCompleteApi(date: now)
                var countProgress = 0
                missionList.forEach { mission in
                    if mission.status {
                        countProgress += 1
                    }
                }
                progressBar.currentIndex = countProgress
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤",
                                message: "\(error)",
                                vc: self,
                                confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - WSAction
    
    func sendWSMessage(message: String) {
        Task {
            do {
                try await WebSocketManager.shared.send(message: message)
            } catch {
                Alert.showAlert(title: "進入專注模式錯誤",
                                message: "\(error)",
                                vc: self,
                                confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPIGetMissionList
    
    func callApiGetMissionList() async {
        let request = GetMissionListRequest()
        do {
            let result: GeneralResponse<[GetMissionListResponse]> = try await NetworkManager.shared.requestData(method: .get,
                                                                                                                path: .getMissionList,
                                                                                                                parameters: request,
                                                                                                                needToken: true)
            missionList = []
            result.data.forEach { mission in
                let missionListItem = MissionList(missionID: mission.missionID,
                                                  title: mission.title,
                                                  progress: mission.progress,
                                                  progressType: mission.progressType,
                                                  status: false)
                missionList.append(missionListItem)
                switch mission.title {
                case "使用專注模式":
                    UserPreferences.shared.concentrateMissionId = mission.missionID.uuidString
                case "使用眼睛保健操":
                    UserPreferences.shared.eyeExerciseMissionId = mission.missionID.uuidString
                case "在光線充足的地方使用專注模式":
                    UserPreferences.shared.lightEnvironmentConcentrateMissionId = mission.missionID.uuidString
                case "使用藍光檢測器，並低於限制值":
                    UserPreferences.shared.blueLightMissionId = mission.missionID.uuidString
                case "使用睡意檢測":
                    UserPreferences.shared.fatigueMissionId = mission.missionID.uuidString
                default:
                    return
                }
            }
            await MainActor.run {
                missionTableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    
    @objc func dismissAddInviteView() {
        vAddInvite.isHidden = true
        WebSocketManager.shared.cancel()
        isInviteRoomConnect = false
    }
    
    @objc func clickAddFriendToConcentrateRoom(_ sender: UIButton) {
        callAddFriendToInviteRoomApi(inviteRoomId: inviteRoomId,
                                     reciveAccountId: friendListArray[sender.tag].accountId)
    }
    
    // MARK: - callFindTodayMissionCompleteAPI
    
    func callFindTodayMissionCompleteApi(date: String) async throws {
        let accountId = UserPreferences.shared.accountId
        let request = FindTodayMissionCompleteRequest(accountId: UUID(uuidString: accountId)!, date: date)
        do {
            let result: GeneralResponse<FindTodayMissionCompleteResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                        path: .findTodayMissionComplete,
                                                                                                                        parameters: request,
                                                                                                                        needToken: true)
            if result.result.isEqual(to: 0) {
                concentrateTimeCount = result.data.concentrateTime
                result.data.missionId.forEach { completeMissionId in
                    for i in 0 ..< missionList.count {
                        if missionList[i].missionID.isEqual(to: completeMissionId)  {
                            missionList[i].status = true
                        }
                    }
                }
            }
            await MainActor.run {
                missionTableView.reloadData()
            }
        } catch {
            print(error)
            Alert.showAlert(title: "錯誤",
                            message: "\(error)",
                            vc: self,
                            confirmTitle: "確認")
        }
    }
    
    // MARK: - callWebSocketCreateInviteRoom
    
    func createInviteRoom(path: ApiPathConstants, parameters: String, needToken: Bool) {
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connect(path: path,
                                        parameters: parameters,
                                        sessionDescription: "InviteRoom")
    }
    
    // MARK: - callAddConcentrateRecordAPI
    
    func callAddConcentrateRecordApi(accountId: String,
                                     hostAccountId: String,
                                     startTime: String,
                                     concentrateTime: String,
                                     restTime: String,
                                     friends: [UUID]) async {
        let request = AddConcentrateRecordRequest(accountId: UUID(uuidString: accountId)!,
                                                  hostAccountId: UUID(uuidString: hostAccountId)!,
                                                  startTime: startTime,
                                                  concentrateTime: concentrateTime,
                                                  restTime: restTime,
                                                  withFriends: friends)
        
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addConcentrateRecord,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                
                if result.message != "已新增紀錄" {
                    Alert.showAlert(title: "未新增紀錄",
                                    message: "請確定是否有和伺服器連接",
                                    vc: self,
                                    confirmTitle: "確認") {
                        let nextVC = StartConcentrateViewController()
                        nextVC.wifiIsConnect = false
                        nextVC.concentrateTime = "\((self.btnConcentrateTime?.titleLabel?.text!)!):00"
                        nextVC.restTime = String((self.btnRestTime?.titleLabel?.text!.prefix(2))!)
                        nextVC.isModalInPresentation = true
                        self.present(nextVC, animated: true)
                    }
                } else {
                    let nextVC = StartConcentrateViewController()
                    nextVC.concentrateRecordId = result.data
                    nextVC.wifiIsConnect = true
                    nextVC.concentrateTime = "\((self.btnConcentrateTime?.titleLabel?.text!)!):00"
                    nextVC.restTime = String((btnRestTime?.titleLabel?.text!.prefix(2))!)
                    nextVC.isModalInPresentation = true
                    present(nextVC, animated: true)
                }
            } catch {
                print(error)
                Alert.showAlert(title: "未新增紀錄",
                                message: "請確定是否有和伺服器連接",
                                vc: self,
                                confirmTitle: "確認") {
                    let nextVC = StartConcentrateViewController()
                    nextVC.wifiIsConnect = false
                    nextVC.concentrateTime = "\((self.btnConcentrateTime?.titleLabel?.text!)!):00"
                    nextVC.restTime = String((self.btnRestTime?.titleLabel?.text!.prefix(2))!)
                    nextVC.isModalInPresentation = true
                    self.present(nextVC, animated: true)
                }
            }
    }
    
    // MARK: - callAPIFriendList
    
    func callApiFriendList(accountId: String) {
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        Task {
            let request = GetFriendListRequest(accountId: UUID(uuidString: accountId)!)
            
            do {
                let result: GetFriendListResponse = try await NetworkManager.shared.requestData(method: .post,
                                                                                                path: .getFriendList,
                                                                                                parameters: request,
                                                                                                needToken: true)
                friendListArray = []
                result.data.forEach { friendInfo in
                    if friendInfo.image.isEqual(to: "未設置")  {
                        friendListArray.append(InviteFriendListInfo(accountId: friendInfo.accountId,
                                                                    name: friendInfo.name,
                                                                    image: friendInfo.image))
                    } else {
                        friendListArray.append(InviteFriendListInfo(accountId: friendInfo.accountId,
                                                                    name: friendInfo.name,
                                                                    image: friendInfo.image))
                    }
                }
                tbvFriendList!.reloadData()
                print(friendListArray.count)
            } catch {
                print(error)
            }
            ProgressHUD.dismiss()
        }
    }
    
    // MARK: - callAPICreateInviteRoom
    
    func callApiCreateInviteRoom(sendAccountId: String) {
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        
        Task {
            let request = CreateInviteRoomRequest(sendAccountId: UUID(uuidString: sendAccountId)!)
            
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .createInviteRoom,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                
                if result.message.isEqual(to: "建立成功") {
                    inviteRoomId = result.data
                    self.createInviteRoom(path: .wsInviteRoom,
                                          parameters: "\(result.data)&HostAT:\(UserPreferences.shared.accountId)",
                                          needToken: true)
                } else {
                    Alert.showAlert(title: "建立失敗",
                                    message: "請確認與伺服器的連線",
                                    vc: self,
                                    confirmTitle: "確認")
                }
                
            } catch {
                print(error)
                Alert.showAlert(title: "建立失敗",
                                message: "請確認與伺服器的連線",
                                vc: self,
                                confirmTitle: "確認")
            }
            ProgressHUD.dismiss()
        }
    }
    
    // MARK: - callAddFriendToConcentrate
    
    func callAddFriendToInviteRoomApi(inviteRoomId: String, reciveAccountId: String) {
        let request = AddFriendToInviteRoomRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                   reciveAccountId: UUID(uuidString: reciveAccountId)!)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addFriendToInviteRoom,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "好友已經在你的房間")  {
                    Alert.showToastWith(message: "好友已經在你的房間",
                                        vc: self,
                                        during: .short)
                } else if result.message.isEqual(to: "已邀請") {
                    
                } else {
                    Alert.showAlert(title: "邀請失敗",
                                    message: "請確認與伺服器的連線",
                                    vc: self,
                                    confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "邀請失敗",
                                message: "請確認與伺服器的連線",
                                vc: self,
                                confirmTitle: "確認")
            }
            
        }
    }
    
    // MARK: - callAPIAddToInviteRoom
    
    func callApiAddToInviteRoom(reciveAccountId: String, inviteRoomId: String) {
        let request = AddToInviteRoomRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                             reciveAccountId: UUID(uuidString: reciveAccountId)!)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addToInviteRoom,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.contains("已加入房間") {
                    await callApiRefreshInviteRoomMemberList(inviteRoomId: inviteRoomId)
                    
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
    }
    
    // MARK: - callAPIRemoveToInviteRoom
    
    func callApiRemoveToInviteRoom(removeAccountId: String, inviteRoomId: String) {
        let request = RemoveToInviteRoomRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                removeAccountId: UUID(uuidString: removeAccountId)!)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .removeToInviteRoom,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.contains("已離開房間") {
                    await callApiRefreshInviteRoomMemberList(inviteRoomId: inviteRoomId)
                    
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
    }
    
    // MARK: - callAPIRefreshInviteRoomMemberList
    
    func callApiRefreshInviteRoomMemberList(inviteRoomId: String) async {
        let request = RefreshInviteRoomMemberListRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!)
        
        do {
            let result: GeneralResponse<RefreshInviteRoomMemberListResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                           path: .refreshInviteRoomMemberList,
                                                                                                                           parameters: request,
                                                                                                                           needToken: true)
            if result.message == "成功更新此房間的成員" {
                inviteMemberList = []
                
                result.data.memberList.forEach { member in
                    inviteMemberList.append(InviteRoomMember(accountId: member.accountId,
                                                             name: member.name,
                                                             image: member.image))
                }
                tbvInviteRoomList?.reloadData()
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
    
    // MARK: - callAPIRemoveInviteRoom
    
    func callApiRemoveInviteRoom(inviteRoomId: String) async {
        let request = RemoveInviteRoomRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!)
        
        do {
            let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                              path: .removeInviteRoom,
                                                                                              parameters: request,
                                                                                              needToken: true)
            if !result.message.contains("刪除成功") {
                Alert.showAlert(title: "關閉邀請房間失敗",
                                message: result.message,
                                vc: self,
                                confirmTitle: "確認")
            }
        } catch {
            print(error)
            Alert.showAlert(title: "關閉邀請房間失敗",
                            message: "\(error)",
                            vc: self,
                            confirmTitle: "確認")
        }
    }
    
    // MARK: - callAPIStartMutipleConcentrate
    
    func callApiStartMutipleConcentrate(inviteRoomId: String,
                                        startTime: String,
                                        concentrateTime: String,
                                        restTime: String,
                                        finish: (() -> Void)? = nil) {
        let request = StartMutipleConcentrateRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                     startTime: startTime,
                                                     concentrateTime: concentrateTime,
                                                     restTime: restTime)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .startMutipleConcentrate,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message != "進入專注模式成功" {
                    Alert.showAlert(title: "錯誤",
                                    message: result.message,
                                    vc: self,
                                    confirmTitle: "確認")
                } else {
                    finish?()
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
    
    @IBAction func showConcentrateTimeView() {
        if vConcentrateTime.isHidden == true {
            UIView.transition(with: vConcentrateTime,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vConcentrateTime.isHidden = false
                Alert.showAlert(title: "建議專注及休息時間",
                                message: "若您使用 3C 產品進行工作，每40-50分鐘，應休息10-15分鐘",
                                vc: self,
                                confirmTitle: "確認")
            }
        } else {
            UIView.transition(with: vConcentrateTime,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vConcentrateTime.isHidden = true
            }
        }
    }
    
    @IBAction func showRestTimeView() {
        if vRestTime.isHidden == true {
            UIView.transition(with: vRestTime,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vRestTime.isHidden = false
            }
        } else {
            UIView.transition(with: vRestTime,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vRestTime.isHidden = true
            }
        }
    }
    
    @IBAction func clickConcentrateTimeCancelButton() {
        guard let concentrateTime = btnConcentrateTime.titleLabel?.text else {
            return
        }
        let defaultMin = Int(concentrateTime.suffix(2)) ?? 0
        let defaultHour = Int(concentrateTime.prefix(2)) ?? 0
        pkvConcentrateTime.selectRow(defaultMin, inComponent: 2, animated: true)
        pkvConcentrateTime.selectRow(defaultHour, inComponent: 0, animated: true)
        showConcentrateTimeView()
    }
    
    @IBAction func clickConcentrateTimeConfirmButton() {
        btnConcentrateTime.setTitle("\(contrateTimeHour):\(contrateTimeMin)", for: .normal)
        showConcentrateTimeView()
    }
    
    @IBAction func clickRestTimeCancelButton() {
        guard let restTime = btnRestTime.titleLabel?.text else {
            return
        }
        let defaultMin = Int(restTime.prefix(2)) ?? 0
        pkvRestTime.selectRow(defaultMin, inComponent: 0, animated: true)
        showRestTimeView()
    }
    
    @IBAction func clickRestTimeConfirmButton() {
        btnRestTime.setTitle("\(restTimeMin) min", for: .normal)
        showRestTimeView()
    }
    
    @IBAction func startConcentrate() {
        guard let concentrateTime = btnConcentrateTime.titleLabel?.text else {
            return
        }
        Task {
            let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
            await callAddConcentrateRecordApi(accountId: UserPreferences.shared.accountId,
                                        hostAccountId: UserPreferences.shared.accountId,
                                        startTime: now,
                                        concentrateTime: concentrateTime,
                                        restTime: "\(restTimeMin) m",
                                        friends: [])
        }
    }
    
    @IBAction func clickCreateInviteRoom() {
        if vAddInvite.isHidden == true {
            callApiCreateInviteRoom(sendAccountId: UserPreferences.shared.accountId)
            callApiFriendList(accountId: UserPreferences.shared.accountId)
            vAddInvite.isHidden = false
            inviteMemberList = []
        } else {
            vAddInvite.isHidden = true
            WebSocketManager.shared.cancel(with: .goingAway, reason: nil)
            isInviteRoomConnect = false
        }
    }
    
    @IBAction func clickCloseInviteRoom() {
        vAddInvite.isHidden = true
        if isInviteRoomConnect {
            WebSocketManager.shared.cancel(with: .goingAway, reason: nil)
            isInviteRoomConnect = false
            inviteMemberList = []
            tbvInviteRoomList.reloadData()
        }
        Task {
            await callApiRemoveInviteRoom(inviteRoomId: inviteRoomId)
        }
    }
    
    @IBAction func clickRoomSelectButton() {
        scvInviteRoomSelect.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.2) { [self] in
            vInviteRoomSelect.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @IBAction func clickFriendListSelectButton() {
        scvInviteRoomSelect?.setContentOffset(CGPoint(x: (scvInviteRoomSelect?.frame.width)!, y: 0), animated: true)
        UIView.animate(withDuration: 0.2) { [self] in
            vInviteRoomSelect.transform = CGAffineTransform(translationX: vInviteRoomSelect.frame.width, y: 0)
        }
    }
    
    @IBAction func clickMultipleConcentrateButton() {
        guard let concentrateTime = btnConcentrateTime.titleLabel?.text else {
            return
        }
        let now = formatter.convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
        callApiStartMutipleConcentrate(inviteRoomId: inviteRoomId,
                                       startTime: now,
                                       concentrateTime: concentrateTime,
                                       restTime: "\(restTimeMin) m") {
            self.sendWSMessage(message: "\(self.inviteRoomId) 進入專注模式")
            let nextVC = MutipleStartConcentrateViewController()
            nextVC.concentrateTime = "\((self.btnConcentrateTime?.titleLabel?.text!)!):00"
            nextVC.restTime = String((self.btnRestTime?.titleLabel?.text!.prefix(2))!)
            nextVC.inviteRoomId = self.inviteRoomId
            nextVC.inviteMemberList = self.inviteMemberList
            self.inviteMemberList = []
            self.tbvInviteRoomList?.reloadData()
            self.vAddInvite?.isHidden = true
            nextVC.isModalInPresentation = true
            self.present(nextVC, animated: true)
            WebSocketManager.shared.cancel()
        }
    }
}

// MARK: - FlexibleSteppedProgressBarDelegate

extension ConcentrateViewController: FlexibleSteppedProgressBarDelegate {
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     willSelectItemAtIndex index: Int) {
        print("Index selected!")
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return false
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int,
                     position: FlexibleSteppedProgressBarTextLocation) -> String {
        return ""
    }
}

// MARK: - UITableViewDelegate、UITableViewDataSource

extension ConcentrateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return missionList.count
        case 1:
            return inviteMemberList.count
        default:
            return friendListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView.tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MissionTableViewCell.identifier,
                                                           for: indexPath) as? MissionTableViewCell else {
                fatalError("MissionTableViewCell Load Failed")
            }
            cell.lbTitle.text = missionList[indexPath.row].title
            if missionList[indexPath.row].status {
                cell.lbProgress.isHidden = true
                cell.imgvCheck.isHidden = false
            } else {
                cell.lbProgress.isHidden = false
                cell.imgvCheck.isHidden = true
                if missionList[indexPath.row].progressType.isEqual(to: "分鐘")  {
                    cell.lbProgress.text = "\(concentrateTimeCount) / \(missionList[indexPath.row].progress) \(missionList[indexPath.row].progressType)"
                } else {
                    cell.lbProgress.text = "\(missionList[indexPath.row].progress) \(missionList[indexPath.row].progressType)"
                }
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteRoomListTableViewCell.identified,
                                                           for: indexPath) as? InviteRoomListTableViewCell else {
                fatalError("InviteRoomListTableViewCell Load Failed")
            }
            if inviteMemberList[indexPath.row].image.isEqual(to: "未設置") {
                cell.imgvUser?.image = UIImage(systemIcon: .personFill)
            } else {
                cell.imgvUser?.image = inviteMemberList[indexPath.row].image.stringToUIImage()
            }
            cell.name?.text = inviteMemberList[indexPath.row].name
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendsTableViewCell.identifier,
                                                           for: indexPath) as? InviteFriendsTableViewCell else {
                fatalError("InviteFriendsTableViewCell Load Failed")
            }
            cell.btnAddInvite?.tag = indexPath.row
            cell.btnAddInvite?.addTarget(self, action: #selector(clickAddFriendToConcentrateRoom), for: .touchUpInside)
            if friendListArray[indexPath.row].image.isEqual(to: "未設置")  {
                cell.imgvUser?.image = UIImage(systemName: "person.fill")
            } else {
                cell.imgvUser?.image = friendListArray[indexPath.row].image.stringToUIImage()
            }
            cell.lbName?.text = friendListArray[indexPath.row].name
            return cell
        }
    }
}

// MARK: - PickerViewDelegate

extension ConcentrateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView,
                    attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        
        if pickerView.tag.isEqual(to: 0) {
            switch component {
            case 0:
                if hourArray[row] > 9 {
                    return NSAttributedString(string: "\(hourArray[row])", attributes: [
                        .foregroundColor : UIColor.black
                    ])
                } else {
                    return NSAttributedString(string: "0\(hourArray[row])", attributes: [
                        .foregroundColor : UIColor.black
                    ])
                }
            case 1:
                return NSAttributedString(string: "h", attributes: [
                    .foregroundColor : UIColor.black
                ])
            case 2:
                if minArray[row] > 9 {
                    return NSAttributedString(string: "\(minArray[row])", attributes: [
                        .foregroundColor : UIColor.black
                    ])
                } else {
                    return NSAttributedString(string: "0\(minArray[row])", attributes: [
                        .foregroundColor : UIColor.black
                    ])
                }
            default:
                return NSAttributedString(string: "min", attributes: [
                    .foregroundColor: UIColor.black
                ])
            }
        } else {
            if component.isEqual(to: 0) {
                if minArray[row] > 9 {
                    return NSAttributedString(string: "\(minArray[row])", attributes: [
                        .foregroundColor : UIColor.black
                    ])
                } else {
                    return NSAttributedString(string: "0\(minArray[row])", attributes: [
                        .foregroundColor: UIColor.black
                    ])
                }
            } else {
                return NSAttributedString(string: "min", attributes: [
                    .foregroundColor: UIColor.black
                ])
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag.isEqual(to: 0) {
            return 4
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag.isEqual(to: 0) {
            switch component {
            case 0:
                return hourArray.count
            case 1:
                return 1
            case 2:
                return minArray.count
            default:
                return 1
            }
        } else {
            switch component {
            case 0:
                return minArray.count
            default:
                return 1
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag.isEqual(to: 0) {
            if component.isEqual(to: 0) {
                if hourArray[row] > 9 {
                    contrateTimeHour = ("\(hourArray[row])")
                } else {
                    contrateTimeHour = ("0\(hourArray[row])")
                }
            } else {
                if minArray[row] > 9 {
                    contrateTimeMin = ("\(minArray[row])")
                } else {
                    contrateTimeMin = ("0\(minArray[row])")
                }
            }
        } else {
            if component.isEqual(to: 0) {
                if minArray[row] > 9 {
                    restTimeMin = ("\(minArray[row])")
                } else {
                    restTimeMin = ("0\(minArray[row])")
                }
            }
        }
    }
}

// MARK: - WebSocketManagerDelegate

extension ConcentrateViewController: WebSocketManagerDelegate {
    
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
        if message.contains("離開了") {
            callApiRemoveToInviteRoom(removeAccountId: String(message.prefix(36)),
                                      inviteRoomId: inviteRoomId)
        } else {
            callApiAddToInviteRoom(reciveAccountId: String(message.prefix(36)),
                                   inviteRoomId: inviteRoomId)
        }
    }
}

// MARK: - Extensions



// MARK: - Protocol


