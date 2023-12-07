//
//  ConcentrateTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/23.
//

import Lottie
import UIKit

class InviteFriendsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var vAnimate: UIView!
    @IBOutlet weak var btnAddInvite: UIButton!
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    // MARK: - Properties
    
    static let identifier = "InviteFriendsTableViewCell"
    
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
        imgvUser.layer.cornerRadius = (imgvUser?.frame.width)! / 2.1
        imgvUser.layer.borderWidth = 2
        imgvUser.layer.borderColor = UIColor.buttomColor?.cgColor
        btnAddInvite.imageView?.contentMode = .scaleAspectFit
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol


