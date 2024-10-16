//
//  WeatherManager.swift
//  Clima
//
//  Created by David Gomez on 2024-10-08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation



struct WeatherManger{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=082b0eae9345a5438336c6f4be284b72"
    
    func fetchWeather(cityName: String){
        let urlSting = "\(weatherUrl)&q=\(cityName)"
        performRequest(stringUrl: urlSting)
    }
    
    func performRequest(stringUrl: String) -> Void {
        
        if let url = URL(string: stringUrl){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                   
                    print(error!)
                    return
                }
                
                if let safeData = data{

                    if let weather = self.parseJSON(weatherData: safeData){
                        let weatherVC = WeatherViewController();
                        weatherVC.didUpdateWeather(weather: weather)
                    }
                    
                    
                }
            }
            
            
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather;
        }
        catch{
            print(error)
            return nil
        }
        
    }
    
   
    
    
}
