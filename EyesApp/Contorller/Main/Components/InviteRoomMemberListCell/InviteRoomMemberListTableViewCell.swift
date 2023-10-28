//
//  InviteRoomMemberListTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import UIKit

class InviteRoomMemberListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    // MARK: - Variables
    
    static let identified = "InviteRoomMemberListTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvUser.layer.cornerRadius = imgvUser.frame.height / 2.1
        imgvUser.layer.borderWidth = 3
        imgvUser.layer.borderColor = UIColor.buttomColor?.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
