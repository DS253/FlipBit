//
//  ChartData.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/1/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Foundation

struct ChartPoint {
    var date: Date
    var price: Double
}

struct ChartData {
    
    var openingPrice: Double = 0.0
    var data: [ChartPoint] = [ChartPoint]()
    
    init(fileName: String) {
        let data = readDataFromCSV(fileName: fileName, fileType: ".csv")
        let csvRows = csv(data: data!)
        
        guard
            !csvRows.isEmpty,
            !csvRows[0].isEmpty
            else { return }
        
        let timeIndex = 0
        let closeIndex = 4
        var chartPoints: [ChartPoint] = [ChartPoint]()
        
        for marker in csvRows {
            if marker[timeIndex] != "time" {
                
                if let interval = Double(marker[timeIndex]), let closePrice = Double(marker[closeIndex]) {
                    let date = Date(timeIntervalSince1970: interval)

                    let chartDataPoint = ChartPoint(date: date, price: closePrice)
                    chartPoints.append(chartDataPoint)
                }
            }
            
        }
        self.openingPrice = 5555.625
        self.data = chartPoints
    }
}

extension ChartData {
    func readDataFromCSV(fileName: String, fileType: String) -> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return nil }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file: String) -> String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        return result
    }
}