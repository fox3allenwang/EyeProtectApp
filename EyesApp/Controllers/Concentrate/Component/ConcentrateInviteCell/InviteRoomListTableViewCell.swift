//
//  InviteRoomListTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import UIKit

class InviteRoomListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - Properties
    
    static let identifier = "InviteRoomListTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    fileprivate func setupUI() {
        imgvUser.layer.cornerRadius = imgvUser.frame.width / 2.1
        imgvUser.layer.borderWidth = 2
        imgvUser.layer.borderColor = UIColor.buttomColor.cgColor
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
