//
//  DailyFruitModel.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import Foundation 

// Note: - From API
struct FruitModel {
    
    struct Request: Encodable {
        var request: String
    }
    
    struct Response: Codable, Hashable {
        var id: Int
        var type: String
        var vitamins: Int
        var image: String
    }
}



struct FruitEatenListModel: Codable, Hashable {
    var id: String
    var type: String
    var vitamins: Int
    var eatenAmout: Int
    var image: String
}
