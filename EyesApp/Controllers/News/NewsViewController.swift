//
//  NewsViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/29.
//

import UIKit
import ProgressHUD

class NewsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvNews: UITableView!
    
    // MARK: - Variables
    
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
        callApiLoadNews(accountId: UserPreferences.shared.accountId)
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
        tbvNews?.register(UINib(nibName: "HasPictureNewsTableViewCell", bundle: nil), forCellReuseIdentifier: HasPictureNewsTableViewCell.identified)
        tbvNews?.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: NewsTableViewCell.identified)
        tbvNews!.estimatedRowHeight = 100
        tbvNews!.rowHeight = UITableView.automaticDimension
        tbvNews?.dataSource = self
        tbvNews?.delegate = self
    }
    
    // MARK: - callAPILoadNews
    
    func callApiLoadNews(accountId: String) {
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        let request = LoadNewsRequest(accountId: UUID(uuidString: accountId)!)
        Task {
            do {
                let result: GeneralResponse<LoadNewsResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                       path: .loadNews,
                                                                                                       parameters: request,
                                                                                                       needToken: true)
                if result.message == "已搜尋所有的 News" {
                    newsList = []
                    newsList = result.data.newsItems
                    newsList.sort { FirstNewItem, SecondNewItem in
                        if FirstNewItem.time > SecondNewItem.time {
                            return true
                        } else {
                            return false
                        }
                    }
                    tbvNews?.reloadData()
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
    
    // MARK: - IBAction
    
    @objc func clickShowReply(_ sender: UIButton) {
        let replyVC = ReplyViewController()
        replyVC.loadNewsDelegate = self
        replyVC.newsId = newsList[sender.tag].newsId.uuidString
        if let presentationController = replyVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(replyVC, animated: true)
    }
    
}

// MARK: - Extension

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if newsList[indexPath.row].newsPicture == "未上傳" {
            let cell = tbvNews?.dequeueReusableCell(withIdentifier: NewsTableViewCell.identified, for: indexPath) as! NewsTableViewCell
            if newsList[indexPath.row].sendAccountImage == "未設置" {
                cell.imgvUser?.image = UIImage(systemName: "person.fill")
            } else {
                cell.imgvUser?.image = newsList[indexPath.row].sendAccountImage.stringToUIImage()
            }
            cell.lbDescription?.text = newsList[indexPath.row].description
            cell.lbTitle?.text = newsList[indexPath.row].title
            cell.btnShowReply!.tag = indexPath.row
            cell.btnShowReply?.setTitle("查看全部 \(newsList[indexPath.row].replyCount) 則留言", for: .normal)
            cell.btnShowReply?.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
            return cell
            
        } else {
            let cell = tbvNews?.dequeueReusableCell(withIdentifier: HasPictureNewsTableViewCell.identified,
                                                    for: indexPath) as! HasPictureNewsTableViewCell
            if newsList[indexPath.row].sendAccountImage == "未設置" {
                cell.imgvUser?.image = UIImage(systemName: "person.fill")
            } else {
                cell.imgvUser?.image = newsList[indexPath.row].sendAccountImage.stringToUIImage()
            }
            cell.imgvPicture?.image = newsList[indexPath.row].newsPicture.stringToUIImage()
            cell.lbDescription?.text = newsList[indexPath.row].description
            cell.lbTitle?.text = newsList[indexPath.row].title
            cell.btnShowReply!.tag = indexPath.row
            cell.btnShowReply?.setTitle("查看全部 \(newsList[indexPath.row].replyCount) 則留言", for: .normal)
            cell.btnShowReply?.addTarget(self, action: #selector(clickShowReply), for: .touchUpInside)
            return cell
        }
    }
}

extension NewsViewController: LoadNewsDelegate {
    func loadNews() {
        callApiLoadNews(accountId: UserPreferences.shared.accountId)
    }
}

// MARK: - Protocol
