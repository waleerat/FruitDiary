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
    
    @Published var apiResponse: EntriesModel.ApiResponse?
    @Published var addedResponse: EntriesModel.Response?
    
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
        
        updateEntries(entryId: 2971, fruitId: 2, nrOfFruit: 5)
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
                       print(data)
                    } else {
                        self.apiResponse = self.setResponseStatus(key: .error)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    func getEntriesList() {
        let serviceAPI = ServiceAPI<EntriesModel.Request, [EntriesModel.Response]>()
        let apiModel = ApiModel(url: .entriesList)
      
        serviceAPI.requestWithNoParameters(apiModel: apiModel)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.apiResponse = self.setResponseStatus(key: .errorApi)
                } else {
                    if let data = dataResponse.value {
                       print(data)
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
                        }
                        self.apiResponse = self.setResponseStatus(key: .success)
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

/*
 result >> success({
     code = 500;
     message = "There was an error processing your request. It has been logged (ID 0ac21d8324b623cf).";
 })
 
 
 result >> success({
     code = 500;
     message = "There was an error processing your request. It has been logged (ID 59d45af3a2e7f6ad).";
 })

 
 AlamofireManager
  .sharedManager
  .request(apiModel.url,
           method: apiModel.method,
           parameters: "",
           encoder: JSONParameterEncoder.default,
           headers: apiModel.header
  )
 .responseJSON { response in
  print("request >>  \(response.request)")  // original URL request
  print("response >> \(response.response)") // URL response
  print("data >> \(response.data)")     // server data
  print("result >> \(response.result)")   // result of response serialization
 }

 */
