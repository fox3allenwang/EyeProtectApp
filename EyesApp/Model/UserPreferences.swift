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
        
        // MARK: Apex Server
        
        case email
        
        case password
        
        case deviceToken

    }
    
    // MARK: - Variables
    
    var email: String {
        get { return userPreferences.string(forKey: UserPreference.email.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.email.rawValue) }
    }
    
    var password: String {
        get { return userPreferences.string(forKey: UserPreference.password.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.password.rawValue) }
    }
    
    var deviceToken: String {
        get { return userPreferences.string(forKey: UserPreference.deviceToken.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.deviceToken.rawValue) }
    }
    
    // MARK: - Reset Initial Flow Variables
    
    func resetInitialFlowVarables() {
        UserPreferences.shared.email = ""
        UserPreferences.shared.password = ""
        UserPreferences.shared.deviceToken = ""
    }
}
