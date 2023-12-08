//
//  SocialViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import ProgressHUD
import UIKit

class SocialViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvFriendList: UITableView!
    
    // MARK: - Properties
    
    private var friendListArray: [FriendListInfo] = []
    
    private struct FriendListInfo {
        
        let accountId: String
        
        let name: String
        
        let email: String
        
        let image: String
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SocialViewController")
        addFriend()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addFriend),
                                               name: .addFriend,
                                               object: nil)
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
    
    fileprivate func setupUI() {
        setupTbv()
    }
    
    fileprivate func setupTbv() {
        tbvFriendList.register(FriendListTableViewCell.loadFromNib(),
                               forCellReuseIdentifier: FriendListTableViewCell.identifier)
        tbvFriendList.dataSource = self
        tbvFriendList.delegate = self
    }
    
    @objc func addFriend() {
        Task {
            await callApiFriendList()
        }
    }
    
    // MARK: - CallAPIFriendList
    
    func callApiFriendList() async {
        ProgressHUD.colorAnimation = .buttomColor
        ProgressHUD.colorHUD = .themeColor
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        
        let request = GetFriendListRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
        
        do {
            let result: GetFriendListResponse = try await NetworkManager.shared.requestData(method: .post,
                                                                                            path: .getFriendList,
                                                                                            parameters: request,
                                                                                            needToken: true)
            friendListArray = []
            result.data.forEach { friendInfo in
                if friendInfo.image.isEqual(to: "未設置") {
                    friendListArray.append(FriendListInfo(accountId: friendInfo.accountId,
                                                          name: friendInfo.name,
                                                          email: friendInfo.email,
                                                          image: friendInfo.image))
                } else {
                    friendListArray.append(FriendListInfo(accountId: friendInfo.accountId,
                                                          name: friendInfo.name,
                                                          email: friendInfo.email,
                                                          image: friendInfo.image))
                }
            }
            tbvFriendList.reloadData()
            ProgressHUD.dismiss()
            print(friendListArray.count)
        } catch {
            print(error)
            ProgressHUD.dismiss()
        }
        
    }
    
    // MARK: - IBAction
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendListTableViewCell.identifier,
                                                       for: indexPath) as? FriendListTableViewCell else {
            fatalError("FriendListTableViewCell Load Failed")
        }
        if friendListArray[indexPath.row].image.isEqual(to: "未設置") {
            cell.imgvAccountImage.image = UIImage(systemIcon: .personFill)
        } else {
            cell.imgvAccountImage.image = friendListArray[indexPath.row].image.stringToUIImage()
        }
        
        cell.imgvAccountImage.contentMode = .scaleAspectFit
        cell.lbName.text = friendListArray[indexPath.row].name
        cell.lbEmail.text = friendListArray[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = FriendPersonalViewController()
        nextVC.userName = friendListArray[indexPath.row].name
        nextVC.title = friendListArray[indexPath.row].name
        nextVC.friendAccountId = friendListArray[indexPath.row].accountId
        if friendListArray[indexPath.row].image.isEqual(to: "未設置") {
            nextVC.userImage = UIImage(systemIcon: .personFill)
        } else {
            nextVC.userImage = friendListArray[indexPath.row].image.stringToUIImage()
        }
        var btn = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btn
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - Protocol
