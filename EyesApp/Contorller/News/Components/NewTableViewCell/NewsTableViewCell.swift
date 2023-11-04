//
//  NewsTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/4.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvUser: UIImageView?
    @IBOutlet weak var lbTitle: UILabel?
    @IBOutlet weak var lbDescription: UILabel?
    @IBOutlet weak var btnShowReply: UIButton?
    
    // MARK: - Variables
    
    static let identified = "NewsTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgvUser!.layer.cornerRadius = imgvUser!.frame.width / 2
        imgvUser!.layer.borderWidth = 1
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
