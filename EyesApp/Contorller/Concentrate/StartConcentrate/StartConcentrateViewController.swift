//
//  StartConcentrateViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/22.
//

import UIKit
import Lottie
import AVFoundation

class StartConcentrateViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vAnimate: UIView?
    @IBOutlet weak var lbTime: UILabel?
    @IBOutlet weak var btnGiveUp: UIButton?
    @IBOutlet weak var btnConfirm: UIButton?
    @IBOutlet weak var btnAudioPlay: UIButton?
    @IBOutlet weak var lbStatusTitle: UILabel?
    @IBOutlet weak var imgvBackground: UIImageView?
    
    // MARK: - Variables
    
    var concentrateTime: String = "50:00"
    var restTime: String = "10"
    var countConcentrateTimer = Timer()
    var countRestTimer = Timer()
    var concentrateRecordId: String = ""
    let player = AVQueuePlayer()
    var audioLooper: AVPlayerLooper?
    var audioPlayStatus = false
    var restStatus = false
    var giveUpStatus = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        if btnGiveUp?.isHidden == true {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let now = dateFormatter.string(from: Date())
            callGiveUpConcentrateRecordApi(recordId: concentrateRecordId,
                                           endTime: now)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupConcentrateAnimate()
        setTimer()
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
        countConcentrateTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(countConcentrate), userInfo: nil, repeats: true)
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
        var min = Int((lbTime?.text?.suffix(2))!) ?? 0
        var h = Int((lbTime?.text?.prefix(2))!) ?? 0
        var total = h * 60 + min
        
        total -= 1
        min = total % 60
        h = Int(floor(Float(total / 60)))
        
        if h > 9 && min > 9 {
            lbTime?.text = "\(h):\(min)"
        } else if h < 9 && min <= 9 {
            lbTime?.text = "0\(h):0\(min)"
        } else if h > 9 && min <= 9 {
            lbTime?.text = "\(h):0\(min)"
        } else {
            lbTime?.text = "0\(h):\(min)"
        }
        
        if total == 0 {
            pushConcentrateNotification()
            countConcentrateTimer.invalidate()
            lbTime?.text = "00:00"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let now = dateFormatter.string(from: Date())
            callCompleteConcentrateRecordApi(recordId: concentrateRecordId,
                                             endTime: now)
            btnGiveUp?.isHidden = true
            btnConfirm?.isHidden = false
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
            btnConfirm?.isHidden = false
            UIView.transition(with: vAnimate!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.vAnimate?.isHidden = true
            }
            return
        }
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
    
    // MARK: - IBAction
    
    @IBAction func clickGiveUp() {
        
        if giveUpStatus == false {
            Alert.showAlert(title: "確定要放棄？",
                            message: "所有偉大的事，都是因為堅持才得以實現的，你確定要放棄嗎？",
                            vc: self,
                            confirmTitle: "確定" ,cancelTitle: "取消", confirm: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let now = dateFormatter.string(from: Date())
                self.callGiveUpConcentrateRecordApi(recordId: self.concentrateRecordId,
                                                    endTime: now)
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
            UIView.transition(with: btnConfirm!,
                              duration: 0.2,
                              options: .transitionCrossDissolve) {
                self.btnConfirm?.setTitle("關閉", for: .normal)
            }
            restStatus = true
        } else {
            self.dismiss(animated: true)
        }
    }
    
}

// MARK: - Extension

// MARK: - Protocol

