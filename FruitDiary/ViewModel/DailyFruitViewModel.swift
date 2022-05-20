//
//  DailyFruitViewModel.swift
//  FruitDiary
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI
import Combine
import Alamofire

class DailyFruitViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    @Published var fruitItems: [FruitModel.Response] = []
    @Published var entryItems: [EntriesModel.MapView] = []
    @Published var fruitEatenPerDay: [FruitModel.MapView] = []
    
    @Published var apiResponse: EntriesModel.ApiResponse?
    @Published var addedResponse: EntriesModel.Response?
    
    //update value
    @Published var fruitId: Int = 0
    @Published var nrOfFruit: Int = 0
    
    enum responseStatus{
        case errorApi
        case error
        case success
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(){
        //addEntries(dateStr: "2022-05-20")
        //removeEntriesById(entryId: 2963)
        //removeEntriesList()
        //updateEntries(entryId: 2971, fruitId: 2, nrOfFruit: 1)
        self.getFruitList()
        self.getEntriesList() 
    }
    
    func getDailyItem(selectedDate:String) -> EntriesModel.MapView? {
        let dailyEaten = self.entryItems.first{ $0.date == selectedDate }
        return dailyEaten
    }
    
    func getDailyEaten(selectedDate:String) -> [FruitModel.MapView] {
        
        let dailyEaten = self.entryItems.first{ $0.date == selectedDate }
        return dailyEaten?.fruit ?? []
    }
    
    func getEntryIdByDate(selectedDate:String) -> Int {
        let dailyEaten = self.entryItems.first{ $0.date == selectedDate }
        return dailyEaten?.id ?? 0
    }
 
    
    func getFruitEatenRow(fruitId:Int) -> FruitModel.MapView? {
        let fruitItem = self.fruitEatenPerDay.first{ $0.id == fruitId }
        return fruitItem ?? nil
    }
    
    func updateDailyEaten(selectedDate: String){
        self.fruitEatenPerDay = self.getDailyEaten(selectedDate: selectedDate)
    }
   
    func getFruitList() {
        let serviceAPI = ServiceAPI<FruitModel.Request, [FruitModel.Response]>()
        let apiModel = ApiModel(url: .fruitList)
      
        serviceAPI.requestWithNoParameters(apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                } else {
                    if let data = dataResponse.value {
                        self.fruitItems = data
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    

    
    func getEntriesList() {
        self.entryItems = []
        let serviceAPI = ServiceAPI<EntriesModel.Request, [EntriesModel.Response]>()
        let apiModel = ApiModel(url: .entriesList)
      
        serviceAPI.requestWithNoParameters(apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                } else {
                    if let data = dataResponse.value {
                       
                        for item in data {
                            var fruitView: [FruitModel.MapView] = []
                            if let fruitItems = item.fruit {
                                for fruitItem in fruitItems {
                                     
                                    let fruitEaten = self.fruitItems.first{ $0.id == fruitItem.fruitId }
                                    
                                    fruitView.append(FruitModel.MapView(id: fruitItem.fruitId,
                                                                        type: fruitItem.fruitType,
                                                                        vitamins: fruitEaten?.vitamins ?? 0,
                                                                        amount: fruitItem.amount,
                                                                        image: URL(string: kConfig.apiRoot + (fruitEaten?.image ?? ""))! ))
                                }
                            }
                            self.entryItems.append(EntriesModel.MapView(id: item.id ?? 0,
                                                                     date: item.date ?? "",
                                                                     fruit: fruitView))
                        }
                       self.apiResponse = self.setResponseStatus(key: .success)
                        
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                    
                }
            }
            .store(in: &cancellableSet)
    }
    
    func addEntries(dateStr: String) {
        let serviceAPI = ServiceAPI<EntriesModel.Request, EntriesModel.Response>()
        
        let parameterObject = EntriesModel.Request(date: dateStr)
        
        let apiModel = ApiModel(url: .addEntries,
                                method: .post,
                                header: ["Content-Type": "application/json"]
        )
      
        serviceAPI.request(parameters: parameterObject, apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                    
                } else {
                    
                    if let addedData = dataResponse.value {
                        if addedData.code != nil {
                            self.apiResponse = EntriesModel.ApiResponse(code: addedData.code ?? 0,
                                                                            message: addedData.message ?? "")
                        } else {
                            self.addedResponse = addedData
                            self.getEntriesList()
                            self.apiResponse = self.setResponseStatus(key: .success)
                        }
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    func updateEntries(entryId: Int, fruitId: Int, nrOfFruit: Int) {
        let serviceAPI = ServiceAPI<EntriesModel.Request, EntriesModel.ApiResponse>()
        let apiModel = ApiModel(url: .updateEntries(entryId: entryId, fruitId: fruitId, nrOfFruit: nrOfFruit),
                                method: .post
        )
      
        serviceAPI.requestWithNoParameters(apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                } else {
                    if let data = dataResponse.value {
                        self.apiResponse = data
                        self.getEntriesList()
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    func removeEntriesList() {
        let serviceAPI = ServiceAPI<EntriesModel.Request, EntriesModel.ApiResponse>()
        let apiModel = ApiModel(url: .removeEntriesList,
                                method: .delete
        )
      
        serviceAPI.requestWithNoParameters(apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                } else {
                    if let data = dataResponse.value {
                        self.apiResponse = data
                        self.getEntriesList()
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    func removeEntriesById(entryId: Int) {
        
        let serviceAPI = ServiceAPI<EntriesModel.Request, EntriesModel.ApiResponse>()
        let apiModel = ApiModel(url: .removeEntriesById(entryId: entryId),
                                method: .delete
        )
      
        serviceAPI.requestWithNoParameters(apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                } else {
                    if let data = dataResponse.value {
                        self.apiResponse = data
                        self.getEntriesList()
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
        
    }
    
    func setResponseStatus(key: responseStatus) -> EntriesModel.ApiResponse{
        
        switch key {
        case .errorApi:
            return EntriesModel.ApiResponse(code: 0, message: kConfig.error.errorRequest)
        case .error:
            return EntriesModel.ApiResponse(code: 1, message: kConfig.error.errorDefault)
        case .success:
            return EntriesModel.ApiResponse(code: 200, message: "OK")
        }
        
    }
    
}
