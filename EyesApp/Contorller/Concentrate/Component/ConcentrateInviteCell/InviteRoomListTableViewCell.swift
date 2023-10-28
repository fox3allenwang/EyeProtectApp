//
//  InviteRoomListTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/28.
//

import UIKit

class InviteRoomListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView?
    @IBOutlet weak var name: UILabel?
    
    // MARK: - Variables
    
    static let identified = "InviteRoomListTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvUser!.layer.cornerRadius = (imgvUser?.frame.width)! / 2.1
        imgvUser!.layer.borderWidth = 2
        imgvUser!.layer.borderColor = UIColor.buttomColor?.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
