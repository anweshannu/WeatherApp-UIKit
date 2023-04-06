//
//  HttpUtility.swift
//  WeatherApp-UIKit
//
//  Created by Anwesh on 3/31/23.
//

import Foundation
import Combine

protocol HTTPProtocol{
    func getWeatherInfo(cityName: String, completionHandler: @escaping (Result<WeatherModel, NetworkError>) -> Void)
    func getWeatherInfo(lat: String, long: String, completionHandler: @escaping (Result<WeatherModel, NetworkError>) -> Void)
}

class HttpUtility: HTTPProtocol{
    
    private init(){}
    
    static let shared = HttpUtility()
    
    private var cancellables = Set<AnyCancellable>()
    
    func getWeatherInfo(cityName: String, completionHandler: @escaping (Result<WeatherModel, NetworkError>) -> Void){
        webRequest(endpoint: .getWeatherInfoUsingCityName(cityName: cityName), expecting: WeatherModel.self) { result in
            completionHandler(result)
        }
    }
    
    func getWeatherInfo(lat: String, long: String, completionHandler: @escaping (Result<WeatherModel, NetworkError>) -> Void){
        webRequest(endpoint: .getWeatherInfoUsingLatLong(lat: lat, long: long), expecting: WeatherModel.self) { result in
            completionHandler(result)
        }
    }
    
    
    private func webRequest<T: Decodable>(endpoint: Endpoints, expecting: T.Type, completionHandler: @escaping(Result<T, NetworkError>) -> Void){
        
        guard let url = URL(string: endpoint.url) else{
            return completionHandler(.failure(.invalidURL))
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod
        urlRequest.allHTTPHeaderFields = endpoint.headers
        
        if endpoint.httpMethod != "GET",
           let body = endpoint.body,
           body.count > 0,
           let data = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted){
            urlRequest.httpBody = data
        }
        
        endpoint.headers?.forEach({ header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        })
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data, let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                return completionHandler(.failure(.responseError(data: data)))
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(expecting.self, from: data)
                completionHandler(.success(decodedResponse))
            }
            catch{
                print(error)
                print(error.localizedDescription)
                completionHandler(.failure(.decodingError))
            }
            
        }.resume()
        
    }
    
}

