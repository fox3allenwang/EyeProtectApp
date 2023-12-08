//
//  ConcentrateRecordTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/11/5.
//

import UIKit

class ConcentrateRecordTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imgvStatus: UIImageView!
    @IBOutlet weak var vStatusCircle: UIView!
    @IBOutlet weak var vStatusStrip: UIView!
    @IBOutlet weak var lbConcentrateRecord: UILabel!
    @IBOutlet weak var lbConcentrateTime: UILabel!
    @IBOutlet weak var lbConcentrateWith: UILabel!
    
    // MARK: - Properties
    
    static let identifier = "ConcentrateRecordTableViewCell"
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vStatusCircle.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
