//
//  WeatherMainInteractor.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 06.03.2023.
//

import Foundation

protocol WeatherMainInteractorProtocol {
    func getCurrentGeolocationCity(lat: Double, lon: Double, tempState: String)
    func getCityGeolocationByName(name: String, tempState: String)
}

final class WeatherMainInteractor: WeatherMainInteractorProtocol {
  
    private let networkManager = NetworkManager()
    private let presenter: WeatherMainPresenterProtocol

    // MARK: - Init
    init(presenter: WeatherMainPresenterProtocol) {
        self.presenter = presenter
    }
    
    func getCurrentGeolocationCity(lat: Double, lon: Double, tempState: String) {
        networkManager.getCurrentGeolocationCity(lat: lat, lon: lon,tempState: tempState) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let result):
                    self?.presenter.displayCurrentGeolocationCity(weatherData: result)
                case .failure(_):
                    self?.presenter.showError()
                    break
                }
            }
        }
    }
    
    func getCityGeolocationByName(name: String, tempState: String) {
        networkManager.getCityGeolocationByName(name: name,tempState: tempState) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let result):
                    self?.presenter.displayCurrentGeolocationCity(weatherData: result)
                case .failure(_):
                    self?.presenter.showError()
                    break
                }
            }
        }
    }
}
