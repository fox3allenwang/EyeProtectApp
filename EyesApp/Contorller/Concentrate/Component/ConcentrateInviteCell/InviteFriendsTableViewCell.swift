//
//  ConcentrateTableViewCell.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/23.
//

import UIKit
import Lottie

class InviteFriendsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vAnimate: UIView?
    @IBOutlet weak var btnAddInvite: UIButton?
    @IBOutlet weak var imgvUser: UIImageView?
    @IBOutlet weak var lbName: UILabel?
    
    // MARK: - Variables
    
    static let identified = "InviteFriendsTableViewCell"
    
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setupAnimate()
        imgvUser!.layer.cornerRadius = (imgvUser?.frame.width)! / 2.1
        imgvUser!.layer.borderWidth = 2
        imgvUser!.layer.borderColor = UIColor.buttomColor?.cgColor
        btnAddInvite?.imageView?.contentMode = .scaleAspectFit
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func setupAnimate() {
//        let vStartLoading = LottieAnimationView(name: "loadingInvite")
//        vStartLoading.contentMode = .scaleAspectFill
//        vStartLoading.frame = CGRect(x: 0,
//                                   y: 0,
//                                   width: CGFloat((vAnimate?.frame.width)!),
//                                   height: CGFloat((vAnimate?.frame.height)!))
//        vStartLoading.center = CGPoint(x: (vAnimate?.frame.width)!,
//                                       y: (vAnimate?.frame.width)! * 0.45)
//        vStartLoading.loopMode = .loop
//        vStartLoading.animationSpeed = 1
//        vAnimate!.addSubview(vStartLoading)
//        vStartLoading.play()
//    }
    
    // MARK: - UI Settings
    
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol
