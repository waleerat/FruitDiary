//
//  ContentView.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var weekCalendarVM: WeekCalendarViewModel
    @StateObject var dailyFruitVM = DailyFruitViewModel()
    
    @State var isEatenFruitFrom:Bool = false
    
    var body: some View {
        VStack{
            HStack{
                
                Text("Daily Fruit")
                    .modifier(TextTitleModifier(isBold: true))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    openURL(URL(string: "https://https://iamwgo.com/waleerat-cv/")!)
                }, label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(kConfig.color.foreground)
                })
            }
            .padding()
            
            DashboardView(isEatenFruitFrom: $isEatenFruitFrom)
                .environmentObject(weekCalendarVM)
                .environmentObject(dailyFruitVM)
                
            Spacer()
        }
        
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
