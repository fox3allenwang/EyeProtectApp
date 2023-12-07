//
//  ReplyViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import UIKit
import ProgressHUD

class ReplyViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var txfReply: UITextField?
    @IBOutlet weak var tbvReply: UITableView?
    
    // MARK: - Variables
    var newsId: String = ""
    var replyList: [LoadNewsReplyResponse.ReplyItem] = []
    var editStatus = false
    var editStatusReplyId: String = ""
    var loadNewsDelegate: LoadNewsDelegate?
    
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
        callApiLoadNewsReply(newsId: newsId) {
            ProgressHUD.dismiss()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadNewsDelegate?.loadNews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        setupTextField()
        setupTableView()
    }
    
    func setupTableView() {
        tbvReply?.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: ReplyTableViewCell.identified)
        tbvReply!.estimatedRowHeight = 80
        tbvReply!.rowHeight = UITableView.automaticDimension
        tbvReply?.dataSource = self
        tbvReply?.delegate = self
    }
    
    func setupTextField() {
        txfReply!.addTarget(self, action: #selector(returnToSendReply), for: .editingDidEndOnExit)
    }
    
    // MARK: - callAPIAddNewsReply
    
    func callAPIAddNewsReply(accountId: String,
                             newsId: String,
                             message: String,
                             time: String,
                             completionHandler: (() -> Void)? = nil) {
        let request = AddNewsReplyRequest(accountId: UUID(uuidString: accountId)!,
                                          newsId: UUID(uuidString: newsId)!,
                                          message: message,
                                          time: time)
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                             path: .addNewsReply,
                                                                                             parameters: request,
                                                                                             needToken: true)
                if result.message == "傳送成功" {
                    completionHandler?()
                } else {
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPILoadNewsReply
    
    func callApiLoadNewsReply(newsId: String ,
                              completionHandler: (() -> Void)? = nil) {
        let request = LoadNewsReplyRequest(newsId: UUID(uuidString: newsId)!)
        
        Task {
            do {
                let result: GeneralResponse<LoadNewsReplyResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                            path: .loadNewsReply,
                                                                                                            parameters: request,
                                                                                                            needToken: true)
                
                if result.message == "已找到留言" {
                    replyList = result.data.replyList
                    replyList.sort { firstReplyItem, secondReplyItem in
                        if firstReplyItem.time < secondReplyItem.time {
                            return true
                        } else {
                            return false
                        }
                    }
                    tbvReply?.reloadData()
                    completionHandler?()
                } else if result.message == "沒有留言"{
                    completionHandler?()
                } else {
                    completionHandler?()
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                completionHandler?()
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPIDeleteReply
    
    func callApiDeleteReply(replyId: String,
                            completionHandler: (() -> Void)? = nil) {
        let request = DeleteReplyRequest(replyId: UUID(uuidString: replyId)!)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post, path: .deleteReply, parameters: request, needToken: true)
                
                if result.message == "刪除成功" {
                    completionHandler?()
                } else {
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - callAPIEditReply
    
    func callApiEditReply(replyId: String,
                          message: String,
                          completionHandler: (() -> Void)? = nil) {
        let request = EditNewsReplyRequest(replyId: UUID(uuidString: replyId)!,
                                           message: message)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post, path: .editReply, parameters: request, needToken: true)
                
                if result.message == "編輯成功" {
                    completionHandler?()
                } else {
                    Alert.showAlert(title: "錯誤", message: result.message, vc: self, confirmTitle: "確認")
                }
            } catch {
                print(error)
                Alert.showAlert(title: "錯誤", message: "\(error)", vc: self, confirmTitle: "確認")
            }
        }
    }
    
    // MARK: - IBAction
    
    @objc func returnToSendReply(_ sender: UITextField) {
        if editStatus == true {
            editStatus = false
            if txfReply?.text != "" {
                ProgressHUD.colorAnimation = .buttomColor!
                ProgressHUD.colorHUD = .themeColor!
                ProgressHUD.animationType = .multipleCircleScaleRipple
                ProgressHUD.show("編輯中...")
                callApiEditReply(replyId: editStatusReplyId, message: (txfReply?.text)!) {
                    self.callApiLoadNewsReply(newsId: self.newsId) {
                        ProgressHUD.dismiss()
                    }
                }
                editStatusReplyId = ""
                txfReply?.text = ""
            }
        } else {
            if txfReply?.text != "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let now = dateFormatter.string(from: Date())
                callAPIAddNewsReply(accountId: UserPreferences.shared.accountId,
                                    newsId: newsId,
                                    message: (txfReply?.text)!,
                                    time: now) {
                    self.callApiLoadNewsReply(newsId: self.newsId) {
                        ProgressHUD.dismiss()
                    }
                }
                txfReply?.text = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if replyList[indexPath.row].accountId ==
            UUID(uuidString: UserPreferences.shared.accountId) {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
                
                let action1 = UIAction(title: "收回", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off) { (action) in
                    self.callApiDeleteReply(replyId: self.replyList[indexPath.row].replyId.uuidString) {
                        ProgressHUD.colorAnimation = .buttomColor!
                        ProgressHUD.colorHUD = .themeColor!
                        ProgressHUD.animationType = .multipleCircleScaleRipple
                        ProgressHUD.show("載入中...")
                        self.callApiLoadNewsReply(newsId: self.newsId) {
                            self.callApiLoadNewsReply(newsId: self.newsId) {
                                ProgressHUD.dismiss()
                            }
                        }
                    }
                }
                let action2 = UIAction(title: "複製", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off) { (action) in
                    let pastboard = UIPasteboard.general
                    pastboard.string = self.replyList[indexPath.row].message
                }
                let action3 = UIAction(title: "編輯", image: nil, identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off) { (action) in
                    self.editStatus = true
                    self.editStatusReplyId = self.replyList[indexPath.row].replyId.uuidString
                    self.txfReply?.text = self.replyList[indexPath.row].message
                    self.txfReply?.becomeFirstResponder()
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [action1, action2, action3])
            }
        } else {
            return UIContextMenuConfiguration()
        }
    }
}

// MARK: - Extension

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        replyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReplyTableViewCell.identified, for: indexPath) as! ReplyTableViewCell
        if replyList[indexPath.row].accountImage == "未設置" {
            cell.imgvUser?.image = UIImage(systemName: "person.fill")
        } else {
            cell.imgvUser?.image = replyList[indexPath.row].accountImage.stringToUIImage()
        }
        cell.lbName?.text = replyList[indexPath.row].accountName
        cell.lbMessage?.text = replyList[indexPath.row].message
        cell.tag = indexPath.row
        return cell
    }
}



// MARK: - Protocol

protocol LoadNewsDelegate {
    func loadNews()
}

