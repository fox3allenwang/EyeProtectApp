//
//  ReplyViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import ProgressHUD
import UIKit

class ReplyViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var txfReply: UITextField!
    @IBOutlet weak var tbvReply: UITableView!
    
    // MARK: - Properties
    
    var newsId: String = ""
    var replyList: [LoadNewsReplyResponse.ReplyItem] = []
    var editStatus = false
    var editStatusReplyId: String = ""
    weak var delegate: LoadNewsDelegate?
    
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
        Task {
            await callApiLoadNewsReply(newsId: newsId)
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
        Task {
            await delegate?.loadNews()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        setupTextField()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tbvReply.register(ReplyTableViewCell.loadFromNib(),
                          forCellReuseIdentifier: ReplyTableViewCell.identifier)
        tbvReply.estimatedRowHeight = 80
        tbvReply.rowHeight = UITableView.automaticDimension
        tbvReply.dataSource = self
        tbvReply.delegate = self
    }
    
    fileprivate func setupTextField() {
        txfReply.addTarget(self, action: #selector(returnToSendReply), for: .editingDidEndOnExit)
    }
    
    // MARK: - Call Backend RESTful API
    
    // MARK: AddNewsReply
    
    func callApiAddNewsReply(accountId: String,
                             newsId: String,
                             message: String,
                             time: String,
                             finish: (() -> Void)? = nil) {
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
                if result.message.isEqual(to: "傳送成功") {
                    finish?()
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
    }
    
    // MARK: LoadNewsReply
    
    func callApiLoadNewsReply(newsId: String) async {
        let request = LoadNewsReplyRequest(newsId: UUID(uuidString: newsId)!)
        do {
            let result: GeneralResponse<LoadNewsReplyResponse> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                             path: .loadNewsReply,
                                                                                                             parameters: request,
                                                                                                             needToken: true)
            if result.message.isEqual(to: "已找到留言") {
                replyList = result.data.replyList
                replyList.sort { firstReplyItem, secondReplyItem in
                    if firstReplyItem.time < secondReplyItem.time {
                        return true
                    } else {
                        return false
                    }
                }
                tbvReply.reloadData()
            } else if result.message.isEqual(to: "沒有留言") {
                
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
    
    // MARK: DeleteReply
    
    func callApiDeleteReply(replyId: String, finish: (() -> Void)? = nil) {
        let request = DeleteReplyRequest(replyId: UUID(uuidString: replyId)!)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .deleteReply,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                
                if result.message.isEqual(to: "刪除成功") {
                    finish?()
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
    }
    
    // MARK: EditReply
    
    func callApiEditReply(replyId: String,
                          message: String,
                          finish: (() -> Void)? = nil) {
        let request = EditNewsReplyRequest(replyId: UUID(uuidString: replyId)!, message: message)
        
        Task {
            do {
                let result: GeneralResponse<String> = try await NetworkManager.shared.requestData(method: .post,
                                                                                                  path: .editReply,
                                                                                                  parameters: request,
                                                                                                  needToken: true)
                if result.message.isEqual(to: "編輯成功") {
                    finish?()
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
    }
    
    // MARK: - IBAction
    
    @objc func returnToSendReply(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            if editStatus == true {
                editStatus = false
                ProgressHUD.colorAnimation = .buttomColor
                ProgressHUD.colorHUD = .themeColor
                ProgressHUD.animationType = .multipleCircleScaleRipple
                ProgressHUD.show("編輯中...")
                callApiEditReply(replyId: editStatusReplyId, message: text) {
                    Task {
                        await self.callApiLoadNewsReply(newsId: self.newsId)
                        await MainActor.run {
                            ProgressHUD.dismiss()
                        }
                    }
                }
                editStatusReplyId = ""
                sender.text = ""
            } else {
                let now = Formatter().convertDate(from: Date(), format: "yyyy-MM-dd HH:mm")
                callApiAddNewsReply(accountId: UserPreferences.shared.accountId,
                                    newsId: newsId,
                                    message: text,
                                    time: now) {
                    Task {
                        await self.callApiLoadNewsReply(newsId: self.newsId)
                        ProgressHUD.dismiss()
                    }
                }
                sender.text = ""
            }
        }
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        replyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReplyTableViewCell.identifier,
                                                       for: indexPath) as? ReplyTableViewCell else {
            fatalError("ReplyTableViewCell Load Failed")
        }
        if replyList[indexPath.row].accountImage.isEqual(to: "未設置") {
            cell.imgvUser.image = UIImage(systemIcon: .personFill)
        } else {
            cell.imgvUser.image = replyList[indexPath.row].accountImage.stringToUIImage()
        }
        cell.lbName.text = replyList[indexPath.row].accountName
        cell.lbMessage.text = replyList[indexPath.row].message
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        if replyList[indexPath.row].accountId.isEqual(to: UUID(uuidString: UserPreferences.shared.accountId)) {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (suggestedActions) -> UIMenu? in
                let takeBackAction = UIAction(title: "收回", attributes: .init(), state: .off) { _ in
                    self.callApiDeleteReply(replyId: self.replyList[indexPath.row].replyId.uuidString) {
                        ProgressHUD.colorAnimation = .buttomColor
                        ProgressHUD.colorHUD = .themeColor
                        ProgressHUD.animationType = .multipleCircleScaleRipple
                        ProgressHUD.show("載入中...")
                        Task {
                            await self.callApiLoadNewsReply(newsId: self.newsId)
                            await self.callApiLoadNewsReply(newsId: self.newsId)
                            await MainActor.run {
                                ProgressHUD.dismiss()
                            }
                        }
                    }
                }
                let copyAction = UIAction(title: "複製", attributes: .init(), state: .off) { _ in
                    let pastboard = UIPasteboard.general
                    pastboard.string = self.replyList[indexPath.row].message
                }
                let editAction = UIAction(title: "編輯", attributes: .init(), state: .off) { _ in
                    self.editStatus = true
                    self.editStatusReplyId = self.replyList[indexPath.row].replyId.uuidString
                    self.txfReply.text = self.replyList[indexPath.row].message
                    self.txfReply.becomeFirstResponder()
                }
                return UIMenu(title: "",
                              options: .displayInline,
                              children: [takeBackAction, copyAction, editAction])
            }
        } else {
            return UIContextMenuConfiguration()
        }
    }
}

// MARK: - LoadNewsDelegate

protocol LoadNewsDelegate: NSObjectProtocol {
    
    func loadNews() async
}
