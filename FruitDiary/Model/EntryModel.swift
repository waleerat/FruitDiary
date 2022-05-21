//
//  EntryModel.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import Foundation

struct EntriesModel {
    
    struct Request: Codable {
        var date: String
    }
    
    struct ApiResponse: Codable, Hashable {
        var code: Int
        var message: String
    }
    
    struct Response: Codable, Hashable {
        var id: Int?
        var date: String?
        var fruit: [FruitModel.Bundle]?
        var code: Int?
        var message: String?
    }
    
    struct MapView: Identifiable, Codable {
        var id: Int
        var date: String
        var fruit: [FruitModel.MapView]?
    }
}


/*
 var dictionary: [String: Any] {
     return [
         "id": id,
         "date": date,
         "fruit": ["test": "test"]
     ]
 }
 var nsDictionary: NSDictionary {
     return dictionary as NSDictionary
 }
 */
