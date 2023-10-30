//
//  MutipleConcentrateMemberVersionViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/30.
//

import UIKit
import Lottie
import AVFoundation
import ProgressHUD

class MutipleConcentrateMemberVersionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vAnimate: UIView?
    @IBOutlet weak var lbTime: UILabel?
    @IBOutlet weak var btnGiveUp: UIButton?
    @IBOutlet weak var btnAudioPlay: UIButton?
    @IBOutlet weak var lbStatusTitle: UILabel?
    @IBOutlet weak var imgvBackground: UIImageView?

    
    // MARK: - Variables
    
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
    var wsMutipleConcentrate: URLSessionWebSocketTask? = nil
    var inviteMemberList: [InviteRoomMember] = []
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .lineSpinFade
        ProgressHUD.show("等待房主開始中...")
        lbTime?.text = concentrateTime
        callWebSocketStartMutipleConcentrate(path: .wsMutipleConcentrate,
                                             parameters: "\(inviteRoomId)&Member:\(UserPreferences.shared.accountId)",
                                             needToken: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        
        if btnGiveUp?.isHidden == true {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let now = dateFormatter.string(from: Date())
            
        }
        
        wsMutipleConcentrate?.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
                                   width: CGFloat((vAnimate?.frame.width)!),
                                   height: CGFloat((vAnimate?.frame.height)!))
        vStartCount.center = CGPoint(x: UIScreen.main.bounds.width * 0.99,
                                     y: UIScreen.main.bounds.height * 0.45)
        vStartCount.loopMode = .loop
        vStartCount.animationSpeed = 1
        vAnimate!.addSubview(vStartCount)
        vStartCount.play()
    }
    
    func setTimer() {
        countConcentrateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countConcentrate), userInfo: nil, repeats: true)
    }
    
    func setupAudio() {
        let url = Bundle.main.url(forResource: "潮汐_Freesound", withExtension: "wav")!
        let playerItem = AVPlayerItem(url: url)
        audioLooper = AVPlayerLooper(player: player, templateItem: playerItem)
    }
    
    func pushConcentrateNotification() {
        let content = UNMutableNotificationContent()
        content.subtitle = "恭喜你完成這次的專注任務"
        content.body = "時間在哪里，成就就在哪裡"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "ConcentrateNotification", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
    func pushRestNotification() {
        let content = UNMutableNotificationContent()
        content.subtitle = "休息時間到了！可以回來安排下一次的專注任務"
        content.body = "休息是為了走更長遠的路"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "RestNotification", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
    @objc func countConcentrate() {
        var timeStringSep = lbTime?.text?.split(separator: ":")
        var sec = Int(timeStringSep![2]) ?? 0
        var min = Int(timeStringSep![1]) ?? 0
        var h = Int((timeStringSep![0])) ?? 0
        
        var total = h * 3600 + min * 60 + sec
        
        total -= 1
        
        sec = total % 60
        min = (total % 3600) / 60
        h = total / 3600
        
        if h > 9 && min > 9 && sec > 9 {
            lbTime?.text = "\(h):\(min):\(sec)"
        } else if h <= 9 && min <= 9 && sec <= 9 {
            lbTime?.text = String(format: "0%d:0%d:0%d", h, min, sec)
        } else if h <= 9 && min <= 9 && sec > 9 {
            lbTime?.text = String(format: "0%d:0%d:%d", h, min, sec)
        } else if h <= 9 && min > 9 && sec <= 9 {
            lbTime?.text = String(format: "0%d:%d:0%d", h, min, sec)
        } else if h > 9 && min <= 9 && sec <= 9 {
            lbTime?.text = String(format: "%d:0%d:0%d", h, min, sec)
        } else if h <= 9 && min > 9 && sec > 9 {
            lbTime?.text = String(format: "0%d:%d:%d", h, min, sec)
        } else if h > 9 && min <= 9 && sec > 9 {
            lbTime?.text = String(format: "%d:0%d:%d", h, min, sec)
        } else if h > 9 && min > 9 && sec <= 9 {
            lbTime?.text = String(format: "%d:%d:0%d", h, min, sec)
        }
        
        if total == 0 {
            pushConcentrateNotification()
            countConcentrateTimer.invalidate()
            lbTime?.text = "00:00:00"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let now = dateFormatter.string(from: Date())
           
            btnGiveUp?.isHidden = true
            UIView.transition(with: vAnimate!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate?.isHidden = true
            }
            return
        }
    }
    
    @objc func countRest() {
        var sec = Int((lbTime?.text?.suffix(2))!) ?? 0
        var min = Int((lbTime?.text?.prefix(2))!) ?? 0
        var total = min * 60 + sec
        
        total -= 1
        sec = total % 60
        min = Int(floor(Float(total / 60)))
        
        if min > 9 && sec > 9 {
            lbTime?.text = "\(min):\(sec)"
        } else if min < 9 && sec <= 9 {
            lbTime?.text = "0\(min):0\(sec)"
        } else if min > 9 && sec <= 9 {
            lbTime?.text = "\(min):0\(sec)"
        } else {
            lbTime?.text = "0\(min):\(sec)"
        }
        
        if total == 0 {
            pushRestNotification()
            countRestTimer.invalidate()
            lbTime?.text = "00:00"
            UIView.transition(with: vAnimate!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate?.isHidden = true
            }
            return
        }
    }
    
    func concentrateFaild() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = dateFormatter.string(from: Date())
      
        self.countConcentrateTimer.invalidate()
        self.lbStatusTitle?.text = "已放棄"
        self.giveUpStatus = true
        self.btnGiveUp?.setTitle("關閉並回到主頁", for: .normal)
        UIView.transition(with: self.imgvBackground!,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.imgvBackground?.image = UIImage(named: "Sin City Red")
        }
        UIView.transition(with: self.vAnimate!,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            self.vAnimate?.isHidden = true
        }
    }
    
    // MARK: - WSAction
    
    func reviceWSMessage() {
        wsMutipleConcentrate?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got Data \(data)")
                case .string(let string):
                    if string.contains("所有成員已進入專注模式") {
                        self.setTimer()
                        ProgressHUD.dismiss()
                    } else if string.contains("有成員沒有進入專注模式"){
                        ProgressHUD.dismiss()
                        self.wsMutipleConcentrate?.cancel()
                        self.dismiss(animated: true)
                    } else if string.contains("離開了") {
                        self.wsMutipleConcentrate?.cancel()
                        let interruptAccountId = string.prefix(36)
                        print(interruptAccountId)
                        self.callFindAccountApi(accountId: String(interruptAccountId)) { result in
                            Alert.showAlert(title: "\((result.data?.name)!) 中斷專注了", message: "因為 \((result.data?.name)!) 中斷專注，因此這次的專注沒有成功", vc: self, confirmTitle: "確認") {
                                self.concentrateFaild()
                            }
                        }
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
        wsMutipleConcentrate?.send(.string(message), completionHandler: { error in
            if error != nil {
               
            } else {
                completionHandler?()
            }
        })
    }
    
    
    // MARK: - callGiveUpConcentrateRecordAPI
    
    func callGiveUpConcentrateRecordApi(recordId: String,
                                        endTime: String) {
        let request = GiveUpConcentrateRecordRequest(recordId: UUID(uuidString: recordId)!,
                                                     endTime: endTime)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .giveUpConcentrateRecord, parameters: request,
                                                                                             needToken: true)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - callCompleteConcentrateRecordAPI
    
    func callCompleteConcentrateRecordApi(recordId: String,
                                          endTime: String) {
        let request = GiveUpConcentrateRecordRequest(recordId: UUID(uuidString: recordId)!,
                                                     endTime: endTime)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager().requestData(method: .post,
                                                                                             path: .completeConcentrateRecord,
                                                                                             parameters: request,
                                                                                             needToken: true)
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - callWebSocketStartMutipleConcentrate
    
    func callWebSocketStartMutipleConcentrate(path: ApiPathConstants,
                                              parameters: String,
                                              needToken: Bool) {
        
        guard let url = URL(string: NetworkConstants.webSocketBaseUrl + NetworkConstants.server + path.rawValue + parameters) else {
            print("Error: can not create URL")
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        urlSession.sessionDescription = "MutipleConcentrateMemberVersion"
        var request = URLRequest(url: url)
        if needToken == true {
            request.allHTTPHeaderFields = ["Authorization": "Bearer \(UserPreferences.shared.jwtToken)"]
        }
       
        wsMutipleConcentrate = urlSession.webSocketTask(with: request)
        wsMutipleConcentrate!.resume()
    }
    
    // MARK: - callFindAccountAPI
    
    func callFindAccountApi(accountId: String,
                            completionHandler: ((GeneralResponse<FindAccountAPIResponse>) -> Void)? = nil) {
        let request = FindAccountAPIRequest(accountId: UUID(uuidString: accountId)!)
        
        Task {
            do {
                let result: GeneralResponse<FindAccountAPIResponse> = try await NetworkManager().requestData(method: .post,
                                                                                                             path: .findAccountAPI,
                                                                                                             parameters: request,
                                                                                                             needToken: true)
                // 這裡用了邀請畫面更新好友資料的 API
                if result.message == "加入成功" {
                    completionHandler?(result)
                } else {
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func clickGiveUp() {
        
        if giveUpStatus == false {
            Alert.showAlert(title: "確定要放棄？",
                            message: "所有偉大的事，都是因為堅持才得以實現的，你確定要放棄嗎？",
                            vc: self,
                            confirmTitle: "確定" ,cancelTitle: "取消", confirm: {
                self.concentrateFaild()
            })
            
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func clickAudioPlayButton() {
        if audioPlayStatus == false {
            audioPlayStatus = true
            btnAudioPlay?.setImage(UIImage(systemName: "speaker.wave.3"), for: .normal)
            player.play()
        } else {
            audioPlayStatus = false
            btnAudioPlay?.setImage(UIImage(systemName: "speaker.slash"), for: .normal)
            player.pause()
        }
    }
    
    @IBAction func clickConfirmButton() {
        if restStatus == false {
            lbStatusTitle?.text = "休息模式"
            lbTime?.text = "\(restTime):00"
            UIView.transition(with: vAnimate!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate?.isHidden = false
            }
            countRestTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countRest), userInfo: nil, repeats: true)
            restStatus = true
        } else {
            Alert.showAlert(title: "是否要拍照紀錄一下你的里程紀錄呢？", message: "", vc: self, confirmTitle: "要", cancelTitle: "不要") {
                // todo: 拍照功能
            } cancel: {
                self.dismiss(animated: true)
            }
        }
    }
    
}

// MARK: - Extension

// MARK: - SessionWebSocketDelegate

extension MutipleConcentrateMemberVersionViewController: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("URLSessionWebSocketTask is connected")
        reviceWSMessage()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            print(string)
        } else {
            print("error")
        }
    }
    
}

// MARK: - Protocol

