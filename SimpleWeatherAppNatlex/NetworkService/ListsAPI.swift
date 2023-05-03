//
//  ListsAPI.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 06.03.2023.
//

import Foundation
import Moya
import DeviceKit

enum ListsAPI {
    case getCurrentGeolocationCity(lat: Double, lon: Double, tempState: String)
    case getCityGeolocationByName(name: String, tempState: String)
}

extension ListsAPI: TargetType {
    
    var apiKey: String {
        return "70caf650952791600d1a4b778f3daa96"
    }
    var baseURL: URL {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/") else { fatalError() } // TODO: place base URL
        return url
    }
    var path: String {
        switch self {
        case .getCurrentGeolocationCity,
             .getCityGeolocationByName:
            return "weather"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrentGeolocationCity,
             .getCityGeolocationByName:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getCurrentGeolocationCity(let lat, let lon,let tempState):
            return .requestParameters(parameters: ["lat" : lat,
                                                   "lon" : lon,
                                                   "appid": apiKey,
                                                   "units": tempState
                                                   ], encoding: URLEncoding.default)
        case .getCityGeolocationByName(let name, let tempState):
            return .requestParameters(parameters: ["q" : name,
                                                   "appid": apiKey,
                                                   "units": tempState
                                                   ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var headers = ["X-OS-VERSION": "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
                       "X-DEVICE": Device.current.description,
                       "X-APP-VERSION": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String]
        switch self {
        case .getCurrentGeolocationCity,
                .getCityGeolocationByName:
            break
        }
        return headers
    }
}
