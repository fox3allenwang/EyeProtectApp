//
//  PersonalTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/8/20.
//

import UIKit

class PersonalTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var title: UILabel!
    
    // MARK: - Properties
    
    static let identifier = "PersonalTableViewCell"
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
