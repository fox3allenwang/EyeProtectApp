//
//  AnserConcentrateInviteViewController.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/10/25.
//

import UIKit

class AnserConcentrateInviteViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vInvite: UIView?
    @IBOutlet weak var lbInviteMessage: UILabel?
    @IBOutlet weak var btnAccept: UIButton?
    @IBOutlet weak var btnCancel: UIButton?
    
    // MARK: - Variables
    
    var message = ""
    var inviteRoomId = ""
    var sendName = ""
    var inviteAcceptDelegate: InviteAcceptDelegate?
    var inviteCancelDelegate: InviteCancelDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        lbInviteMessage?.text = message
        setupInviteView()
    }
    
    func setupInviteView() {
        vInvite!.layer.cornerRadius = 50
        vInvite!.layer.shadowOffset = .zero
        vInvite!.layer.shadowRadius = 10
        vInvite!.layer.shadowOpacity = 0.2
    }
    
    // MARK: - IBAction
    @IBAction func clickAcceptButton() {
        inviteAcceptDelegate?.inviteAccept()
    }
    
    @IBAction func clickCancelButtom() {
        inviteCancelDelegate?.inviteCancel()
    }
}

// MARK: - Extension

// MARK: - Protocol

protocol InviteAcceptDelegate {
    func inviteAccept()
}

protocol InviteCancelDelegate {
    func inviteCancel()
}

