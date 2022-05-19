//
//  Constant.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

public let kScreen = UIScreen.main.bounds

struct kConfig {
    struct color {
        static let backgroundHex: String = "#E8F9FD"
        static let foregroundHex: String = "#000000"
       
        static let background: Color = Color("background")
        static let foreground: Color = Color("foreground")
        static let backgroundRevert: Color = Color("foreground")
        static let foregroundRevert: Color = Color("background")
        static let currentDateBackground =  Color.yellow
        static let buttonBackground = Color.yellow
        static let buttonForeground = Color("background")
        
        
    }
    
    struct error {
        static let errorRequest: String = "Something went wrong"
        static let errorDefault: String = "Something went wrong"
    }
}
