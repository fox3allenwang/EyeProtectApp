//
//  SocialViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/7/27.
//

import UIKit
import ProgressHUD

class SocialViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tbvFriendList: UITableView!
    
    
    // MARK: - Variables
    
    let manager = NetworkManager.shared
    
    private var friendListArray: [friendListInfo] = []
    
    private struct friendListInfo {
        var accountId: String
        var name: String
        var email: String
        var image: String
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SocialViewController")
        callApiFriendList()
        NotificationCenter.default.addObserver(self, selector: #selector(addFriend), name: .addFriend, object: nil)
       
        
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
       setupTbv()
    }
    
    func setupTbv() {
        tbvFriendList.register(UINib(nibName: "FriendListTableViewCell", bundle: nil),
                               forCellReuseIdentifier: FriendListTableViewCell.identified)
        tbvFriendList.dataSource = self
        tbvFriendList.delegate = self
    }
    
    @objc func addFriend() {
        callApiFriendList()
    }
    
    // MARK: - CallAPIFriendList
    
    func callApiFriendList() {
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        
        Task {
            let request = GetFriendListRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
                                               
            do {
                let result: GetFriendListResponse = try await manager.requestData(method: .post,
                                                                                  path: .getFriendList,
                                                                                  parameters: request,
                                                                                  needToken: true)
                friendListArray = []
                result.data.forEach { friendInfo in
                    if friendInfo.image == "未設置" {
                        friendListArray.append(friendListInfo(accountId: friendInfo.accountId, name: friendInfo.name, email: friendInfo.email, image: friendInfo.image))
                    } else {
                        friendListArray.append(friendListInfo(accountId: friendInfo.accountId, name: friendInfo.name, email: friendInfo.email, image: friendInfo.image))
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
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extension

extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvFriendList.dequeueReusableCell(withIdentifier: FriendListTableViewCell.identified, for: indexPath) as! FriendListTableViewCell
        if friendListArray[indexPath.row].image == "未設置" {
            cell.imgvAccountImage.image = UIImage(systemName: "person.fill")
        } else {
            cell.imgvAccountImage.image = friendListArray[indexPath.row].image.stringToUIImage()
        }
        
        cell.imgvAccountImage.contentMode = .scaleAspectFit
        cell.lbName.text = friendListArray[indexPath.row].name
        cell.lbEmail.text = friendListArray[indexPath.row].email
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = FriendPersonalViewController()
        nextView.userName = friendListArray[indexPath.row].name
        nextView.title = friendListArray[indexPath.row].name
        nextView.friendAccountId = friendListArray[indexPath.row].accountId
        if friendListArray[indexPath.row].image == "未設置" {
            nextView.userImage = UIImage(systemName: "person.fill")
        } else {
            nextView.userImage = friendListArray[indexPath.row].image.stringToUIImage()
        }
        var btn = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = btn
        navigationController?.pushViewController(nextView, animated: true)
    }
}

// MARK: - Protocol
