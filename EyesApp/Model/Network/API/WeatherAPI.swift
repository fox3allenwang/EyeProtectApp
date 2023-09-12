//
//  WeatherAPI.swift
//  EyesApp
//
//  Created by imac-3570 on 2023/8/12.
//

import Foundation

struct Weather : Decodable {
    let success: String
    var result: Result_struct
    var records : records
}

struct Result_struct: Decodable {
    var resource_id: String
    var fields: [Fields]
    
    struct Fields: Decodable {
        var id: String
        var type: String
    }
}

struct records : Decodable {
    var datasetDescription : String
    var location : [location]
}

struct location : Decodable {
    var locationName : String
    var weatherElement : [weatherElement]
}

struct weatherElement : Decodable {
    var elementName : String
    var time : [time]
}

struct time : Decodable {
    var startTime : String
    var endTime : String
    var parameter : parameter
}

struct parameter : Decodable {
    var parameterName : String
    var parameterValue : String?
    var parameterUnit : String?
}

struct WeatherRequest: Codable {
    var Authorization: String = "CWB-1CB6C4A9-3617-4CA1-A0A9-D85CB53FE187"
}
