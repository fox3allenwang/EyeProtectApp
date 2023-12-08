//
//  MutipleConcentrateMemberVersionViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/30.
//

import AVFoundation
import Lottie
import ProgressHUD
import UIKit

class MutipleConcentrateMemberVersionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vAnimate: UIView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btnGiveUp: UIButton!
    @IBOutlet weak var btnAudioPlay: UIButton!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var imgvBackground: UIImageView!
    @IBOutlet weak var btnCompleteRest: UIButton!
    
    // MARK: - Properties
    
    var concentrateTime: String = "50:00:00"
    var restTime: String = "10"
    var countConcentrateTimer = Timer()
    var countRestTimer = Timer()
    var inviteRoomId: String = ""
    let player = AVQueuePlayer()
    var audioLooper: AVPlayerLooper?
    var audioPlayStatus = false
    var restStatus = false
    var giveUpStatus = false
    var inviteMemberList: [InviteRoomMember] = []
    let imagePicker = UIImagePickerController()
    var isDoneForConcentrate = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isDoneForConcentrate == false {
            ProgressHUD.colorAnimation = .buttomColor
            ProgressHUD.colorHUD = .themeColor
            ProgressHUD.animationType = .lineSpinFade
            ProgressHUD.show("等待房主開始中...")
            lbTime.text = concentrateTime
            callWebSocketStartMutipleConcentrate(path: .wsMutipleConcentrate,
                                                 parameters: "\(inviteRoomId)&Member:\(UserPreferences.shared.accountId)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        
        if btnGiveUp.isHidden == true {
            let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
        }
        
        WebSocketManager.shared.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .reloadMissionStatus, object: nil)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupConcentrateAnimate()
        setupAudio()
    }
    
    func setupConcentrateAnimate() {
        let vStartCount = LottieAnimationView(name: "startConcentrate")
        vStartCount.contentMode = .scaleAspectFill
        vStartCount.frame = CGRect(x: 0,
                                   y: 0,
                                   width: vAnimate.frame.width,
                                   height: vAnimate.frame.height)
        vStartCount.center = CGPoint(x: UIScreen.main.bounds.width * 0.99,
                                     y: UIScreen.main.bounds.height * 0.45)
        vStartCount.loopMode = .loop
        vStartCount.animationSpeed = 1
        vAnimate!.addSubview(vStartCount)
        vStartCount.play()
    }
    
    func setTimer() {
        NotificationCenter.default.post(name: .goToConcentrate, object: nil)
        countConcentrateTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                     target: self,
                                                     selector: #selector(countConcentrate),
                                                     userInfo: nil,
                                                     repeats: true)
    }
    
    func setupAudio() {
        let url = Bundle.main.url(forResource: "潮汐_Freesound", withExtension: "wav")!
        let playerItem = AVPlayerItem(url: url)
        audioLooper = AVPlayerLooper(player: player, templateItem: playerItem)
    }
    
    func pushConcentrateNotification() {
        Task {
            do {
                try await UNNotificationManager.shared.add(subtitle: "恭喜你完成這次的專注任務",
                                                           body: "時間在哪里，成就就在哪裡",
                                                           badge: 1,
                                                           identifier: "ConcentrateNotification")
            } catch {
                print(error)
            }
        }
    }
    
    func pushRestNotification() {
        Task {
            do {
                try await UNNotificationManager.shared.add(subtitle: "休息時間到了！可以回來安排下一次的專注任務",
                                                           body: "休息是為了走更長遠的路",
                                                           badge: 1,
                                                           identifier: "RestNotification")
            } catch {
                print(error)
            }
        }
    }
    
    @objc func countConcentrate() {
        guard let time = lbTime.text else {
            return
        }
        let timeStringSep = time.split(separator: ":")
        var sec = Int(timeStringSep[2]) ?? 0
        var min = Int(timeStringSep[1]) ?? 0
        var h = Int((timeStringSep[0])) ?? 0
        
        var total = h * 3600 + min * 60 + sec
        
        total -= 1
        
        sec = total % 60
        min = (total % 3600) / 60
        h = total / 3600
        
        if h > 9 && min > 9 && sec > 9 {
            lbTime.text = "\(h):\(min):\(sec)"
        } else if h <= 9 && min <= 9 && sec <= 9 {
            lbTime.text = String(format: "0%d:0%d:0%d", h, min, sec)
        } else if h <= 9 && min <= 9 && sec > 9 {
            lbTime.text = String(format: "0%d:0%d:%d", h, min, sec)
        } else if h <= 9 && min > 9 && sec <= 9 {
            lbTime.text = String(format: "0%d:%d:0%d", h, min, sec)
        } else if h > 9 && min <= 9 && sec <= 9 {
            lbTime.text = String(format: "%d:0%d:0%d", h, min, sec)
        } else if h <= 9 && min > 9 && sec > 9 {
            lbTime.text = String(format: "0%d:%d:%d", h, min, sec)
        } else if h > 9 && min <= 9 && sec > 9 {
            lbTime.text = String(format: "%d:0%d:%d", h, min, sec)
        } else if h > 9 && min > 9 && sec <= 9 {
            lbTime.text = String(format: "%d:%d:0%d", h, min, sec)
        }
        
        if total.isEqual(to: 0) {
            pushConcentrateNotification()
            countConcentrateTimer.invalidate()
            lbTime.text = "00:00:00"
            lbStatusTitle.text = "等待房主完成專注模式"
            btnGiveUp.isHidden = true
            UIView.transition(with: vAnimate,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate.isHidden = true
            }
            return
        }
    }
    
    @objc func countRest() {
        guard let time = lbTime.text else {
            return
        }
        var sec = Int((time.suffix(2))) ?? 0
        var min = Int((time.prefix(2))) ?? 0
        var total = min * 60 + sec
        
        total -= 1
        sec = total % 60
        min = Int(floor(Float(total / 60)))
        
        if min > 9 && sec > 9 {
            lbTime.text = "\(min):\(sec)"
        } else if min < 9 && sec <= 9 {
            lbTime.text = "0\(min):0\(sec)"
        } else if min > 9 && sec <= 9 {
            lbTime.text = "\(min):0\(sec)"
        } else {
            lbTime.text = "0\(min):\(sec)"
        }
        
        if total.isEqual(to: 0) {
            pushRestNotification()
            countRestTimer.invalidate()
            lbTime.text = "00:00"
            UIView.transition(with: btnCompleteRest,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.btnCompleteRest.isHidden = false
            }
            
            UIView.transition(with: vAnimate,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate.isHidden = true
            }
            return
        }
    }
    
    @objc func closeAppInConcentrateMode() {
        self.concentrateFaild()
        WebSocketManager.shared.cancel()
        NotificationCenter.default.removeObserver(self,
                                                  name: .concentrateCackgroundNotification,
                                                  object: nil)
    }
    
    func concentrateFaild() {
        countConcentrateTimer.invalidate()
        lbStatusTitle.text = "已放棄"
        giveUpStatus = true
        btnGiveUp.setTitle("關閉並回到主頁", for: .normal)
        UIView.transition(with: imgvBackground,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.imgvBackground.image = UIImage(named: "Sin City Red")
        }
        UIView.transition(with: vAnimate,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.vAnimate.isHidden = true
        }
    }
    
    func completeConcentrate() {
        lbStatusTitle.text = "休息模式"
        lbTime.text = "\(restTime):00"
        UIView.transition(with: vAnimate,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.vAnimate.isHidden = false
        }
        countRestTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(countRest),
                                              userInfo: nil,
                                              repeats: true)
        restStatus = true
    }
    
    // MARK: - Call Backend WebSocket API
    
    func callWebSocketStartMutipleConcentrate(path: ApiPathConstants, parameters: String) {
        WebSocketManager.shared.delegate = self
        WebSocketManager.shared.connect(path: path,
                                        parameters: parameters,
                                        sessionDescription: "MutipleConcentrateMemberVersion")
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: GiveUpConcentrateRecord
    
    func callApiGiveUpConcentrateRecord(recordId: String, endTime: String) async {
        let request = GiveUpConcentrateRecordRequest(recordId: UUID(uuidString: recordId)!, endTime: endTime)
        do {
            let _: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                         path: .giveUpConcentrateRecord, parameters: request,
                                                                                         needToken: true)
        } catch {
            print(error)
        }
    }
    
    // MARK: CompleteConcentrateRecord
    
    func callApiCompleteConcentrateRecord(recordId: String, endTime: String) async {
        let request = GiveUpConcentrateRecordRequest(recordId: UUID(uuidString: recordId)!, endTime: endTime)
        do {
            let _: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                         path: .completeConcentrateRecord,
                                                                                         parameters: request,
                                                                                         needToken: true)
        } catch {
            print(error)
        }
    }
    
    // MARK: FindAccount
    
    func callApiFindAccount(accountId: String,
                            finish: ((GeneralResponse<FindAccountResponse>) -> Void)? = nil) {
        let request = FindAccountRequest(accountId: UUID(uuidString: accountId)!)
        
        Task {
            do {
                let result: GeneralResponse<FindAccountResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                               path: .findAccountAPI,
                                                                                                               parameters: request,
                                                                                                               needToken: true)
                // 這裡用了邀請畫面更新好友資料的 API
                if result.message.isEqual(to: "加入成功") {
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
    
    // MARK: CompleteMutipleConcentrate
    
    func callApiCompleteMutipleConcentrate(accountId: String,
                                           inviteRoomId: String,
                                           endTime: String) async {
        let request = CompleteMutipleConcentrateRequest(accountId: UUID(uuidString: accountId)!,
                                                        inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                        endTime: endTime)
        
        do {
            let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                              path: .completeMutipleConcentrate,
                                                                                              parameters: request,
                                                                                              needToken: true)
            if !result.message.contains("已更新成功") {
                Alert.showAlert(title: "錯誤",
                                message: "\(result.message)",
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
    
    // MARK: UseInviteRoomIdAndAccountIdTofindConcentrateRecordId
    
    func callApiUseInviteRoomIdAndAccountIdTofindConcentrateRecordId(inviteRoomId: String,
                                                                     accountId: String,
                                                                     finish: ((String) -> Void)? = nil) {
        let request = UseInviteRoomIdAndAccountIdToFindConcentrateRecordIdRequest(inviteRoomId: UUID(uuidString: inviteRoomId)!,
                                                                                  accountId: UUID(uuidString: accountId)!)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .useInviteRoomIdAndAccountIdTofindConcentrateRecordId,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "查詢成功") {
                    finish?(result.data)
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
    
    // MARK: AddConcentrateToNews
    
    func callApiAddConcentrateToNews(concentrateRecordId: String,
                                     finish: (() -> Void)? = nil) {
        let request = AddConcentrateToNewsRequest(concentrateRecordId: UUID(uuidString: concentrateRecordId)!)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .addConcentrateToNews,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "發送成功") {
                    finish?()
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
    
    @IBAction func clickGiveUp() {
        if giveUpStatus == false {
            Alert.showAlert(title: "確定要放棄？",
                            message: "所有偉大的事，都是因為堅持才得以實現的，你確定要放棄嗎？",
                            vc: self,
                            confirmTitle: "確定",
                            cancelTitle: "取消",
                            confirm: {
                self.concentrateFaild()
                WebSocketManager.shared.cancel()
            })
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func clickAudioPlayButton() {
        if audioPlayStatus == false {
            audioPlayStatus = true
            btnAudioPlay.setImage(UIImage(systemIcon: .speakerWave3), for: .normal)
            player.play()
        } else {
            audioPlayStatus = false
            btnAudioPlay.setImage(UIImage(systemIcon: .speakerSlash), for: .normal)
            player.pause()
        }
    }
    
    @IBAction func clickCompleteAndBackToMain() {
        Alert.showAlert(title: "是否要拍照紀錄一下你的里程紀錄呢？",
                        message: "",
                        vc: self,
                        confirmTitle: "要",
                        cancelTitle: "不要") {
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true)
        } cancel: {
            Alert.showAlert(title: "要分享到朋友圈嗎？",
                            message: "",
                            vc: self,
                            confirmTitle: "要",
                            cancelTitle: "不要") {
                self.callApiUseInviteRoomIdAndAccountIdTofindConcentrateRecordId(inviteRoomId: self.inviteRoomId,
                                                                                 accountId: UserPreferences.shared.accountId) { recordId in
                    self.callApiAddConcentrateToNews(concentrateRecordId: recordId) {
                        Alert.showAlert(title: "分享成功",
                                        message: "",
                                        vc: self,
                                        confirmTitle: "確認") {
                            self.dismiss(animated: true)
                        }
                    }
                }
            } cancel: {
                self.dismiss(animated: true)
            }
        }
    }
}

// MARK: - WebSocketManagerDelegate

extension MutipleConcentrateMemberVersionViewController: WebSocketManagerDelegate {
    
    func webSocket(_ webSocketManager: WebSocketManager,
                   _ session: URLSession,
                   webSocketTask: URLSessionWebSocketTask,
                   didOpenWithProtocol protocol: String?) async {
        print("URLSessionWebSocketTask is connected")
        await WebSocketManager.shared.receive()
    }
    
    func webSocket(_ webSocketManager: WebSocketManager,
                   _ session: URLSession,
                   webSocketTask: URLSessionWebSocketTask,
                   didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                   reason: Data?) {
        if let reason = reason,
           let string = String(data: reason, encoding: .utf8) {
            print(string)
        } else {
            print("error")
        }
    }
    
    func webSocket(_ webSocketManager: WebSocketManager, didReceive message: String) {
        if message.contains("所有成員已進入專注模式") {
            setTimer()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.closeAppInConcentrateMode),
                                                   name: .concentrateCackgroundNotification,
                                                   object: nil)
            ProgressHUD.dismiss()
        } else if message.contains("有成員沒有進入專注模式") {
            ProgressHUD.dismiss()
            WebSocketManager.shared.cancel()
            dismiss(animated: true)
        } else if message.contains("離開了") {
            WebSocketManager.shared.cancel()
            let interruptAccountId = message.prefix(36)
            print(interruptAccountId)
            concentrateFaild()
            callApiFindAccount(accountId: String(interruptAccountId)) { result in
                Alert.showAlert(title: "\((result.data.name)) 中斷專注了",
                                message: "因為 \((result.data.name)) 中斷專注，所以這次的專注沒有成功",
                                vc: self,
                                confirmTitle: "確認")
            }
        } else if message.contains("已完成專注模式") {
            WebSocketManager.shared.cancel()
            completeConcentrate()
            isDoneForConcentrate = true
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MutipleConcentrateMemberVersionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let nextVC = TakePhotoToConcentrateRecordViewController()
            let image = info[.originalImage] as? UIImage
            print(image!)
            nextVC.pictureImage = image
            nextVC.concentrateType = .mutiple
            nextVC.inviteRoomId = self.inviteRoomId
            self.present(nextVC, animated: true)
        }
    }
}

// MARK: - Protocol

