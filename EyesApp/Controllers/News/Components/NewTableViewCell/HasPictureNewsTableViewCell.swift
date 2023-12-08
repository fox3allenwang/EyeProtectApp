//
//  HasPictureNewsTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/1.
//

import UIKit

class HasPictureNewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var imgvPicture: UIImageView!
    @IBOutlet weak var vPictureBackground: UIView!
    @IBOutlet weak var btnShowReply: UIButton!
    
    // MARK: - Properties
    
    static let identifier = "HasPictureNewsTableViewCell"
    
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
        setupImageView()
        setupPictureBackground()
    }
    
    fileprivate func setupImageView() {
        imgvUser.layer.cornerRadius = imgvUser.frame.width / 2
        imgvUser.layer.borderWidth = 1
        imgvUser.layer.borderColor = UIColor.buttomColor.cgColor
    }
    
    fileprivate func setupPictureBackground() {
        vPictureBackground.layer.cornerRadius = 20
        vPictureBackground.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        vPictureBackground.layer.shadowOpacity = 0.1
        vPictureBackground.layer.shadowRadius = 20
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
