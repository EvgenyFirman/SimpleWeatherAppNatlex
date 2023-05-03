//
//  WeatherDataItem+CoreDataProperties.swift
//  SimpleWeatherAppNatlex
//
//  Created by Евгений Фирман on 03.05.2023.
//

import Foundation
import CoreData


extension WeatherDataItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDataItem> {
        return NSFetchRequest<WeatherDataItem>(entityName: "WeatherDataItem")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var temp: String?
    @NSManaged public var requestTime: Date?

}
