//
//  JsonService.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-21.
//

import Foundation

class JSonService<T: Codable, R: Codable> {
    let storageKeyManager = StorageKeyManager()
    
    func encodeSingle(structData: T, forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(structData) {
            storageKeyManager.set(forKey, data: encoded)
        }
    }
    
    func decodeSingle(forKey: String) -> R? {
        if let encodedData = storageKeyManager.get(forKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(R.self, from: encodedData) {
                return loadedData
            }
        }
        return nil
    }
    
    func encodeArray(structData: [T], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(structData) {
            print(encoded)
            storageKeyManager.set(forKey, data: encoded)
        }
    }
    
    func decodeArray(forKey: String) -> [R]? {
        if let jsonData = storageKeyManager.get(forKey) as? Data { 
            let str = String(decoding: jsonData, as: UTF8.self)
            print(str)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
               //     let res = try decoder.decode(Root.self, from: data)
            do {
                let data = try decoder.decode([R].self, from: jsonData)
                print(data)
                 
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        return nil
    }
    
}


extension Bundle {
  func decode<T: Codable>(_ file: String) -> T {
    // 1. Locate the json file
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate \(file) in bundle.")
    }
    
    // 2. Create a property for the data
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Failed to load \(file) from bundle.")
    }
    
    // 3. Create a decoder
    let decoder = JSONDecoder()
    
    // 4. Create a property for the decoded data
    guard let loaded = try? decoder.decode(T.self, from: data) else {
      fatalError("Failed to decode \(file) from bundle.")
    }
    
    // 5. Return the ready-to-use data
    return loaded
  }
}


