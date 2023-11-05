//
//  MyPostViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import UIKit
import ProgressHUD

class MyPostViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvMyPost: UITableView?
    
    // MARK: - Variables
    
    var postList: [NewsItem] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        callApiLoadNews(accountId: UserPreferences.shared.accountId) {
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
        self.title = "MyPost"
    }
    
    func setupTableView() {
        tbvMyPost?.register(UINib(nibName: "HasPictureNewsTableViewCell", bundle: nil), forCellReuseIdentifier: HasPictureNewsTableViewCell.identified)
        tbvMyPost?.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identified)
        tbvMyPost!.estimatedRowHeight = 100
        tbvMyPost!.rowHeight = UITableView.automaticDimension
        tbvMyPost?.dataSource = self
        tbvMyPost?.delegate = self
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
                    tbvMyPost?.reloadData()
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

extension MyPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postList[indexPath.row].newsPicture == "未上傳" {
            let cell = tbvMyPost?.dequeueReusableCell(withIdentifier: NewsTableViewCell.identified, for: indexPath) as! NewsTableViewCell
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
            let cell = tbvMyPost?.dequeueReusableCell(withIdentifier: HasPictureNewsTableViewCell.identified,
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
    }
}

// MARK: - LoadNewsDelegate

extension MyPostViewController: LoadNewsDelegate {
    func loadNews() {
        callApiLoadNews(accountId: UserPreferences.shared.accountId)
    }
}

// MARK: - Protocol

