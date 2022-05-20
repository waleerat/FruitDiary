//
//  DailyFruitView.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI
import Kingfisher

struct DailyFruitView: View {
    @EnvironmentObject var weekCalendarVM: WeekCalendarViewModel
    @EnvironmentObject var dailyFruitVM: DailyFruitViewModel
    
    @Binding var isEatenFruitFrom:Bool
    
    @State var isAddEntry:Bool = false
    @State var dailyEatenList: [FruitModel.MapView] = []
    @State var showDeleteEntryAlert: Bool = false
     
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if let _ = dailyFruitVM.getDailyItem(selectedDate: weekCalendarVM.selectedDate) {
                    IconButtonView(isActive: .constant(true),
                                   systemName: "plus",
                                   width: 25,
                                   height: 25,
                                   foreground: kConfig.color.foreground,
                                   buttonBackground: kConfig.color.buttonBackground
                    ) {
                        isEatenFruitFrom = true
                    }.halfSheet(showSheet: $isEatenFruitFrom) {
                        FruitEatenFormView(isEatenFruitFrom: $isEatenFruitFrom)
                            .environmentObject(weekCalendarVM)
                            .environmentObject(dailyFruitVM)
                    } onEnd: {
                        dailyFruitVM.updateDailyEaten(selectedDate: weekCalendarVM.selectedDate)
                    }
                    
                    if (dailyFruitVM.entryItems.count > 0) {
                        IconButtonView(isActive: .constant(true),
                                       systemName: "xmark.bin",
                                       width: 20,
                                       height: 25,
                                       foreground: kConfig.color.foreground,
                                       buttonBackground: kConfig.color.buttonBackground
                        ) {
                            showDeleteEntryAlert = true
                            isEatenFruitFrom = false
                            //let entryId = dailyFruitVM.getEntryIdByDate(selectedDate: weekCalendarVM.selectedDate)
                            //dailyFruitVM.removeEntriesById(entryId: entryId)
                        }
                        .confirmationDialog(
                            kConfig.message.deleteButton,
                            isPresented: $showDeleteEntryAlert
                        ) {
                            Button {
                                let entryId = dailyFruitVM.getEntryIdByDate(selectedDate: weekCalendarVM.selectedDate)
                                 dailyFruitVM.removeEntriesById(entryId: entryId)
                            } label: {
                                Text(kConfig.message.deleteButton)
                            }
                        }
                    }
                       
                } else {
                    
                    if weekCalendarVM.currentDate >= weekCalendarVM.selectedDate {
                        HStack {
                            IconButtonView(isActive: .constant(true),
                                           systemName: "plus",
                                           width: 25,
                                           height: 25,
                                           foreground: kConfig.color.foreground,
                                           buttonBackground: .clear
                            ) {
                                dailyFruitVM.addEntries(dateStr: weekCalendarVM.selectedDate)
                            }
                            
                            Text(kConfig.message.addNewEntry)
                                .modifier(TextTitleModifier())
                        }
                    }
                    
                    
                    
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                //if let _ = dailyFruitVM.getDailyEaten(selectedDate: weekCalendarVM.selectedDate) {
                ForEach(dailyFruitVM.getDailyEaten(selectedDate: weekCalendarVM.selectedDate)){ fruitItem in
                    
                    ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                        HStack(spacing: 10){
                            
                            KFImage(fruitItem.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: kScreen.width * 0.3, height: kScreen.width * 0.3)
                            
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(fruitItem.type)
                                    .modifier(TextTitleModifier(foregroundColor: .white, isBold: true))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack{
                                        Text("Eaten:")
                                            .modifier(TextDescriptionModifier(foregroundColor: .white))
                                        Text(String(fruitItem.amount))
                                            .modifier(TextTitleModifier(foregroundColor: .white, isBold: true))
                                        Text("Item")
                                            .modifier(TextDescriptionModifier(foregroundColor: .white))
                                    }
                                    
                                    HStack{
                                        Text("vitamins:")
                                            .modifier(TextDescriptionModifier(foregroundColor: .white))
                                        Text(String(fruitItem.vitamins))
                                            .modifier(TextTitleModifier(foregroundColor: .white, isBold: true))
                                        Text("per Item")
                                            .modifier(TextDescriptionModifier(foregroundColor: .white))
                                    }
                                    
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .onTapGesture {
                        dailyFruitVM.fruitId = fruitItem.id
                        dailyFruitVM.nrOfFruit = fruitItem.amount
                        isEatenFruitFrom.toggle()
                    }
                    .frame(width: kScreen.width * 0.9)
                    .background(kConfig.color.backgroundRevert)
                    .cornerRadius(20)
                    // shadow....
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
            }
            
            .padding(.horizontal)
            
        }
    }
}
