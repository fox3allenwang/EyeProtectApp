//
//  NewsViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/29.
//

import ProgressHUD
import UIKit

class NewsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvNews: UITableView!
    
    // MARK: - Properties
    
    var newsList: [LoadNewsResponse.NewsItem] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NewsViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task {
            await callApiLoadNews(accountId: UserPreferences.shared.accountId)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupNewsTableView()
    }
    
    func setupNewsTableView() {
        tbvNews.register(HasPictureNewsTableViewCell.loadFromNib(),
                         forCellReuseIdentifier: HasPictureNewsTableViewCell.identifier)
        tbvNews.register(NewsTableViewCell.loadFromNib(),
                         forCellReuseIdentifier: NewsTableViewCell.identifier)
        tbvNews.estimatedRowHeight = 100
        tbvNews.rowHeight = UITableView.automaticDimension
        tbvNews.dataSource = self
        tbvNews.delegate = self
    }
    
    // MARK: - Functions
    
    @objc func clickShowReply(_ sender: UIButton) {
        let replyVC = ReplyViewController()
        replyVC.delegate = self
        replyVC.newsId = newsList[sender.tag].newsId.uuidString
        if let presentationController = replyVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(replyVC, animated: true)
    }
    
    // MARK: - Call Backend RESTful API
    
    func callApiLoadNews(accountId: String) async {
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        let request = LoadNewsRequest(accountId: UUID(uuidString: accountId)!)
        do {
            let result: GeneralResponse<LoadNewsResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                        path: .loadNews,
                                                                                                        parameters: request,
                                                                                                        needToken: true)
            if result.message.isEqual(to: "已搜尋所有的 News") {
                newsList = []
                newsList = result.data.newsItems
                newsList.sort { first, second in
                    if first.time > second.time {
                        return true
                    } else {
                        return false
                    }
                }
                tbvNews.reloadData()
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.dismiss()
                Alert.showAlert(title: "錯誤",
                                message: result.message,
                                vc: self,
                                confirmTitle: "確認")
            }
        } catch {
            ProgressHUD.dismiss()
            print(error)
            Alert.showAlert(title: "錯誤",
                            message: "\(error)",
                            vc: self,
                            confirmTitle: "確認")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newsList[indexPath.row].newsPicture.isEqual(to: "未上傳") {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                           for: indexPath) as? NewsTableViewCell else {
                fatalError("NewsTableViewCell Load Failed")
            }
            if newsList[indexPath.row].sendAccountImage.isEqual(to: "未設置") {
                cell.imgvUser.image = UIImage(systemIcon: .personFill)
            } else {
                cell.imgvUser.image = newsList[indexPath.row].sendAccountImage.stringToUIImage()
            }
            cell.lbDescription.text = newsList[indexPath.row].description
            cell.lbTitle.text = newsList[indexPath.row].title
            cell.btnShowReply.tag = indexPath.row
            cell.btnShowReply.setTitle("查看全部 \(newsList[indexPath.row].replyCount) 則留言", for: .normal)
            cell.btnShowReply.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HasPictureNewsTableViewCell.identifier,
                                                           for: indexPath) as? HasPictureNewsTableViewCell else {
                fatalError("HasPictureNewsTableViewCell Load Failed")
            }
            if newsList[indexPath.row].sendAccountImage.isEqual(to: "未設置") {
                cell.imgvUser.image = UIImage(systemIcon: .personFill)
            } else {
                cell.imgvUser.image = newsList[indexPath.row].sendAccountImage.stringToUIImage()
            }
            cell.imgvPicture.image = newsList[indexPath.row].newsPicture.stringToUIImage()
            cell.lbDescription.text = newsList[indexPath.row].description
            cell.lbTitle.text = newsList[indexPath.row].title
            cell.btnShowReply.tag = indexPath.row
            cell.btnShowReply.setTitle("查看全部 \(newsList[indexPath.row].replyCount) 則留言", for: .normal)
            cell.btnShowReply.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
            return cell
        }
    }
}

// MARK: - LoadNewsDelegate

extension NewsViewController: LoadNewsDelegate {
    
    func loadNews() async {
        await callApiLoadNews(accountId: UserPreferences.shared.accountId)
    }
}

// MARK: - Protocol
