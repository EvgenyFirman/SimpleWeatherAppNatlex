//
//  WeatherMainViewController.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 06.03.2023.
//

import UIKit
import SnapKit
import CoreLocation

protocol WeatherMainDisplayProtocol: AnyObject {
    func displayCurrentGeoLocationCity(weatherData: WeatherData)
    func displayCityGeolocationByName(weatherData: WeatherData)
    func showError()
}

class WeatherMainViewController: UIViewController {
    
    //MARK: - UIElements
    var navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        return view
    }()
    
    var weatherLabel: UILabel = {
        let label = UILabel()
        label.text = "Weather"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var geoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "location.north.circle"), for: .normal)
        button.addTarget(self, action: #selector(requestCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.barTintColor = .systemGray6
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    var currentWeatherView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 76/255, green: 188/255, blue: 248/255, alpha: 1)
        return view
    }()
    
    var cityName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 33, weight: .light)
        return label
    }()
    
    var tempLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        return label
    }()
    
    var tempSwitch: UISwitch = {
        let tempSwitch = UISwitch()
        tempSwitch.addTarget(self, action: #selector(tempSwitchChanged), for: .valueChanged)
        return tempSwitch
    }()
    
    var farengheitLabel: UILabel = {
        let label = UILabel()
        label.text = "F"
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        return label
    }()
    
    var celciumLabel: UILabel = {
        let label = UILabel()
        label.text = "C"
        label.font = UIFont.systemFont(ofSize: 25, weight: .light)
        return label
    }()
    var maxTemp: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    var minTemp: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    var historySearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WeatherMainTableViewCell.self,forCellReuseIdentifier: "cell")
        return tableView
    }()
    var tempState: String = "imperial"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [WeatherDataItem]()
    //MARK: - Variables
    var locationManager = CLLocationManager()
    private let interactor: WeatherMainInteractorProtocol
    
    // MARK: - Init
    init(interactor: WeatherMainInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        configureViews()
        configureConstraints()
        self.setupHideKeyboardOnTap()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
    }
    
    //MARK: - Temp Switch Changed
    @objc func tempSwitchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if value {
            tempState = "metric"
        } else {
            tempState = "imperial"
        }
        guard let cityName = cityName.text else {return}
        interactor.getCityGeolocationByName(name: cityName , tempState: tempState)
    }
    
    @objc func requestCurrentLocation(){
        locationManager.requestLocation()
    }
}

//MARK: - WeatherMainViewController Extension for UIElements
extension WeatherMainViewController {
    
    private func setupStateAndDelegates(){
        self.view.backgroundColor = .white
        searchBar.delegate = self
        tempSwitch.isOn = false
        historySearchTableView.delegate = self
        historySearchTableView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureViews(){

        setupStateAndDelegates()
        
        [navBarView,
         weatherLabel,
         geoButton,
         searchBar,
         currentWeatherView,
         historySearchTableView
        ].forEach { view.addSubview($0)}
        
        [cityName,
         tempLabel,
         tempSwitch,
         farengheitLabel,
         celciumLabel,
         minTemp,
         maxTemp
        ].forEach { currentWeatherView.addSubview($0)}
    }
    
    private func configureConstraints(){
        navBarView.snp.makeConstraints { navBarView in
            navBarView.top.equalTo(self.view.snp.top)
            navBarView.left.equalTo(self.view.snp.left)
            navBarView.right.equalTo(self.view.snp.right)
            navBarView.height.equalTo(150)
        }
        
        weatherLabel.snp.makeConstraints { weatherLabel in
            weatherLabel.top.equalTo(self.view.snp.top).offset(55)
            weatherLabel.centerX.equalTo(self.view.snp.centerX)
        }
        
        geoButton.snp.makeConstraints { geoButton in
            geoButton.width.height.equalTo(30)
            geoButton.centerY.equalTo(weatherLabel.snp.centerY)
            geoButton.right.equalTo(self.view.snp.right).inset(15)
        }
        
        searchBar.snp.makeConstraints { searchBar in
            searchBar.top.equalTo(self.geoButton.snp.bottom).offset(10)
            searchBar.left.equalTo(self.view.snp.left).offset(15)
            searchBar.right.equalTo(self.view.snp.right).inset(15)
            searchBar.height.equalTo(40)
        }
        
        currentWeatherView.snp.makeConstraints { currentWeatherView in
            currentWeatherView.top.equalTo(navBarView.snp.bottom)
            currentWeatherView.left.equalTo(self.view.snp.left)
            currentWeatherView.right.equalTo(self.view.snp.right)
            currentWeatherView.height.equalTo(150)
        }
        
        cityName.snp.makeConstraints { cityName in
            cityName.top.equalTo(self.currentWeatherView.snp.top).offset(20)
            cityName.left.equalTo(self.currentWeatherView.snp.left).offset(25)
        }
        tempLabel.snp.makeConstraints { tempLabel in
            tempLabel.bottom.equalTo(self.currentWeatherView.snp.bottom).inset(40)
            tempLabel.left.equalTo(self.currentWeatherView.snp.left).offset(25)
        }
        tempSwitch.snp.makeConstraints { tempSwitch in
            tempSwitch.centerY.equalTo(self.tempLabel.snp.centerY)
            tempSwitch.right.equalTo(self.currentWeatherView.snp.right).inset(45)
        }
        farengheitLabel.snp.makeConstraints { farengheitLabel in
            farengheitLabel.right.equalTo(self.tempSwitch.snp.left).offset(-10)
            farengheitLabel.centerY.equalTo(self.tempSwitch.snp.centerY)
        }
        celciumLabel.snp.makeConstraints { celciumLabel in
            celciumLabel.left.equalTo(self.tempSwitch.snp.right).offset(10)
            celciumLabel.centerY.equalTo(self.tempSwitch.snp.centerY)
        }
        minTemp.snp.makeConstraints { minTemp in
            minTemp.top.equalTo(self.cityName.snp.bottom).offset(20)
            minTemp.left.equalTo(self.tempLabel.snp.right).offset(25)
        }
        maxTemp.snp.makeConstraints { maxTemp in
            maxTemp.top.equalTo(self.minTemp.snp.bottom).offset(10)
            maxTemp.left.equalTo(self.tempLabel.snp.right).offset(25)
        }
        
        historySearchTableView.snp.makeConstraints { historySearchTableView in
            historySearchTableView.top.equalTo(self.currentWeatherView.snp.bottom)
            historySearchTableView.left.equalTo(self.view.snp.left)
            historySearchTableView.right.equalTo(self.view.snp.right)
            historySearchTableView.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}


//MARK: - WeatherMainViewController
extension WeatherMainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        guard let cityName = searchBar.text else {return}
        interactor.getCityGeolocationByName(name: cityName, tempState: tempState)
    }
}

//MARK: - WeatherMainViewController TableView Delegates/DS
extension WeatherMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WeatherMainTableViewCell else {return UITableViewCell()}
        cell.cityInfoLabel.text = (model.cityName ?? "") + ", " + (model.temp ?? "")
        cell.timeInfoLabel.text = "\(model.requestTime!)"
        return cell
    }
}

