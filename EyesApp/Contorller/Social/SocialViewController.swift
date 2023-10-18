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
    
    let manager = NetworkManager()
    
    var friendListArray: [friendListInfo] = []
    
    struct friendListInfo {
        var accountId: String
        var name: String
        var email: String
        var image: UIImage
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SocialViewController")
        ProgressHUD.colorAnimation = .buttomColor!
        ProgressHUD.colorHUD = .themeColor!
        ProgressHUD.animationType = .multipleCircleScaleRipple
        ProgressHUD.show("載入中...")
        callApiFriendList()
        
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
    
    // MARK: - CallAPIFriendList
    
    func callApiFriendList() {
        friendListArray = []
        Task {
            let request = GetFriendListRequest(accountId: UUID(uuidString: UserPreferences.shared.accountId)!)
                                               
            do {
                let result: GetFriendListResponse = try await manager.requestData(method: .post,
                                                                                  path: .getFriendList,
                                                                                  parameters: request,
                                                                                  needToken: true)
                result.data.forEach { friendInfo in
                    friendListArray.append(friendListInfo(accountId: friendInfo.accountId, name: friendInfo.name, email: friendInfo.email, image: friendInfo.image.stringToUIImage()))
                }
                tbvFriendList.reloadData()
                print(friendListArray.count)
            } catch {
                print(error)
            }
            ProgressHUD.dismiss()
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
        cell.imgvAccountImage.image = friendListArray[indexPath.row].image
        cell.imgvAccountImage.contentMode = .scaleAspectFit
        cell.lbName.text = friendListArray[indexPath.row].name
        cell.lbEmail.text = friendListArray[indexPath.row].email
        return cell
    }


}

// MARK: - Protocol
