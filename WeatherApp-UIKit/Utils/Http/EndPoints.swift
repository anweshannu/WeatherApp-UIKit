//
//  EndPoints.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/31/23.
//

import Foundation

protocol EndpointProtocol {
    var httpMethod: String { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var url: String { get }
}


enum Endpoints: EndpointProtocol{

        
    case getWeatherInfoUsingCityName(cityName: String)
    case getWeatherInfoUsingLatLong(lat: String, long: String)
    
    
    var baseURLString: String{
        return "https://api.openweathermap.org"
    }
    
    var path: String{
        let apiKey: String = Constants.apiKey
        switch self {
        case .getWeatherInfoUsingCityName(let cityName):
            return "/data/2.5/weather?q=\(cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!),US&appid=\(apiKey)&units=metric"
        case .getWeatherInfoUsingLatLong(let lat, let long):
            return "/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        }
    }
    
    var url: String {
        return self.baseURLString + self.path
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
            ]
        }
    }
    
    var body: [String : Any]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var httpMethod: String {
        switch self{
        default:
            return "GET"
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case responseError(data: Data?)
    case unknown
}


