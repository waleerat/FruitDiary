//
//  JsonService.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-21.
//

import Foundation

class JSonService<T: Codable> {
    let storageKeyManager = StorageKeyManager()
    
    func encodeSingle(structData: T, forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(structData) {
            storageKeyManager.set(forKey, data: encoded)
        }
    }
    
    func decodeSingle(forKey: String) -> T? {
        if let encodedData = storageKeyManager.get(forKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(T.self, from: encodedData) {
                return loadedData
            }
        }
        return nil
    }
    
    func encodeArray(structData: [T], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(structData) {
            storageKeyManager.set(forKey, data: encoded)
        }
    }
    
    func decodeArray(forKey: String) -> [T]? {
        if let jsonData = storageKeyManager.get(forKey) as? Data { 
            let str = String(decoding: jsonData, as: UTF8.self)
            print(str)
            
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([T].self, from: jsonData)
                print(data)
                return data
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
}
