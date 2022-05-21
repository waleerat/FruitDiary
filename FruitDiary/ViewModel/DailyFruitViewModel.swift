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
    let jSonEntryMapView = JSonService<EntriesModel.MapView>()
    let jSonFruitMapView = JSonService<FruitModel.Response>()
    
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
        onload()
    }
    
    func onload(){
        self.getEntriesList()
        self.getFruitList()
        
        // Note: - Issue that I don't save in locally stored
        // I can save to user default
        // but I get "The data couldn’t be read because it is missing." when I decode it.
        // I know that because of Variable type Int
        
        // locally stored code is below:
        /*
        // Note: - Fruit List
        if let mapView = getEntryLocallyStored() {
            self.entryItems = mapView
        } else {
            self.getEntriesList()
        }
        // Note: - Entry List
        if let mapView = getFruitLocallyStored() {
            self.fruitItems = mapView
        } else {
            self.getFruitList()
        }*/
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
    
    // Note: - UserDefault for Entry MapView
    func getEntryLocallyStored() -> [EntriesModel.MapView]? {
        if let mapViewData = self.jSonEntryMapView.decodeArray(forKey: StorageKey.entryItems) {
            return mapViewData
        } else {
            return nil
        }
    }
    
    func setEntryLocallyStored(data: [EntriesModel.Response]){
        self.setEntryListToMapView(data: data) { mapView in
            if let mapView = mapView {
                self.jSonEntryMapView.encodeArray(structData: mapView, forKey: StorageKey.fruitItems)
            }
        }
    }
    
    // Note: - UserDefault for Fruit MapView
    func getFruitLocallyStored() -> [FruitModel.Response]? {
        if let mapViewData = self.jSonFruitMapView.decodeArray(forKey: StorageKey.fruitItems) {
            return mapViewData
        } else {
            return nil
        }
    }
    
    func setFruitLocallyStored(data: [FruitModel.Response]){
        self.jSonFruitMapView.encodeArray(structData: data, forKey: StorageKey.entryItems)
    }
    
    // Note: - Map Entry reponse to mapView structure
    func setEntryListToMapView(data: [EntriesModel.Response], completion: @escaping (_ mapView: [EntriesModel.MapView]?) -> Void) {
        
        for item in data {
            var fruitView: [FruitModel.MapView] = []
            if let fruitItems = item.fruit {
                for fruitItem in fruitItems {
                    
                    let fruitEaten = self.fruitItems.first{ $0.id == fruitItem.fruitId }
                    
                    let itemMapView = FruitModel.MapView(id: fruitItem.fruitId,
                                                         type: fruitItem.fruitType,
                                                         vitamins: fruitEaten?.vitamins ?? 0,
                                                         amount: fruitItem.amount,
                                                         image: kConfig.apiRoot + (fruitEaten?.image ?? ""))
                    
                    fruitView.append(itemMapView)
                }
            }
            self.entryItems.append(EntriesModel.MapView(id: item.id ?? 0,
                                                        date: item.date ?? "",
                                                        fruit: fruitView))
        }
        
        completion(self.entryItems)
    }
    
}

// MARK: - APIs
extension DailyFruitViewModel {
    // Note: - Get all fruits
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
                        self.setFruitLocallyStored(data: data)
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    // Note: - Get All Entries
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
                        self.setEntryLocallyStored(data: data)
                        self.apiResponse = self.setResponseStatus(key: .success)
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                    
                }
            }
            .store(in: &cancellableSet)
    }
    
    // Note: - Add entry
    func addEntry(dateStr: String) {
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
    
    // Note: - Update Entry
    func updateEntry(entryId: Int, fruitId: Int, nrOfFruit: Int) {
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
    
    func removeEntryList() {
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
    
    func removeEntryById(entryId: Int) {
        
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
}
