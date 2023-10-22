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
    
    // MARK: - Variables
    var progressBar: FlexibleSteppedProgressBar!
    let manager = NetworkManager()
    var missionList: [MissionList] = []
    let hourArray = [Int](0...2)
    let minArray = [Int](0 ... 59)
    var contrateTimeHour = "00"
    var contrateTimeMin = "50"
    var restTimeMin = "10"
    
    struct MissionList {
        public var missionID: UUID
        public var title: String
        public var progress: Int
        public var progressType: String
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ConcentrateViewController")
        callApiGetMissionList()
        
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
        setupTableView()
        setupConcentrateTimePicker()
        setupConcentrateTimeView()
        setupRestTimePicker()
        setupRestTimeView()
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
        progressBar.numberOfPoints = 5
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
    
    func setupTableView() {
        missionTableView?.register(UINib(nibName: "MissionTableViewCell", bundle: nil), forCellReuseIdentifier: MissionTableViewCell.identified)
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
    
    // MARK: - callAPIGetMissionList
    
    func callApiGetMissionList() {
        let request = GetMissionListRequest()
        Task {
            do {
                let result: GeneralResponse<[GetMissionListResponse]> = try await manager.requestData(method: .get,
                                                                                                      path: .getMissionList,
                                                                                                      parameters: request,
                                                                                                      needToken: true)
                missionList = []
                result.data?.forEach({ mission in
                    missionList.append(MissionList(missionID: mission.missionID, title: mission.title, progress: mission.progress, progressType: mission.progressType))
                })
                missionTableView?.reloadData()
            } catch {
                print(error)
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
        let nextVC = StartConcentrateViewController()
        nextVC.concentrateTime = (btnConcentrateTime?.titleLabel?.text)!
        nextVC.restTime = String((btnRestTime?.titleLabel?.text!.prefix(2))!)
        nextVC.isModalInPresentation = true
        present(nextVC, animated: true)
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
        return missionList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MissionTableViewCell.identified, for: indexPath) as! MissionTableViewCell
        cell.lbTitle.text = missionList[indexPath.row].title
        cell.lbProgress.text = "\(missionList[indexPath.row].progress) \(missionList[indexPath.row].progressType)"
        return cell
    }
}

// MARK: Extension - PickerView

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

// MARK: - Protocol
