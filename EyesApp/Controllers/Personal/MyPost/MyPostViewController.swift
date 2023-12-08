//
//  MyPostViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import ProgressHUD
import UIKit

class MyPostViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvMyPost: UITableView!
    
    // MARK: - Properties
    
    var postList: [LoadNewsResponse.NewsItem] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        Task {
            await callApiLoadNews(accountId: UserPreferences.shared.accountId)
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
        self.title = "MyPost"
    }
    
    func setupTableView() {
        tbvMyPost?.register(HasPictureNewsTableViewCell.loadFromNib(),
                            forCellReuseIdentifier: HasPictureNewsTableViewCell.identifier)
        tbvMyPost?.register(NewsTableViewCell.loadFromNib(),
                            forCellReuseIdentifier: NewsTableViewCell.identifier)
        tbvMyPost!.estimatedRowHeight = 100
        tbvMyPost!.rowHeight = UITableView.automaticDimension
        tbvMyPost?.dataSource = self
        tbvMyPost?.delegate = self
    }
    
    // MARK: - callAPILoadNews
    
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
                tbvMyPost.reloadData()
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

extension MyPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
}

// MARK: - LoadNewsDelegate

extension MyPostViewController: LoadNewsDelegate {
    
    func loadNews() async {
        await callApiLoadNews(accountId: UserPreferences.shared.accountId)
    }
}

// MARK: - Protocol

