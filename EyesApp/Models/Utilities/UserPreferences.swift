//
//  UserPreferences.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/9/11.
//

import Foundation

class UserPreferences {
    
    static let shared = UserPreferences()
    
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    enum Keys: String {
        
        /// 帳號編號
        case accountId
        
        case name
        
        case email
        
        case password
        
        /// 遠端推播裝置的 token
        case userDeviceToken
        
        case deviceToken
        
        /// 註冊日期
        case dor
        
        /// 大頭貼
        case image
        
        case jwtToken
        
        case isoLowValue
        
        /// 使用專注模式任務的 id
        case concentrateMissionId
        
        /// 使用護眼操任務的 id
        case eyeExerciseMissionId
        
        /// 使用光線充足使用專注模式任務的 id
        case lightEnvironmentConcentrateMissionId
        
        /// 使用睡意偵測任務的 id
        case fatigueMissionId
        
        /// 使用使用藍光檢測器並低於限制值任務的 id
        case blueLightMissionId

    }
    
    // MARK: - Properties
    
    var accountId: String {
        get { return userDefaults.string(forKey: Keys.accountId.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.accountId.rawValue)}
    }
    
    var name: String {
        get { return userDefaults.string(forKey: Keys.name.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.name.rawValue)}
    }
    
    var email: String {
        get { return userDefaults.string(forKey: Keys.email.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.email.rawValue)}
    }
    
    var password: String {
        get { return userDefaults.string(forKey: Keys.password.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.password.rawValue)}
    }
    
    var userDeviceToken: String {
        get { return userDefaults.string(forKey: Keys.userDeviceToken.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.userDeviceToken.rawValue)}
    }
    
    var deviceToken: String {
        get { return userDefaults.string(forKey: Keys.deviceToken.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.deviceToken.rawValue)}
    }
    
    var dor: String {
        get { return userDefaults.string(forKey: Keys.dor.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.dor.rawValue)}
    }
    
    var image: String {
        get { return userDefaults.string(forKey: Keys.image.rawValue) ?? ""}
        set { userDefaults.set(newValue, forKey: Keys.image.rawValue)}
    }
    
    var friendList: [String] {
        get { return userDefaults.stringArray(forKey: Keys.image.rawValue) ?? []}
        set { userDefaults.set(newValue, forKey: Keys.image.rawValue)}
    }
    
    var jwtToken: String {
        get { return userDefaults.string(forKey: Keys.jwtToken.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.jwtToken.rawValue)}
    }
    
    var isoLowValue: Bool {
        get { return userDefaults.bool(forKey: Keys.isoLowValue.rawValue)}
        set { userDefaults.set(newValue, forKey: Keys.isoLowValue.rawValue)}
    }
    
    var concentrateMissionId: String {
        get { return userDefaults.string(forKey: Keys.concentrateMissionId.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.concentrateMissionId.rawValue)}
    }
    
    var eyeExerciseMissionId: String {
        get { return userDefaults.string(forKey: Keys.eyeExerciseMissionId.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.eyeExerciseMissionId.rawValue)}
    }
    
    var lightEnvironmentConcentrateMissionId: String {
        get { return userDefaults.string(forKey: Keys.lightEnvironmentConcentrateMissionId.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.lightEnvironmentConcentrateMissionId.rawValue)}
    }
    
    var fatigueMissionId: String {
        get { return userDefaults.string(forKey: Keys.fatigueMissionId.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.fatigueMissionId.rawValue)}
    }
    
    var blueLightMissionId: String {
        get { return userDefaults.string(forKey: Keys.blueLightMissionId.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.blueLightMissionId.rawValue)}
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
