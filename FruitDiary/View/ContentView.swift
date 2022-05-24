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
    
    @State var showingAlert:Bool = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Daily Fruit")
                    .modifier(TextTitleModifier(isBold: true))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    openURL(URL(string: "https://iamwgo.com/waleerat-cv/")!)
                }, label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(kConfig.color.foreground)
                })
            }
            .padding()
            
            DashboardView()
                .environmentObject(weekCalendarVM)
                .environmentObject(dailyFruitVM)
                .onChange(of: (dailyFruitVM.apiResponse != nil) , perform: { newValue in
                    showingAlert = dailyFruitVM.apiResponseMessages.count > 0 ? true: false
                })
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(kConfig.message.error.alertTitle), message: Text(dailyFruitVM.getApiResponseMessagesToString() ?? ""), dismissButton: .default(Text(kConfig.message.error.okButton)))
                }
                
            Spacer()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
