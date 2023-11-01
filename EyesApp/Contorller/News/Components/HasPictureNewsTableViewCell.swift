//
//  HasPictureNewsTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/1.
//

import UIKit

class HasPictureNewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var imgvPicture: UIImageView?
    @IBOutlet weak var vPictureBackground: UIView?
    @IBOutlet weak var btnShowReply: UIButton?
    
    // MARK: - Variables
    
    static let identified = "HasPictureNewsTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
