//
//  MemberTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/20.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    // MARK: - Variables
    
    static let identifier = "MemberTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvUser.layer.cornerRadius = 17
        imgvUser.layer.borderWidth = 1
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
