//
//  ChartData.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/1/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Foundation

struct ChartData {
  let openingPrice: Double
  let data: [(date: Date, price: Double)]
  
  static var portfolioData: ChartData {
    var chartData: [(date: Date, price: Double)] = []
    
    var dateComponents = DateComponents()
    dateComponents.year = 2018
    dateComponents.month = 5
    dateComponents.day = 4
    dateComponents.minute = 0
    
    let calendar = Calendar.current
    var startDateComponents = dateComponents
    startDateComponents.hour = 9
    let startDate = calendar.date(from: startDateComponents)
    
    var endDateComponents = dateComponents
    endDateComponents.hour = 16
    let endDate = calendar.date(from: endDateComponents)
    
    let dateInterval = DateInterval(start: startDate!, end: endDate!)
    
    let secondsInMinute = 60
    let timeIntervalIncrement = 5 * secondsInMinute
    let duration = Int(dateInterval.duration)
    
    let startPrice: Double = 240.78
    
    for i in stride(from: 0, to: duration, by: timeIntervalIncrement) {
      let date = startDate!.addingTimeInterval(TimeInterval(i))
      var randomPriceMovement = Double(arc4random_uniform(100))/50
      let upOrDown = arc4random_uniform(2)
      
      if upOrDown == 0 { randomPriceMovement = -randomPriceMovement }
      let chartDataPoint = (date: date, price: startPrice + randomPriceMovement)
      chartData.append(chartDataPoint)
    }

    let portfolioData = ChartData(openingPrice: startPrice, data: chartData)
    
    return portfolioData
  }
}
