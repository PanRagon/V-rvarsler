

//Oppsettet under er basert på Section 13 fra Angela Yu sitt
//Udemy kurs. Referert til i README
import Foundation

struct WeatherData: Decodable {
    let properties: APIProperties
}

struct APIProperties: Decodable {
    let timeseries: [Timeseries]
    let meta: Meta
}

struct Meta: Decodable {
    let units: Units
}

struct Units: Decodable {
    let airTemperatureUnit: String
    let precipitationAmountUnit: String
    
    //Formatet her tatt fra StackOverflow:
    //https://stackoverflow.com/questions/52097826/how-to-change-json-key-name-swift
    enum CodingKeys: String, CodingKey {
        case airTemperatureUnit = "air_temperature"
        case precipitationAmountUnit = "precipitation_amount"
        
    }
}

struct Timeseries: Decodable {
    let time: String
    let data: DataBlock
}

struct DataBlock: Decodable {
    let instant: InstantData
    let nextHour: FutureData?
    let next6Hours: FutureData?
    let next12Hours: FutureData?
    
    enum CodingKeys: String, CodingKey {
        case instant = "instant"
        case nextHour = "next_1_hours"
        case next6Hours = "next_6_hours"
        case next12Hours = "next_12_hours"
    }
}

struct InstantData: Decodable {
    let details: InstantDetails
}

struct InstantDetails: Decodable {
    let airTemperature: Float
    

    enum CodingKeys: String, CodingKey {
        case airTemperature = "air_temperature"
    }
}

struct FutureData: Decodable {
    let summary: Summary
    let details: FutureDetails?
}

struct Summary: Decodable {
    let symbolCode: String
    
    enum CodingKeys: String, CodingKey {
        case symbolCode = "symbol_code"
    }
}

struct FutureDetails: Decodable {
    let precipitationAmount: Float
    
    enum CodingKeys: String, CodingKey {
        case precipitationAmount = "precipitation_amount"
    }
}
