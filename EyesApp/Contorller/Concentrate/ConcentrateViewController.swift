//
//  ConcentrateViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import FlexibleSteppedProgressBar
import ProgressHUD

class ConcentrateViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var concentrateView: UIImageView?
    @IBOutlet weak var concentrateShadowView: UIView?
    @IBOutlet weak var missionBackgroundView: UIView?
    @IBOutlet weak var lbEveryDayMission: UILabel?
    @IBOutlet weak var missionTableView: UITableView?
    @IBOutlet weak var vConcentrateTime: UIView?
    @IBOutlet weak var btnConcentrateTimeConfirm: UIButton?
    @IBOutlet weak var btnConcentrateTimeCancel: UIButton?
    @IBOutlet weak var pkvConcentrateTime: UIPickerView?
    @IBOutlet weak var btnConcentrateTime: UIButton?
    @IBOutlet weak var pkvRestTime: UIPickerView?
    @IBOutlet weak var btnRestConfirm: UIButton?
    @IBOutlet weak var btnRestCancel: UIButton?
    @IBOutlet weak var btnRestTime: UIButton?
    @IBOutlet weak var vRestTime: UIView?
    @IBOutlet weak var vAddInvite: UIView?
    @IBOutlet weak var tbvFriendList: UITableView?
    @IBOutlet weak var tbvInviteRoomList: UITableView?
    @IBOutlet weak var btnStartConcentrate: UIButton?
    @IBOutlet weak var btnCancelConcentrate: UIButton?
    @IBOutlet weak var btnAddInvite: UIButton?
    @IBOutlet weak var vInviteRoomSelect: UIView?
    @IBOutlet weak var scvInviteRoomSelect: UIScrollView?
    
    // MARK: - Variables
    var progressBar: FlexibleSteppedProgressBar!
    let manager = NetworkManager()
    var missionList: [MissionList] = []
    let hourArray = [Int](0...2)
    let minArray = [Int](0 ... 59)
    var contrateTimeHour = "00"
    var contrateTimeMin = "50"
    var restTimeMin = "10"
    var wsInviteRoom: URLSessionWebSocketTask? = nil
    var inviteRoomId = ""
    var isInviteRoomConnect = false
    var concentrateTimeCount = 0
    private var friendListArray: [inviteFriendListInfo] = []
    private var inviteMemberList: [InviteRoomMember] = []
    
    private struct inviteFriendListInfo {
        var accountId: String
        var name: String
        var image: String
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dismissAddInviteView),
                                               name: .dismissAddInviteView, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadMissionStatus),
                                               name: .reloadMissionStatus,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ConcentrateViewController")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
        callApiGetMissionList {
            self.callFindTodayMissionCompleteApi(accountId: UserPreferences.shared.accountId,
                                                 date: now) {
                var countProgress = 0
                self.missionList.forEach { mission in
                    if mission.status == true {
                        countProgress += 1
                    }
                }
                self.progressBar.currentIndex = countProgress
            }
        }
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
        missionBackgroundView?.addSubview(progressBar)
        
        let horizontalConstraint = progressBar.centerXAnchor.constraint(equalTo: missionBackgroundView!.centerXAnchor)
        let verticalConstraint = progressBar.topAnchor.constraint(
            equalTo: lbEveryDayMission!.bottomAnchor,
            constant: 0
        )
        let widthConstraint = progressBar.widthAnchor.constraint(equalTo: missionBackgroundView!.widthAnchor, multiplier: 0.8)
        let heightConstraint = progressBar.heightAnchor.constraint(equalTo: missionBackgroundView!.heightAnchor, multiplier: 0.05)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
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
        concentrateView?.layer.cornerRadius = 10
        concentrateShadowView?.layer.shadowOffset = CGSize(width: 10, height: 10)
        concentrateShadowView?.layer.shadowOpacity = 0.9
        concentrateShadowView?.layer.shadowRadius = 20
        concentrateShadowView?.layer.shadowColor = UIColor.systemGreen.cgColor
        missionBackgroundView?.layer.cornerRadius = 10
        missionBackgroundView?.layer.shadowOffset = CGSize(width: 10, height: 10)
        missionBackgroundView?.layer.shadowOpacity = 0.2
        missionBackgroundView?.layer.shadowRadius = 20
        
    }
    
    func setupMissionTableView() {
        missionTableView?.register(UINib(nibName: "MissionTableViewCell", bundle: nil), forCellReuseIdentifier: MissionTableViewCell.identified)
        missionTableView?.tag = 0
        missionTableView?.dataSource = self
        missionTableView?.delegate = self
    }
    
    func setupConcentrateTimePicker() {
        pkvConcentrateTime?.delegate = self
        pkvConcentrateTime?.dataSource = self
        pkvConcentrateTime?.selectRow(0, inComponent: 0, animated: true)
        pkvConcentrateTime?.selectRow(50, inComponent: 2, animated: true)
        pkvConcentrateTime?.tag = 0
    }
    
    func setupRestTimePicker() {
        pkvRestTime?.delegate = self
        pkvRestTime?.dataSource = self
        pkvRestTime?.selectRow(10, inComponent: 0, animated: true)
        pkvRestTime?.tag = 1
    }
    
    func setupConcentrateTimeView() {
        vConcentrateTime!.layer.cornerRadius = 20
        vConcentrateTime!.layer.shadowOffset = CGSize(width: 0, height: 5)
        vConcentrateTime!.layer.shadowRadius = 10
        vConcentrateTime!.layer.shadowOpacity = 0.4
        
        btnConcentrateTimeCancel?.layer.cornerRadius = 20
        btnConcentrateTimeConfirm?.layer.cornerRadius = 20
    }
    
    func setupRestTimeView() {
        vRestTime!.layer.cornerRadius = 20
        vRestTime!.layer.shadowOffset = CGSize(width: 0, height: 5)
        vRestTime!.layer.shadowRadius = 10
        vRestTime!.layer.shadowOpacity = 0.4
        
        btnRestCancel?.layer.cornerRadius = 20
        btnRestConfirm?.layer.cornerRadius = 20
    }
    
    func setupAddInviteView() {
        vAddInvite!.layer.cornerRadius = 20
        vAddInvite!.layer.shadowOffset = CGSize(width: 0, height: 5)
        vAddInvite!.layer.shadowRadius = 10
        vAddInvite!.layer.shadowOpacity = 0.4
        
        btnStartConcentrate?.layer.cornerRadius = 20
        btnCancelConcentrate?.layer.cornerRadius = 20
    }
    
    func setupInviteSelectView() {
        vInviteRoomSelect?.layer.cornerRadius = 20
        vInviteRoomSelect?.layer.shadowOffset = CGSize(width: 0, height: 5)
        vInviteRoomSelect?.layer.shadowOpacity = 0.2
        vInviteRoomSelect?.layer.shadowRadius = 10
        vInviteRoomSelect?.backgroundColor = .white
        scvInviteRoomSelect?.delegate = self
    }
    
    func setupFriendListTableView() {
        tbvFriendList?.tag = 2
        tbvFriendList?.register(UINib(nibName: "InviteFriendsTableViewCell",
                                      bundle: nil),
                                forCellReuseIdentifier: InviteFriendsTableViewCell.identified)
        tbvFriendList?.delegate = self
        tbvFriendList?.dataSource = self
    }
    
    func setupInviteRoomListTableView() {
        tbvInviteRoomList?.tag = 1
        tbvInviteRoomList?.register(UINib(nibName: "InviteRoomListTableViewCell", bundle: nil), forCellReuseIdentifier: InviteRoomListTableViewCell.identified)
        tbvInviteRoomList?.delegate = self
        tbvInviteRoomList?.dataSource = self
    }
    
    @objc func reloadMissionStatus() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let now = dateFormatter.string(from: Date())
        callApiGetMissionList {
            self.callFindTodayMissionCompleteApi(accountId: UserPreferences.shared.accountId,
                                                 date: now) {
                var countProgress = 0
                self.missionList.forEach { mission in
                    if mission.status == true {
                        countProgress += 1
                    }
                }
                self.progressBar.currentIndex = countProgress
            }
        }
    }
    
    // MARK: - WSAction
    
    func reviceWSMessage() {
        wsInviteRoom?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got Data \(data)")
                case .string(let string):
                    print("Got RoomMember \(string)")
                    if string.contains("離開了") {
                        self.callApiRemoveToInviteRoom(removeAccountId: String(string.prefix(36)), inviteRoomId: self.inviteRoomId)
                    } else {
                        self.callApiAddToInviteRoom(reciveAccountId: String(string.prefix(36)),
                                                    inviteRoomId: self.inviteRoomId)
                    }
                @unknown default:
                    break
                }
            case .failure(let error):
                print("ws: \(error)")
                return
            }
            self.reviceWSMessage()
        })
    }
    
    func sendWSMessage(message: String,
                       completionHandler: (() -> Void)? = nil) {
        wsInviteRoom?.send(.string(message), completionHandler: { error in
            if error != nil {
                Alert.showAlert(title: "進入專注模式錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            } else {
                completionHandler?()
            }
        })
    }
    
    // MARK: - callAPIGetMissionList
    
    func callApiGetMissionList(completionHandler: (() -> Void)? = nil) {
        let request = GetMissionListRequest()
        Task {
            do {
                let result: GeneralResponse<[GetMissionListResponse]> = try await manager.requestData(method: .get,
                                                                                                      path: .getMissionList,
                                                                                                      parameters: request,
                                                                                                      needToken: true)
                missionList = []
                result.data?.forEach({ mission in
                    missionList.append(MissionList(missionID: mission.missionID, title: mission.title, progress: mission.progress, progressType: mission.progressType, status: false))
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
                })
                completionHandler?()
                missionTableView?.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    @objc func dismissAddInviteView() {
        vAddInvite?.isHidden = true
        wsInviteRoom?.cancel()
        isInviteRoomConnect = false
    }
    
    // MARK: - callFindTodayMissionCompleteAPI
    
    func callFindTodayMissionCompleteApi(accountId: String,
                                         date: String,
                                         completionHandler: (() -> Void)? = nil) {
        let request = FindTodayMissionCompleteRequest(accountId: UUID(uuidString: accountId)!,
                                                      date: date)
        Task {
            do {
                let result: GeneralResponse<FindTodayMissionCompleteResponse> = try await manager.requestData(method: .post,
                                                                                                              path: .findTodayMissionComplete,
                                                                                                      parameters: request,
                                                                                                      needToken: true)
                if result.result == 0 {
                    concentrateTimeCount = result.data!.concentrateTime
                    result.data?.missionId.forEach({ completeMissionId in
                        for i in 0 ..< missionList.count {
                            if missionList[i].missionID == completeMissionId {
                                missionList[i].status = true
                            }
                        }
                    })
                }
                missionTableView?.reloadData()
                completionHandler?()
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤",
                                message: "\(error)",
                                vc: self,
                                confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callWebSocketCreateInviteRoom
    
    func creatInviteRoom(path: ApiPathConstants, parameters: String, needToken: Bool) {
        
        guard let url = URL(string: NetworkConstants.webSocketBaseUrl + NetworkConstants.server + path.rawValue + parameters) else {
            print("Error: can not create URL")
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        urlSession.sessionDescription = "InviteRoom"
        var request = URLRequest(url: url)
        if needToken == true {
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(UserPreferences.shared.jwtToken)"]
        }
       
        wsInviteRoom = urlSession.webSocketTask(with: request)
        wsInviteRoom!.resume()
    }
    
    // MARK: - callAddConcentrateRecordAPI
    
    func callAddConcentrateRecordApi(accountId: String,
                                     hostAccountId: String,
                                     startTime: String,
                                     concentrateTime: String,
                                     restTime: String,
                                     friends: [UUID]) {
        let request = AddConcentrateRecordRequest(accountId: UUID(uuidString: accountId)!,
                                                  hostAccountId: UUID(uuidString: hostAccountId)!,
                                                  startTime: startTime,
                                                  concentrateTime: concentrateTime,
                                                  restTime: restTime,
                                                  withFriends: friends)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .addConcentrateRecord, parameters: request,
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
                    nextVC.concentrateRecordId = result.data!
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
                let result: GetFriendListResponse = try await manager.requestData(method: .post,
                                                                                  path: .getFriendList,
                                                                                  parameters: request,
                                                                                  needToken: true)
                friendListArray = []
                result.data.forEach { friendInfo in
                    if friendInfo.image == "未設置" {
                        friendListArray.append(inviteFriendListInfo(accountId: friendInfo.accountId,
                                                                    name: friendInfo.name,
                                                                    image: friendInfo.image))
                    } else {
                        friendListArray.append(inviteFriendListInfo(accountId: friendInfo.accountId,
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
            let request = CreatInviteRoomRequest(sendAccountId: UUID(uuidString: sendAccountId)!)
            
            do {
                let result: GeneralResponse<String> = try await manager.requestData(method: .post,
                                                                                    path: .createInviteRoom,
                                                                                    parameters: request,
                                                                                    needToken: true)
                
                if result.message == "建立成功" {
                    inviteRoomId = result.data!
                    self.creatInviteRoom(path: .wsInviteRoom,
                                         parameters: "\(result.data!)&HostAT:\(UserPreferences.shared.accountId)",
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
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .addFriendToInviteRoom,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.message == "好友已經在你的房間" {
                    Alert.showToastWith(message: "好友已經在你的房間", vc: self, during: .short)
                } else if result.message == "已邀請" {
                    
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
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .addToInviteRoom,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.message.contains("已加入房間") {
                    await callApiRefreshInviteRoomMemberList(inviteRoomId: inviteRoomId)
                    
                } else {
                    Alert.showAlert(title: "發生錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "發生錯誤", message: "請確認與伺服器的連線", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPIRemoveToInviteRoom
    
    func callApiRemoveToInviteRoom(removeAccountId: String, inviteRoomId: String) {
        let request = RemoveToInviteRoomRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                removeAccountId: UUID(uuidString: removeAccountId)!)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .removeToInviteRoom,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.message.contains("已離開房間") {
                    await callApiRefreshInviteRoomMemberList(inviteRoomId: inviteRoomId)
                    
                } else {
                    Alert.showAlert(title: "發生錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "發生錯誤", message: "請確認與伺服器的連線", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPIRefreshInviteRoomMemberList
    
    func callApiRefreshInviteRoomMemberList(inviteRoomId: String) async {
        let request = RefreshInviteRoomMemberListRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!)
            
            do {
                let result: GeneralResponse<RefreshInviteRoomMemberListResponse> = try await NetworkManager().requestData(method: .post,
                                                                                                                          path: .refreshInviteRoomMemberList,
                                                                                                          parameters: request,
                                                                                                          needToken: true)
                if result.message == "成功更新此房間的成員" {
                    inviteMemberList = []
                    
                    result.data?.memberList.forEach({ member in
                        inviteMemberList.append(InviteRoomMember(accountId: member.accountId,
                                                                 name: member.name,
                                                                 image: member.image))
                    })
                    tbvInviteRoomList?.reloadData()
                } else {
                    Alert.showAlert(title: "發生錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "發生錯誤", message: "請確認與伺服器的連線", vc: self, confirmTitle: "確認")
            }
        
    }
    
    // MARK: - callAPIRemoveInviteRoom
    
    func callApiRemoveInviteRoom(inviteRoomId: String) {
        let request = RemoveInviteRoomRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .removeInviteRoom,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if !result.message.contains("刪除成功") {
                    Alert.showAlert(title: "關閉邀請房間失敗", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "關閉邀請房間失敗", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPIStartMutipleConcentrate
    
    func callApiStartMutipleConcentrate(inviteRoomId: String,
                                        startTime: String,
                                        concentrateTime: String,
                                        restTime: String,
                                        completionHandler: (() -> Void)? = nil) {
        let request = StartMutipleConcentrateRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                     startTime: startTime,
                                                     concentrateTime: concentrateTime,
                                                     restTime: restTime)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .startMutipleConcentrate,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.message != "進入專注模式成功" {
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                } else {
                    completionHandler?()
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func showConcentrateTimeView() {
        if vConcentrateTime?.isHidden == true {
            UIView.transition(with: vConcentrateTime!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vConcentrateTime!.isHidden = false
                Alert.showAlert(title: "建議專注及休息時間", message: "若您使用 3C 產品進行工作，每40-50分鐘，應休息10-15分鐘", vc: self, confirmTitle: "確認")
            }
        } else {
            UIView.transition(with: vConcentrateTime!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vConcentrateTime!.isHidden = true
            }
        }
    }
    
    @IBAction func showRestTimeView() {
        if vRestTime?.isHidden == true {
            UIView.transition(with: vRestTime!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vRestTime!.isHidden = false
            }
        } else {
            UIView.transition(with: vRestTime!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vRestTime!.isHidden = true
            }
        }
    }
    
    @IBAction func clickConcentrateTimeCancelButton() {
        let defaultMin = Int((btnConcentrateTime?.titleLabel?.text!.suffix(2))!)
        let defaulthour = Int((btnConcentrateTime?.titleLabel?.text!.prefix(2))!)!
        pkvConcentrateTime?.selectRow(defaultMin!, inComponent: 2, animated: true)
        pkvConcentrateTime?.selectRow(defaulthour, inComponent: 0, animated: true)
        showConcentrateTimeView()
    }
    
    @IBAction func clickConcentrateTimeConfirmButton() {
        btnConcentrateTime?.setTitle("\(contrateTimeHour):\(contrateTimeMin)",
                                     for: .normal)
        showConcentrateTimeView()
    }
    
    @IBAction func clickRestTimeCancelButton() {
        let defaultMin = Int((btnRestTime?.titleLabel?.text!.prefix(2))!)!
        pkvRestTime?.selectRow(defaultMin, inComponent: 0, animated: true)
        showRestTimeView()
    }
    
    @IBAction func clickRestTimeConfirmButton() {
        btnRestTime?.setTitle("\(restTimeMin) min",
                                     for: .normal)
        showRestTimeView()
    }
    
    @IBAction func startConcentrate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = dateFormatter.string(from: Date())
        callAddConcentrateRecordApi(accountId: UserPreferences.shared.accountId,
                                    hostAccountId: UserPreferences.shared.accountId,
                                    startTime: now,
                                    concentrateTime: (btnConcentrateTime?.titleLabel?.text)!,
                                    restTime: "\(restTimeMin) m",
                                    friends: [])
    }
    
    @IBAction func clickCreateInviteRoom() {
        if vAddInvite?.isHidden == true {
            callApiCreateInviteRoom(sendAccountId: UserPreferences.shared.accountId)
            callApiFriendList(accountId: UserPreferences.shared.accountId)
            vAddInvite?.isHidden = false
            inviteMemberList = []
        } else {
            vAddInvite?.isHidden = true
            wsInviteRoom!.cancel(with: .goingAway, reason: nil)
            isInviteRoomConnect = false
        }
    }
    
    @IBAction func clickCloseInviteRoom() {
        vAddInvite?.isHidden = true
        if isInviteRoomConnect == true {
            wsInviteRoom!.cancel(with: .goingAway, reason: nil)
            isInviteRoomConnect = false
            inviteMemberList = []
            tbvInviteRoomList?.reloadData()
        }
        callApiRemoveInviteRoom(inviteRoomId: inviteRoomId)
    }
    
    @IBAction func clickRoomSelectButton() {
        scvInviteRoomSelect?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.2) { [self] in
            self.vInviteRoomSelect!.transform = CGAffineTransform(translationX: 0,
                                                                  y: 0)
        }
    }
    
    @IBAction func clickFriendListSelectButton() {
        scvInviteRoomSelect?.setContentOffset(CGPoint(x: (scvInviteRoomSelect?.frame.width)!, y: 0), animated: true)
        UIView.animate(withDuration: 0.2) { [self] in
            self.vInviteRoomSelect!.transform = CGAffineTransform(translationX: (vInviteRoomSelect?.frame.width)!,
                                                                  y:0)
        }
    }
    
    @objc func clickAddFriendToConcentrateRoom(_ sender: UIButton) {
        callAddFriendToInviteRoomApi(inviteRoomId: inviteRoomId, reciveAccountId: friendListArray[sender.tag].accountId)
    }
    
    @IBAction func clickMultipleConcentrateButton() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = dateFormatter.string(from: Date())
        self.callApiStartMutipleConcentrate(inviteRoomId: self.inviteRoomId,
                                            startTime: now,
                                            concentrateTime: (self.btnConcentrateTime?.titleLabel?.text)!,
                                            restTime: "\(self.restTimeMin) m") {
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
            self.wsInviteRoom?.cancel()
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

// MARK: - MissionTableView

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
            let cell = tableView.dequeueReusableCell(withIdentifier: MissionTableViewCell.identified, for: indexPath) as! MissionTableViewCell
            cell.lbTitle.text = missionList[indexPath.row].title
            if missionList[indexPath.row].status == true {
                cell.lbProgress.isHidden = true
                cell.imgvCheck.isHidden = false
            } else {
                cell.lbProgress.isHidden = false
                cell.imgvCheck.isHidden = true
                if missionList[indexPath.row].progressType == "分鐘" {
                    cell.lbProgress.text = "\(concentrateTimeCount) / \(missionList[indexPath.row].progress) \(missionList[indexPath.row].progressType)"
                } else {
                    cell.lbProgress.text = "\(missionList[indexPath.row].progress) \(missionList[indexPath.row].progressType)"
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: InviteRoomListTableViewCell.identified, for: indexPath) as! InviteRoomListTableViewCell
            if inviteMemberList[indexPath.row].image == "未設置" {
                cell.imgvUser?.image = UIImage(systemName: "person.fill")
            } else {
                cell.imgvUser?.image = inviteMemberList[indexPath.row].image.stringToUIImage()
            }
            cell.name?.text = inviteMemberList[indexPath.row].name
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: InviteFriendsTableViewCell.identified, for: indexPath) as! InviteFriendsTableViewCell
            cell.btnAddInvite?.tag = indexPath.row
            cell.btnAddInvite?.addTarget(self, action: #selector(clickAddFriendToConcentrateRoom), for: .touchUpInside)
            if friendListArray[indexPath.row].image == "未設置" {
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if pickerView.tag == 0 {
            switch component {
            case 0:
                if hourArray[row] > 9 {
                    return NSAttributedString(string: "\(hourArray[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                } else {
                    return NSAttributedString(string: "0\(hourArray[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                }
            case 1:
                return NSAttributedString(string: "h", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            case 2:
                if minArray[row] > 9 {
                    return NSAttributedString(string: "\(minArray[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                } else {
                    return NSAttributedString(string: "0\(minArray[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                }
            default:
                return NSAttributedString(string: "min", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            }
        } else {
            if component == 0 {
                if minArray[row] > 9 {
                    return NSAttributedString(string: "\(minArray[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                } else {
                    return NSAttributedString(string: "0\(minArray[row])", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                }
            } else {
                return NSAttributedString(string: "min", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 4
        } else {
            return 2
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
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
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            if hourArray[row] > 9 {
//                return ("\(hourArray[row])")
//            } else {
//                return ("0\(hourArray[row])")
//            }
//        case 1:
//            return "h"
//        case 2:
//            if minArray[row] > 9 {
//                return ("\(minArray[row])")
//            } else {
//                return ("0\(minArray[row])")
//            }
//        default:
//            return "min"
//        }
//    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            if component == 0 {
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
            if component == 0 {
                if minArray[row] > 9 {
                    restTimeMin = ("\(minArray[row])")
                } else {
                    restTimeMin = ("0\(minArray[row])")
                }
            }
        }
    }
}

// MARK: - SessionWebSocketDelegate

extension ConcentrateViewController: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        isInviteRoomConnect = true
        print("URLSessionWebSocketTask is connected")
        reviceWSMessage()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isInviteRoomConnect = false
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            print(string)
        } else {
            print("error")
        }
    }
    
}

// MARK: - ScrollViewDelegate

//extension ConcentrateViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
//        print(Int((scrollView.contentOffset.x + 100) / (scrollView.frame.width)))
//    }
//}

// MARK: - Protocol