//MARK: - WeatherMainViewController CLLocationManagerDelegate
extension WeatherMainViewController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
        } else if status == .authorizedWhenInUse {
        } else if status == .denied {
        } else if status == .restricted {
        } else if status == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        let latitude = coord.latitude
        let longitude = coord.longitude
        print("LocationUpdated")
        interactor.getCurrentGeolocationCity(lat: latitude, lon: longitude,tempState: tempState)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

//MARK: - Extension For Network Layer
extension WeatherMainViewController: WeatherMainDisplayProtocol {
    
    //MARK: - 
    func displayCurrentGeoLocationCity(weatherData: WeatherData) {
        guard let temperature = weatherData.main?.temp else {return}
        guard let maxTemperature = weatherData.main?.tempMax else {return}
        guard let minTemperature = weatherData.main?.tempMin else {return}
                
        if tempState == "imperial" {
            if temperature < 50 {
                currentWeatherView.backgroundColor = UIColor(red: 76/255, green: 188/255, blue: 248/255, alpha: 1)
            } else if temperature >= 50 && temperature < 77 {
                currentWeatherView.backgroundColor = .orange
            } else if temperature >= 77 {
                currentWeatherView.backgroundColor = .red
            }
            
        } else {
            if temperature < 10 {
                currentWeatherView.backgroundColor = UIColor(red: 76/255, green: 188/255, blue: 248/255, alpha: 1)
            } else if temperature >= 10 && temperature < 25 {
                currentWeatherView.backgroundColor = .orange
            } else if temperature >= 25 {
                currentWeatherView.backgroundColor = .red
            }
        }
        createItem(data: weatherData)
        cityName.text = weatherData.name
        tempLabel.text = String(format: "%.0f", temperature) + "°"
        minTemp.text = "Min Temp " + String(format: "%.2f", minTemperature) + "°"
        maxTemp.text = "Max Temp " + String(format: "%.2f", maxTemperature) + "°"
    }
    
    func displayCityGeolocationByName(weatherData: WeatherData) {
        guard let temperature = weatherData.main?.temp else {return}
        guard let maxTemperature = weatherData.main?.tempMax else {return}
        guard let minTemperature = weatherData.main?.tempMin else {return}
        switch temperature {
        case 0...100:
            currentWeatherView.backgroundColor = .red
        case 100...300:
            currentWeatherView.backgroundColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        default:
            currentWeatherView.backgroundColor = .blue
        }
        createItem(data: weatherData)
        cityName.text = weatherData.name
        tempLabel.text = String(format: "%.0f", temperature) + "°"
        minTemp.text = "Min Temp " + String(format: "%.2f", minTemperature) + "°"
        maxTemp.text = "Max Temp " + String(format: "%.2f", maxTemperature) + "°"
    }
    
    func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Город не найден", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - CoreData Functions
extension WeatherMainViewController {
    
    func getAllItems(){
        do {
            models = try context.fetch(WeatherDataItem.fetchRequest())
            DispatchQueue.main.async {
                self.historySearchTableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    func createItem(data: WeatherData) {
        let newItem = WeatherDataItem(context: context)
        newItem.cityName = data.name
        newItem.temp = "\(data.main?.temp ?? 0)" + "°"
        newItem.requestTime = Date()
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
}
