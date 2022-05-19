//
//  iconButtonModifier.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

struct TextHeaderModifier: ViewModifier {
    @State var foregroundColor:Color = kConfig.color.foreground
    @State var isBold:Bool = false
    func body(content: Content) -> some View {
    content
        .font(.system(size: isIpad() ? 40 : 25 ,weight: isBold ? .bold : .regular, design: .rounded))
        .lineLimit(nil)
        .multilineTextAlignment(.leading)
        .foregroundColor(foregroundColor)
    }
}

struct TextTitleModifier: ViewModifier {
    @State var foregroundColor:Color = kConfig.color.foreground
    @State var isBold:Bool = false
    func body(content: Content) -> some View {
    content
        .font(.system(size: isIpad() ? 35 : 22 ,weight: isBold ? .bold : .regular, design: .rounded))
        .lineLimit(nil)
        .multilineTextAlignment(.leading)
        .foregroundColor(foregroundColor)
    }
}

struct TextDescriptionModifier: ViewModifier {
    @State var foregroundColor:Color = kConfig.color.foreground
    @State var isBold:Bool = false
    func body(content: Content) -> some View {
    content
        .font(.system(size: isIpad() ? 20 : 14 ,weight: isBold ? .bold : .regular, design: .rounded))
        .lineLimit(nil)
        .multilineTextAlignment(.leading)
        .foregroundColor(foregroundColor)
    }
}

struct ArrowModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(kConfig.color.buttonForeground)
            .background(kConfig.color.buttonBackground)
            .clipShape(Capsule())
    }
}
