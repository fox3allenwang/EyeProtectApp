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
    
    // MARK: - Variables
    var progressBar: FlexibleSteppedProgressBar!
    let manager = NetworkManager()
    var missionList: [MissionList] = []
    
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

// MARK: - Protocol
