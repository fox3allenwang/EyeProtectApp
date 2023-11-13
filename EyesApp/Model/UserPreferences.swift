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
        case userDeviceToken
        
        case deviceToken
        
        // 註冊日期
        case dor
        
        // 大頭貼
        case image
        
        case jwtToken
        
        case isoLowValue
        
        // 使用專注模式任務的 id
        case concentrateMissionId
        
        // 使用護眼操任務的 id
        case eyeExerciseMissionId
        
        // 使用光線充足使用專注模式任務的 id
        case lightEnvironmentConcentrateMissionId
        
        // 使用睡意偵測任務的 id
        case fatigueMissionId
        
        // 使用使用藍光檢測器並低於限制值任務的 id
        case blueLightMissionId

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
    
    var userDeviceToken: String {
        get { return userPreferences.string(forKey: UserPreference.userDeviceToken.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.userDeviceToken.rawValue)}
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
    
    var isoLowValue: Bool {
        get { return userPreferences.bool(forKey: UserPreference.isoLowValue.rawValue)}
        set { userPreferences.set(newValue, forKey: UserPreference.isoLowValue.rawValue)}
    }
    
    var concentrateMissionId: String {
        get { return userPreferences.string(forKey: UserPreference.concentrateMissionId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.concentrateMissionId.rawValue)}
    }
    
    var eyeExerciseMissionId: String {
        get { return userPreferences.string(forKey: UserPreference.eyeExerciseMissionId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.eyeExerciseMissionId.rawValue)}
    }
    
    var lightEnvironmentConcentrateMissionId: String {
        get { return userPreferences.string(forKey: UserPreference.lightEnvironmentConcentrateMissionId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.lightEnvironmentConcentrateMissionId.rawValue)}
    }
    
    var fatigueMissionId: String {
        get { return userPreferences.string(forKey: UserPreference.fatigueMissionId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.fatigueMissionId.rawValue)}
    }
    
    var blueLightMissionId: String {
        get { return userPreferences.string(forKey: UserPreference.blueLightMissionId.rawValue) ?? "" }
        set { userPreferences.set(newValue, forKey: UserPreference.blueLightMissionId.rawValue)}
    }
    
    // MARK: - Reset Initial Flow Variables
    
    func resetInitialFlowVarables() {
        UserPreferences.shared.accountId = ""
        UserPreferences.shared.name = ""
        UserPreferences.shared.email = ""
        UserPreferences.shared.password = ""
        UserPreferences.shared.userDeviceToken = ""
        UserPreferences.shared.dor = ""
        UserPreferences.shared.friendList = []
        UserPreferences.shared.image = ""
        UserPreferences.shared.jwtToken = ""
        UserPreferences.shared.concentrateMissionId = ""
        UserPreferences.shared.eyeExerciseMissionId = ""
        UserPreferences.shared.lightEnvironmentConcentrateMissionId = ""
        UserPreferences.shared.fatigueMissionId = ""
        UserPreferences.shared.blueLightMissionId = ""
    }
}
