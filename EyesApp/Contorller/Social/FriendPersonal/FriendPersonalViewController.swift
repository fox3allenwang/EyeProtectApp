//
//  FriendPersonalViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import UIKit
import ProgressHUD

class FriendPersonalViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var igvUser: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tbvConcentrateRecord: UITableView!
    @IBOutlet weak var tbvPost: UITableView!
    
    // MARK: - Variables
    
    var concentrateRecordList: [SelfConcentrateRecordItem] = []
    var postList: [NewsItem] = []
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
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        igvUser.image = userImage
        callAPIFindSelfConcentrateRecord(accountId: friendAccountId)
        callApiLoadNews(accountId: friendAccountId) {
            ProgressHUD.dismiss()
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
        tbvPost?.register(UINib(nibName: "HasPictureNewsTableViewCell", bundle: nil), forCellReuseIdentifier: HasPictureNewsTableViewCell.identified)
        tbvPost?.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identified)
        tbvPost!.estimatedRowHeight = 100
        tbvPost!.rowHeight = UITableView.automaticDimension
        tbvPost?.dataSource = self
        tbvPost?.delegate = self
        tbvPost.tag = 0
        
        tbvConcentrateRecord.register(UINib(nibName: "ConcentrateRecordTableViewCell",
                                            bundle: nil),
                                      forCellReuseIdentifier: ConcentrateRecordTableViewCell.identified)
        tbvConcentrateRecord.register(UINib(nibName: "FirstConcentrateRecordTableViewCell",
                                            bundle: nil),
                                      forCellReuseIdentifier: FirstConcentrateRecordTableViewCell.identified)
        tbvConcentrateRecord.delegate = self
        tbvConcentrateRecord.dataSource = self
        tbvConcentrateRecord.tag = 1
    }
    
    func setupIgvUser() {
        igvUser.layer.cornerRadius = igvUser.frame.width / 2
        igvUser.layer.borderWidth = 3
        igvUser.layer.borderColor = UIColor.buttomColor?.cgColor
    }
    func setupBackgroundView() {
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        backgroundView.layer.shadowOpacity = 0.7
        backgroundView.layer.shadowRadius = 20
        backgroundView.alpha = 0.2
    }
    // MARK: - callAPIFindSelfConcentrateRecord
    
    func callAPIFindSelfConcentrateRecord(accountId: String,
                                          completionHandler: (() -> Void)? = nil) {
        let request = FindSelfConcentrateRecordRequest(accountId: UUID(uuidString: accountId)!)
        
        Task {
            do {
                let result: GeneralResponse<FindSelfConcentrateRecordResponse> = try await NetworkManager().requestData(method: .post, path: .findSelfConcentrateRecord, parameters: request, needToken: true)
                
                if result.message == "ConcentrateRecord 是空的" ||
                    result.message == "找到 ConcentrateRecord 了" {
                    concentrateRecordList = result.data!.concentrateRecordList
                    concentrateRecordList.sort { firstItem, secondItem in
                        if firstItem.startTime < secondItem.startTime {
                            return false
                        } else {
                            return true
                        }
                    }
                    tbvConcentrateRecord.reloadData()
                    completionHandler?()
                } else {
                    completionHandler?()
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                completionHandler?()
                print(error)
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPILoadNews
    
    func callApiLoadNews(accountId: String,
                         completionHandler: (() -> Void)? = nil) {
        let request = LoadNewsRequest(accountId: UUID(uuidString: accountId)!)
        Task {
            do {
                let result: GeneralResponse<LoadNewsResponse> = try await NetworkManager().requestData(method: .post,
                                                                                                       path: .loadOnePersonNews,
                                                                                                       parameters: request,
                                                                                                       needToken: true)
                if result.message == "已搜尋所有的 News" {
                    postList = []
                    postList = result.data!.newsItems
                    postList.sort { FirstNewItem, SecondNewItem in
                        if FirstNewItem.time > SecondNewItem.time {
                            return true
                        } else {
                            return false
                        }
                    }
                    tbvPost?.reloadData()
                    completionHandler?()
                } else {
                    completionHandler?()
                    Alert.showAlert(title: "錯誤",
                                    message: result.message,
                                    vc: self,
                                    confirmTitle: "確認")
                }
            } catch {
                completionHandler?()
                print(error)
                Alert.showAlert(title: "錯誤",
                                message: "\(error)",
                                vc: self,
                                confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - IBAction
    
    @objc func clickShowReply(_ sender: UIButton) {
        let replyVC = ReplyViewController()
        replyVC.loadNewsDelegate = self
        replyVC.newsId = postList[sender.tag].newsId.uuidString
        if let presentationController = replyVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(replyVC, animated: true)
    }
    
}

// MARK: - TableViewExtension

extension FriendPersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return postList.count
        } else {
            return concentrateRecordList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            if postList[indexPath.row].newsPicture == "未上傳" {
                let cell = tbvPost?.dequeueReusableCell(withIdentifier: NewsTableViewCell.identified, for: indexPath) as! NewsTableViewCell
                if postList[indexPath.row].sendAccountImage == "未設置" {
                    cell.imgvUser?.image = UIImage(systemName: "person.fill")
                } else {
                    cell.imgvUser?.image = postList[indexPath.row].sendAccountImage.stringToUIImage()
                }
                cell.lbDescription?.text = postList[indexPath.row].description
                cell.lbTitle?.text = postList[indexPath.row].title
                cell.btnShowReply!.tag = indexPath.row
                cell.btnShowReply?.setTitle("查看全部 \(postList[indexPath.row].replyCount) 則留言", for: .normal)
                cell.btnShowReply?.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
                return cell
                
            } else {
                let cell = tbvPost?.dequeueReusableCell(withIdentifier: HasPictureNewsTableViewCell.identified,
                                                        for: indexPath) as! HasPictureNewsTableViewCell
                if postList[indexPath.row].sendAccountImage == "未設置" {
                    cell.imgvUser?.image = UIImage(systemName: "person.fill")
                } else {
                    cell.imgvUser?.image = postList[indexPath.row].sendAccountImage.stringToUIImage()
                }
                cell.imgvPicture?.image = postList[indexPath.row].newsPicture.stringToUIImage()
                cell.lbDescription?.text = postList[indexPath.row].description
                cell.lbTitle?.text = postList[indexPath.row].title
                cell.btnShowReply!.tag = indexPath.row
                cell.btnShowReply?.setTitle("查看全部 \(postList[indexPath.row].replyCount) 則留言", for: .normal)
                cell.btnShowReply?.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
                return cell
            }
        } else {
            if indexPath.row == concentrateRecordList.count - 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: FirstConcentrateRecordTableViewCell.identified, for: indexPath) as! FirstConcentrateRecordTableViewCell
                if concentrateRecordList[indexPath.row].isFinished == true {
                    cell.imgvStatus?.image = UIImage(systemName: "checkmark")
                    cell.vStatusCircle?.backgroundColor = UIColor.buttom2Color
                    cell.vStatusStrip?.backgroundColor = UIColor.buttom2Color
                } else {
                    cell.imgvStatus?.image = UIImage(systemName: "multiply")
                    cell.vStatusCircle?.backgroundColor = UIColor.cancel
                    cell.vStatusStrip?.backgroundColor = UIColor.cancel
                }
                
                var withFriends: String = "好友： "
                if concentrateRecordList[indexPath.row].accountId != concentrateRecordList[indexPath.row].hostAccountId {
                    withFriends.append("\(concentrateRecordList[indexPath.row].hostAccountId), ")
                }
                for i in 0 ..< concentrateRecordList[indexPath.row].withFriends.count {
                    if i == concentrateRecordList[indexPath.row].withFriends.count - 1{
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i])")
                    } else {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i]), ")
                    }
                }
                cell.lbConcentrateTime?.text = "\(concentrateRecordList[indexPath.row].startTime)"
                cell.lbConcentrateRecord?.text = "專注時間： \(concentrateRecordList[indexPath.row].concentrateTime)   休息時間：\(concentrateRecordList[indexPath.row].restTime)"
                if withFriends == "好友： " {
                    withFriends = "單人模式"
                }
                cell.lbConcentrateWith?.text = withFriends
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ConcentrateRecordTableViewCell.identified, for: indexPath) as! ConcentrateRecordTableViewCell
                if concentrateRecordList[indexPath.row].isFinished == true {
                    cell.imgvStatus?.image = UIImage(systemName: "checkmark")
                    cell.vStatusCircle?.backgroundColor = UIColor.buttom2Color
                    cell.vStatusStrip?.backgroundColor = UIColor.buttom2Color
                } else {
                    cell.imgvStatus?.image = UIImage(systemName: "multiply")
                    cell.vStatusCircle?.backgroundColor = UIColor.cancel
                    cell.vStatusStrip?.backgroundColor = UIColor.cancel
                }
                
                var withFriends: String = "好友： "
                if concentrateRecordList[indexPath.row].accountId != concentrateRecordList[indexPath.row].hostAccountId {
                    withFriends.append("\(concentrateRecordList[indexPath.row].hostAccountId), ")
                }
                for i in 0 ..< concentrateRecordList[indexPath.row].withFriends.count {
                    if i == concentrateRecordList[indexPath.row].withFriends.count - 1{
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i])")
                    } else {
                        withFriends.append("\(concentrateRecordList[indexPath.row].withFriends[i]), ")
                    }
                    
                }
                cell.lbConcentrateTime?.text = "\(concentrateRecordList[indexPath.row].startTime)"
                cell.lbConcentrateRecord?.text = "專注時間： \(concentrateRecordList[indexPath.row].concentrateTime)   休息時間：\(concentrateRecordList[indexPath.row].restTime)"
                if withFriends == "好友： " {
                    withFriends = "單人模式"
                }
                cell.lbConcentrateWith?.text = withFriends
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            let nextVC = ConcentrateRecordViewController()
            nextVC.timeTitle = "\(concentrateRecordList[indexPath.row].startTime) 的專注歷程"
            nextVC.recordId = concentrateRecordList[indexPath.row].recordId.uuidString
            self.present(nextVC, animated: true)
        }
    }
}

// MARK: - LoadNewsDelegate

extension FriendPersonalViewController: LoadNewsDelegate {
    func loadNews() {
        callApiLoadNews(accountId: UserPreferences.shared.accountId)
    }
}

// MARK: - Protocol

