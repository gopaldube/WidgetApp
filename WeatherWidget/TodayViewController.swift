//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by Gopal on 24/11/18.
//  Copyright © 2018 Gopal. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private enum Constants {
        static let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?q=Brussels,be?&units=metric&APPID=ae3a1b210ef3974851e57d25798ee13e"
    }
    @IBOutlet weak var weatherLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        getCurrentWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getCurrentWeather() {
        let weatherURL = URL(string: Constants.weatherUrl)!
        let dataTask = URLSession.shared.dataTask(with: weatherURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                print("Error occured while fetching weather information:\n\(error)")
                return
            }
            
            guard let data = data, let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                fatalError("Weather Data not found")
            }
            
            DispatchQueue.main.async {
                self.weatherLabel.text = "\(weatherData.name) \n Current Temperature: \(round(weatherData.main.temp))°C"
            }
        }
        dataTask.resume()
    }
}
