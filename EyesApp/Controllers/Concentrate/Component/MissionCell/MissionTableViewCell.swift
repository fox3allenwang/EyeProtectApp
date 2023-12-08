//
//  MissionTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/21.
//

import UIKit

class MissionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbProgress: UILabel!
    @IBOutlet weak var imgvCheck: UIImageView!
    
    // MARK: - Properties
    
    static let identifier = "MissionTableViewCell"
    
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
