//
//  WeatherMainPresenter.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 06.03.2023.
//

import Foundation

protocol WeatherMainPresenterProtocol {
    func displayCurrentGeolocationCity(weatherData: WeatherData)
    func displayCityGeolocationByName(weatherData: WeatherData)
    func showError()
}

final class WeatherMainPresenter: WeatherMainPresenterProtocol {
    
    
    // MARK: - Properties
    weak var viewController: WeatherMainDisplayProtocol?
    
    // MARK: - Init
    init() {}
    
    func displayCurrentGeolocationCity(weatherData: WeatherData) {
        viewController?.displayCurrentGeoLocationCity(weatherData: weatherData)
    }
    
    func displayCityGeolocationByName(weatherData: WeatherData) {
        viewController?.displayCurrentGeoLocationCity(weatherData: weatherData)
    }
    
    func showError() {
        viewController?.showError()
    }
}
