//
//  TimeBarView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 5/10/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

protocol TimeUpdateDelegate: class {
    func updateChartTime(time: String)
}

/// Controls the appearance of a chart by time with the listed time segments.
class TimeBarView: BaseView {
    
    /// The chart to redraw itself after a time is selected.
    weak var timeDelegate: TimeUpdateDelegate?
    
    /// Sets the chart to one hour segments.
    lazy var hourButton: UIButton = {
        let button = UIButton(title: "1H", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one day segments.
    lazy var dayButton: UIButton = {
        let button = UIButton(title: "1D", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one week segments.
    lazy var weekButton: UIButton = {
        let button = UIButton(title: "1W", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one month segments.
    lazy var monthButton: UIButton = {
        let button = UIButton(title: "1M", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to one year segments.
    lazy var yearButton: UIButton = {
        let button = UIButton(title: "1Y", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    /// Sets the chart to display all recorded data.
    lazy var allTimeButton: UIButton = {
        let button = UIButton(title: "All", textColor: themeManager.buyTextColor, font: .footnote)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func setup() {
        super.setup()
        
        //        layer.borderColor = themeManager.buyTextColor.cgColor
        //        layer.borderWidth = 2.0
        //        layer.cornerRadius = 7.0
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
    
    @objc func buttonTapped(sender: UIButton) {
        guard let timeText = sender.titleLabel?.text else { return }
        timeDelegate?.updateChartTime(time: timeText)
    }
}
