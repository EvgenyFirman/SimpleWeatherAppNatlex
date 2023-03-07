//
//  WeatherDataItem+CoreDataProperties.swift
//  
//
//  Created by Евгений Фирман on 08.03.2023.
//
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
