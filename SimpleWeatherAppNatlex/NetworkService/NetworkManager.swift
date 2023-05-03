//
//  NetworkManager.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 06.03.2023.
//

import Moya
import UIKit

protocol Networkable {
    var provider: MoyaProvider<ListsAPI> { get }
}

class NetworkManager: Networkable {
    var provider = MoyaProvider<ListsAPI>(plugins: [NetworkLoggerPlugin()])
    
    func getCurrentGeolocationCity(lat: Double, lon: Double,tempState: String, completion: @escaping (Result<WeatherData, Error>) -> ()) {
        request(target: .getCurrentGeolocationCity(lat: lat, lon: lon, tempState: tempState), completion: completion)
    }
    
    func getCityGeolocationByName(name: String,tempState: String, completion: @escaping (Result<WeatherData, Error>) -> ()) {
        request(target: .getCityGeolocationByName(name: name, tempState: tempState) , completion: completion)
    }

}

private extension NetworkManager {
    
    private func request<T: Decodable>(target: ListsAPI, completion: @escaping (Result<T, any Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

