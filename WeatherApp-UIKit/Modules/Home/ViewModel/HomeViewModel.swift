//
//  HomeViewModel.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/31/23.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject{
    func onWeatherDataFetchedFromAPI(data: WeatherModel)
    func onHttpError(message: String)
    func showLoader()
}

class HomeViewModel: NSObject {
    let httpUtility: HTTPProtocol
    weak var delegate: HomeViewModelDelegate?
    
    init(httpUtility: HTTPProtocol = HttpUtility.shared) {
        self.httpUtility = httpUtility
    }
    
    func getWeatherInfoUsingCity(_ cityName: String){
        self.delegate?.showLoader()
        httpUtility.getWeatherInfo(cityName: cityName) {[weak self] result in
            self?.handleAPIresponse(result: result)
        }
    }
    
    func getWeatherInfoUsingLatLong(lat: String, long: String){
        self.delegate?.showLoader()
        httpUtility.getWeatherInfo(lat: lat, long: long){ [weak self] result in
            self?.handleAPIresponse(result: result)
        }
    }
    
    func handleAPIresponse( result: Result<WeatherModel, NetworkError>){
        
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let model):
                self?.delegate?.onWeatherDataFetchedFromAPI(data: model)
            case .failure(let error):
                var errorMessage = "Something went wrong!"
                switch error {
                case .responseError(let data):
                    guard let data else{break}
                    guard let decodedData = try? JSONDecoder().decode(WeatherErrorModel.self, from: data) else{break}
                    errorMessage = decodedData.message
                    if errorMessage == "city not found"{
                        errorMessage = "Please enter a valid US city"
                    }
                    
                case .invalidURL:
                    errorMessage = "Invalid URL"
                default:
                    break
                }
                self?.delegate?.onHttpError(message: errorMessage)
            }
        }
    }
    
}
