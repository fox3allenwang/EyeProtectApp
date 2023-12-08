//
//  FriendPersonalViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import ProgressHUD
import UIKit

class FriendPersonalViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var igvUser: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tbvConcentrateRecord: UITableView!
    @IBOutlet weak var tbvPost: UITableView!
    
    // MARK: - Properties
    
    var concentrateRecordList: [FindSelfConcentrateRecordResponse.SelfConcentrateRecordItem] = []
    var postList: [LoadNewsResponse.NewsItem] = []
    var friendAccountId = ""
    var userImage: UIImage?
    var userName = ""
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        igvUser.image = userImage
        Task {
            await callApiFindSelfConcentrateRecord(accountId: friendAccountId)
            await callApiLoadNews(accountId: friendAccountId)
            await MainActor.run {
                ProgressHUD.dismiss()
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
        setupTableView()
        setupIgvUser()
        setupBackgroundView()
    }
    
    func setupTableView() {
        tbvPost.register(HasPictureNewsTableViewCell.loadFromNib(),
                         forCellReuseIdentifier: HasPictureNewsTableViewCell.identifier)
        tbvPost.register(NewsTableViewCell.loadFromNib(),
                         forCellReuseIdentifier: NewsTableViewCell.identifier)
        tbvPost.estimatedRowHeight = 100
        tbvPost.rowHeight = UITableView.automaticDimension
        tbvPost.dataSource = self
        tbvPost.delegate = self
        tbvPost.tag = 0
        
        tbvConcentrateRecord.register(ConcentrateRecordTableViewCell.loadFromNib(),
                                      forCellReuseIdentifier: ConcentrateRecordTableViewCell.identifier)
        tbvConcentrateRecord.register(FirstConcentrateRecordTableViewCell.loadFromNib(),
                                      forCellReuseIdentifier: FirstConcentrateRecordTableViewCell.identifier)
        tbvConcentrateRecord.delegate = self
        tbvConcentrateRecord.dataSource = self
        tbvConcentrateRecord.tag = 1
    }
    
    func setupIgvUser() {
        igvUser.layer.cornerRadius = igvUser.frame.width / 2
        igvUser.layer.borderWidth = 3
        igvUser.layer.borderColor = UIColor.buttomColor.cgColor
    }
    func setupBackgroundView() {
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        backgroundView.layer.shadowOpacity = 0.7
        backgroundView.layer.shadowRadius = 20
        backgroundView.alpha = 0.2
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: FindSelfConcentrateRecord
    
    func callApiFindSelfConcentrateRecord(accountId: String) async {
        let request = FindSelfConcentrateRecordRequest(accountId: UUID(uuidString: accountId)!)
        do {
            let result: GeneralResponse<FindSelfConcentrateRecordResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                                         path: .findSelfConcentrateRecord,
                                                                                                                         parameters: request,
                                                                                                                         needToken: true)
            if result.message.isEqual(to: "ConcentrateRecord 是空的") ||
                result.message.isEqual(to: "找到 ConcentrateRecord 了") {
                concentrateRecordList = result.data.concentrateRecordList
                concentrateRecordList.sort { firstItem, secondItem in
                    if firstItem.startTime < secondItem.startTime {
                        return false
                    } else {
                        return true
                    }
                }
                tbvConcentrateRecord.reloadData()
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
    
    // MARK: LoadNews
    
    func callApiLoadNews(accountId: String) async {
        let request = LoadNewsRequest(accountId: UUID(uuidString: accountId)!)
        do {
            let result: GeneralResponse<LoadNewsResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                        path: .loadOnePersonNews,
                                                                                                        parameters: request,
                                                                                                        needToken: true)
            if result.message.isEqual(to: "已搜尋所有的 News") {
                postList = []
                postList = result.data.newsItems
                postList.sort { first, second in
                    if first.time > second.time {
                        return true
                    } else {
                        return false
                    }
                }
                tbvPost.reloadData()
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
    
    // MARK: - IBAction
    
    @objc func clickShowReply(_ sender: UIButton) {
        let replyVC = ReplyViewController()
        replyVC.delegate = self
        replyVC.newsId = postList[sender.tag].newsId.uuidString
        if let presentationController = replyVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(replyVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FriendPersonalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag.isEqual(to: 0) {
            return postList.count
        } else {
            return concentrateRecordList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag.isEqual(to: 0) {
            if postList[indexPath.row].newsPicture.isEqual(to: "未上傳") {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                               for: indexPath) as? NewsTableViewCell else {
                    fatalError("NewsTableViewCell Load Failed")
                }
                if postList[indexPath.row].sendAccountImage.isEqual(to: "未設置") {
                    cell.imgvUser.image = UIImage(systemIcon: .personFill)
                } else {
                    cell.imgvUser.image = postList[indexPath.row].sendAccountImage.stringToUIImage()
                }
                cell.lbDescription.text = postList[indexPath.row].description
                cell.lbTitle.text = postList[indexPath.row].title
                cell.btnShowReply.tag = indexPath.row
                cell.btnShowReply.setTitle("查看全部 \(postList[indexPath.row].replyCount) 則留言", for: .normal)
                cell.btnShowReply.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
                return cell
                
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HasPictureNewsTableViewCell.identifier,
                                                               for: indexPath) as? HasPictureNewsTableViewCell else {
                    fatalError("HasPictureNewsTableViewCell Load Failed")
                }
                if postList[indexPath.row].sendAccountImage.isEqual(to: "未設置") {
                    cell.imgvUser.image = UIImage(systemIcon: .personFill)
                } else {
                    cell.imgvUser.image = postList[indexPath.row].sendAccountImage.stringToUIImage()
                }
                cell.imgvPicture.image = postList[indexPath.row].newsPicture.stringToUIImage()
                cell.lbDescription.text = postList[indexPath.row].description
                cell.lbTitle.text = postList[indexPath.row].title
                cell.btnShowReply.tag = indexPath.row
                cell.btnShowReply.setTitle("查看全部 \(postList[indexPath.row].replyCount) 則留言", for: .normal)
                cell.btnShowReply.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
                return cell
            }
        } else {
            if indexPath.row.isEqual(to: concentrateRecordList.count - 1) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstConcentrateRecordTableViewCell.identifier,
                                                               for: indexPath) as? FirstConcentrateRecordTableViewCell else {
                    fatalError("FirstConcentrateRecordTableViewCell Load Failed")
                }
                if concentrateRecordList[indexPath.row].isFinished == true {
                    cell.imgvStatus.image = UIImage(systemIcon: .checkmark)
                    cell.vStatusCircle.backgroundColor = .buttom2Color
                    cell.vStatusStrip.backgroundColor = .buttom2Color
                } else {
                    cell.imgvStatus.image = UIImage(systemIcon: .multiply)
                    cell.vStatusCircle.backgroundColor = .cancel
                    cell.vStatusStrip.backgroundColor = .cancel
                }
                
                var withFriends: String = "好友： "
                if concentrateRecordList[indexPath.row].accountId != concentrateRecordList[indexPath.row].hostAccountId {
                    withFriends.append("\(concentrateRecordList[indexPath.row].hostAccountId), ")
                }
                for i in 0 ..< concentrateRecordList[indexPath.row].withFriends.count {
                    if i == concentrateRecordList[indexPath.row].withFriends.count - 1 {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i])")
                    } else {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i]), ")
                    }
                }
                cell.lbConcentrateTime.text = "\(concentrateRecordList[indexPath.row].startTime)"
                cell.lbConcentrateRecord.text = "專注時間： \(concentrateRecordList[indexPath.row].concentrateTime)   休息時間：\(concentrateRecordList[indexPath.row].restTime)"
                if withFriends.isEqual(to: "好友： ") {
                    withFriends = "單人模式"
                }
                cell.lbConcentrateWith.text = withFriends
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ConcentrateRecordTableViewCell.identifier,
                                                               for: indexPath) as? ConcentrateRecordTableViewCell else {
                    fatalError("ConcentrateRecordTableViewCell Load Failed")
                }
                if concentrateRecordList[indexPath.row].isFinished == true {
                    cell.imgvStatus.image = UIImage(systemIcon: .checkmark)
                    cell.vStatusCircle.backgroundColor = .buttom2Color
                    cell.vStatusStrip.backgroundColor = .buttom2Color
                } else {
                    cell.imgvStatus.image = UIImage(systemIcon: .multiply)
                    cell.vStatusCircle.backgroundColor = .cancel
                    cell.vStatusStrip.backgroundColor = .cancel
                }
                
                var withFriends: String = "好友： "
                if concentrateRecordList[indexPath.row].accountId != concentrateRecordList[indexPath.row].hostAccountId {
                    withFriends.append("\(concentrateRecordList[indexPath.row].hostAccountId), ")
                }
                for i in 0 ..< concentrateRecordList[indexPath.row].withFriends.count {
                    if i == concentrateRecordList[indexPath.row].withFriends.count - 1 {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i])")
                    } else {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i]), ")
                    }
                }
                cell.lbConcentrateTime.text = "\(concentrateRecordList[indexPath.row].startTime)"
                cell.lbConcentrateRecord.text = "專注時間： \(concentrateRecordList[indexPath.row].concentrateTime)   休息時間：\(concentrateRecordList[indexPath.row].restTime)"
                if withFriends.isEqual(to: "好友： ") {
                    withFriends = "單人模式"
                }
                cell.lbConcentrateWith.text = withFriends
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag.isEqual(to: 1) {
            let nextVC = ConcentrateRecordViewController()
            nextVC.timeTitle = "\(concentrateRecordList[indexPath.row].startTime) 的專注歷程"
            nextVC.recordId = concentrateRecordList[indexPath.row].recordId.uuidString
            self.present(nextVC, animated: true)
        }
    }
}

// MARK: - LoadNewsDelegate

extension FriendPersonalViewController: LoadNewsDelegate {
    
    func loadNews() async {
        await callApiLoadNews(accountId: UserPreferences.shared.accountId)
    }
}

// MARK: - Protocol

