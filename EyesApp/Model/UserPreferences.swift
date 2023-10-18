//
//  UserPreferences.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/11.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    
    private let userPreferences: UserDefaults
    
    private init() {
        userPreferences = UserDefaults.standard
    }
    
    enum UserPreference: String {
        
        // 帳號編號
        case accountId
        
        case name
        
        case email
        
        case password
        
        // 遠端推播裝置的 token
        case deviceToken
        
        // 註冊日期
        case dor
        
        // 大頭貼
        case image
        
        case jwtToken

    }
    
    // MARK: - Variables
    
    var accountId: String {
        get { return userPreferences.string(forKey: UserPreference.accountId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.accountId.rawValue)}
    }
    
    var name: String {
        get { return userPreferences.string(forKey: UserPreference.name.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.name.rawValue)}
    }
    
    var email: String {
        get { return userPreferences.string(forKey: UserPreference.email.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.email.rawValue)}
    }
    
    var password: String {
        get { return userPreferences.string(forKey: UserPreference.password.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.password.rawValue)}
    }
    
    var deviceToken: String {
        get { return userPreferences.string(forKey: UserPreference.deviceToken.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.deviceToken.rawValue)}
    }
    
    var dor: String {
        get { return userPreferences.string(forKey: UserPreference.dor.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.dor.rawValue)}
    }
    
    var image: String {
        get { return userPreferences.string(forKey: UserPreference.image.rawValue) ?? ""}
        set { userPreferences.set(newValue, forKey: UserPreference.image.rawValue)}
    }
    
    var friendList: [String] {
        get { return userPreferences.stringArray(forKey: UserPreference.image.rawValue) ?? []}
        set { userPreferences.set(newValue, forKey: UserPreference.image.rawValue)}
    }
    
    var jwtToken: String {
        get { return userPreferences.string(forKey: UserPreference.jwtToken.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.jwtToken.rawValue)}
    }
    
    // MARK: - Reset Initial Flow Variables
    
    func resetInitialFlowVarables() {
        UserPreferences.shared.accountId = ""
        UserPreferences.shared.name = ""
        UserPreferences.shared.email = ""
        UserPreferences.shared.password = ""
        UserPreferences.shared.deviceToken = ""
        UserPreferences.shared.dor = ""
        UserPreferences.shared.friendList = []
        UserPreferences.shared.image = ""
        UserPreferences.shared.jwtToken = ""
    }
}
