//
//  StartConcentrateViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/22.
//

import AVFoundation
import Lottie
import UIKit

class StartConcentrateViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vAnimate: UIView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btnGiveUp: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnAudioPlay: UIButton!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var imgvBackground: UIImageView!
    @IBOutlet weak var btnEyeExercise: UIButton!
    @IBOutlet weak var btnFatigueDetection: UIButton!
    @IBOutlet weak var lbLaveTime: UILabel!
    
    // MARK: - Properties
    
    var concentrateTime: String = "50:00:00"
    var restTime: String = "10"
    var countConcentrateTimer = Timer()
    var countRestTimer = Timer()
    var concentrateRecordId: String = ""
    let player = AVQueuePlayer()
    var audioLooper: AVPlayerLooper?
    var audioPlayStatus = false
    var restStatus = false
    var giveUpStatus = false
    var wifiIsConnect = false
    let imagePicker = UIImagePickerController()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.post(name: .goToConcentrate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbTime?.text = concentrateTime
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .reloadMissionStatus, object: nil)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        setupConcentrateAnimate()
        setTimer()
        setupAudio()
    }
    
    fileprivate func setupConcentrateAnimate() {
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
        vAnimate.addSubview(vStartCount)
        vStartCount.play()
    }
    
    func setTimer() {
        btnFatigueDetection.isHidden = false
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
        var timeStringSep = time.split(separator: ":")
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
            Task {
                let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
                await callApiCompleteConcentrateRecord(recordId: concentrateRecordId, endTime: now)
            }
            btnGiveUp.isHidden = true
            btnConfirm.isHidden = false
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
        var sec = Int(time.suffix(2)) ?? 0
        var min = Int(time.prefix(2)) ?? 0
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
            btnConfirm?.isHidden = false
            UIView.transition(with: vAnimate,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate.isHidden = true
            }
            return
        }
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: GiveUpConcentrateRecord
    
    func callApiGiveUpConcentrateRecord(recordId: String, endTime: String) async {
        let request = GiveUpConcentrateRecordRequest(recordId: UUID(uuidString: recordId)!,
                                                     endTime: endTime)
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
        let request = GiveUpConcentrateRecordRequest(recordId: UUID(uuidString: recordId)!,
                                                     endTime: endTime)
        do {
            let _: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                         path: .completeConcentrateRecord,
                                                                                         parameters: request,
                                                                                         needToken: true)
        } catch {
            print(error)
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
                Task {
                    let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
                    await self.callApiGiveUpConcentrateRecord(recordId: self.concentrateRecordId, endTime: now)
                }
                
                self.countConcentrateTimer.invalidate()
                self.lbStatusTitle.text = "已放棄"
                self.giveUpStatus = true
                self.btnGiveUp.setTitle("關閉並回到主頁", for: .normal)
                UIView.transition(with: self.imgvBackground,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve) {
                    self.imgvBackground.image = UIImage(named: "Sin City Red")
                }
                UIView.transition(with: self.vAnimate,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve) {
                    self.vAnimate.isHidden = true
                }
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
    
    @IBAction func clickConfirmButton() {
        if restStatus == false {
            btnFatigueDetection.isHidden = true
            btnEyeExercise.isHidden = false
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
            UIView.transition(with: btnConfirm,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.btnConfirm.isHidden = true
                self.btnConfirm.setTitle("完成專注", for: .normal)
            }
            restStatus = true
        } else {
            if wifiIsConnect {
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
                        self.callApiAddConcentrateToNews(concentrateRecordId: self.concentrateRecordId) {
                            Alert.showAlert(title: "分享成功",
                                            message: "",
                                            vc: self,
                                            confirmTitle: "確認") {
                                self.dismiss(animated: true)
                            }
                        }
                    } cancel: {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func goToEyeExercise() {
        let nextVC = EyeExerciseViewController()
        self.present(nextVC, animated: true)
    }
    
    @IBAction func goToFatigueDetection() {
        var transformValue = lbLaveTime.frame.height
        UIView.animate(withDuration: 0.3) {
            self.lbLaveTime.transform = CGAffineTransform(translationX: 0, y: -transformValue)
        }
        
        transformValue = lbTime.frame.height + 10
        UIView.animate(withDuration: 0.3) {
            self.lbTime.transform = CGAffineTransform(translationX: 0, y: -transformValue)
        }
        
        transformValue = lbTime.frame.height + 10
        UIView.animate(withDuration: 0.3) {
            self.vAnimate.transform = CGAffineTransform(translationX: 0, y: -transformValue)
        }
        
        transformValue = lbStatusTitle.frame.height
        UIView.animate(withDuration: 0.3) {
            self.lbStatusTitle.transform = CGAffineTransform(translationX: 0, y: -transformValue)
        }
        
        let nextVC = FatigueDetectionViewController()
        nextVC.backToStartConcentrateDelegate = self
        if let presentationController = nextVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(nextVC, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension StartConcentrateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
            let nextVC = TakePhotoToConcentrateRecordViewController()
            let image = info[.originalImage] as? UIImage
            print(image!)
            nextVC.pictureImage = image
            nextVC.concentrateType = .along
            nextVC.recordId = self.concentrateRecordId
            self.present(nextVC, animated: true)
        }
    }
}

// MARK: - FatigueDetectionBackToStartConcentrateVCDelegate

extension StartConcentrateViewController: FatigueDetectionBackToStartConcentrateVCDelegate {
    
    func transformUI() {
        UIView.animate(withDuration: 0.3) {
            self.lbLaveTime.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.lbTime.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.vAnimate.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.lbStatusTitle.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}

// MARK: - Protocol

