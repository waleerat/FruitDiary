//
//  DailyFruitModel.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import Foundation 

// Note: - From API
struct FruitModel {
    
    struct Bundle: Codable, Hashable {
        var fruitId: Int
        var fruitType: String
        var amount: Int
    }
    
    struct Request: Encodable {
        var request: String
    }
    
    struct Response: Codable, Hashable {
        var id: Int
        var type: String
        var vitamins: Int
        var image: String
    }
    
    struct MapView: Identifiable, Codable{
        var id: Int
        var type: String
        var vitamins: Int
        var amount: Int
        var image: String
    }
}

/*
 var dictionary: [String: Any] {
     return [
         "id": id,
         "type": type,
         "vitamins": vitamins,
         "amount": amount,
         "image": image ?? "" as String
     ]
 }
 var nsDictionary: NSDictionary {
     return dictionary as NSDictionary
 }
 */
