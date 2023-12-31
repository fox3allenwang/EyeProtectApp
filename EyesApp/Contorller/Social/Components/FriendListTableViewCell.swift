//
//  FriendListTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/27.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgvAccountImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var vCustomView: UIView!
    
    // MARK: - Variables
    
    static let identified = "FriendListTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vCustomView.layer.cornerRadius = 20
//        vCustomView.layer.borderColor = UIColor.buttomColor?.cgColor
//        vCustomView.layer.borderWidth = 5
        vCustomView.layer.shadowOffset = CGSize(width: 5, height: 0)
        vCustomView?.layer.shadowOpacity = 0.2

        vCustomView?.layer.shadowRadius = 10
        vCustomView.alpha = 0.5
        imgvAccountImage.layer.cornerRadius = imgvAccountImage.frame.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
