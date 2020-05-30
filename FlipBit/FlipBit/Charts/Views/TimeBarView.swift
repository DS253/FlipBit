//
//  TimeBarView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 5/10/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

protocol TimeUpdateDelegate: class {
    func updateChartTime(time: ChartTime)
}

/// Controls the appearance of a chart by time with the listed time segments.
class TimeBarView: BaseView {
    
    /// The chart to redraw itself after a time is selected.
    weak var timeDelegate: TimeUpdateDelegate?
    
    /// The selected time segment.
    private var selectedTimeSegment: ChartTime = .hour
    
    /// Sets the chart to one hour segments.
    lazy var hourButton: TimeBarButton = {
        let button = TimeBarButton(title: "1H", textColor: themeManager.buyTextColor, font: .footnote, selected: true)
        button.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one day segments.
    lazy var dayButton: TimeBarButton = {
        let button = TimeBarButton(title: "1D", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one week segments.
    lazy var weekButton: TimeBarButton = {
        let button = TimeBarButton(title: "1W", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one month segments.
    lazy var monthButton: TimeBarButton = {
        let button = TimeBarButton(title: "1M", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one year segments.
    lazy var yearButton: TimeBarButton = {
        let button = TimeBarButton(title: "1Y", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to display all recorded data.
    lazy var allTimeButton: TimeBarButton = {
        let button = TimeBarButton(title: "All", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(timeSelected), for: .touchUpInside)
        return button
    }()
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(hourButton)
        addSubview(dayButton)
        addSubview(weekButton)
        addSubview(monthButton)
        addSubview(yearButton)
        addSubview(allTimeButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        hourButton.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(dayButton.snp.leading)
        }
        
        dayButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(weekButton.snp.leading)
            make.width.equalTo(hourButton.snp.width)
        }
        
        weekButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(monthButton.snp.leading)
            make.width.equalTo(dayButton.snp.width)
        }
        
        monthButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(yearButton.snp.leading)
            make.width.equalTo(weekButton.snp.width)
        }
        
        yearButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Space.margin4)
            make.trailing.equalTo(allTimeButton.snp.leading)
            make.width.equalTo(monthButton.snp.width)
        }
        
        allTimeButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(Space.margin4)
            make.width.equalTo(yearButton.snp.width)
        }
    }
    
    @objc func timeSelected(sender: UIButton) {
        guard
            let timeText = sender.titleLabel?.text,
            let newTime = ChartTime(rawValue: timeText)
            else { return }
        
        selectedTimeSegment = newTime
        timeDelegate?.updateChartTime(time: selectedTimeSegment)
        
        hourButton.isSelected = hourButton.titleLabel?.text == selectedTimeSegment.rawValue
        dayButton.isSelected = dayButton.titleLabel?.text == selectedTimeSegment.rawValue
        weekButton.isSelected = weekButton.titleLabel?.text == selectedTimeSegment.rawValue
        monthButton.isSelected = monthButton.titleLabel?.text == selectedTimeSegment.rawValue
        yearButton.isSelected = yearButton.titleLabel?.text == selectedTimeSegment.rawValue
        allTimeButton.isSelected = allTimeButton.titleLabel?.text == selectedTimeSegment.rawValue
    }
}
