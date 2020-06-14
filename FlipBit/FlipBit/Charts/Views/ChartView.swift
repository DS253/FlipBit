//
//  ChartView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/1/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

protocol ChartViewDelegate: class {
    func didMoveToPrice(_ chartView: ChartView, price: Double)
}

/// An interactive Line Chart with a time label and line marker to track the user's position.
class ChartView: BaseView {
    
    /// The data to be rendered in the Line Chart.
    private var dataPoints: ChartData
    
    /// The delegate will update the TickerControl component to display the price of the selected data point.
    weak var delegate: ChartViewDelegate?
    
    /// The x coordinate for each data point.
    private var xCoordinates: [CGFloat] {
        var coordinates = [CGFloat]()
        for i in stride(from: 0, to: width, by: xStep) { coordinates.append(i) }
        return coordinates
    }
    
    /// The data point with the largest value. This should be the maximum y position on the chart.
    private var highPoint: ChartPoint? {
        return dataPoints.data.max { return $0.price < $1.price }
    }
    
    /// The data point with the smallest value. This should be the minimum y position on the chart.
    private var lowPoint: ChartPoint? {
        return dataPoints.data.min { return $0.price < $1.price }
    }
    
    /// The difference between the high and low data points. This will determine the value of each y point.
    private var heightRange: CGFloat {
        guard
            let high = highPoint?.price,
            let low = lowPoint?.price
            else { return 0.0 }
        return CGFloat(high - low)
    }
    
    /// The value for each point increase on the x-axis.
    private var xStep: CGFloat {
        return width / CGFloat(dataPoints.data.count)
    }
    
    /// The value for each point increase on the y-axis.
    private var yStep: CGFloat {
        return height / heightRange
    }
    
    /// The marker to show the user the position of their touch.
    private var lineView: View = {
        let line = View(backgroundColor: .gray)
        line.alpha = 0.0
        line.isHidden = true
        return line
    }()
    
    /// Constraint used to allow the line indicator to move across the chart.
    private lazy var lineViewLeadConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
    }()
    
    /// Displays the date/time of the selected data point.
    private let timeStampLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont.body, textColor: themeManager.themeFontColor)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()
    
    /// Constraint used to center the time stamp label with the line indicator and to update the position as the user selects a data point too close to the boundaries of the chart.
    private lazy var timeStampCenterConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: timeStampLabel, attribute: .centerX, relatedBy: .equal, toItem: lineView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    }()
    
    /// The circular marker indicates the selected `DataPoint` on the `ChartView`.
    private lazy var circularMarker: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = themeManager.buyTextColor
        view.layer.cornerRadius = view.bounds.width / 2
        return view
    }()
    
    private var chartPath: UIBezierPath?
    
    /// The expected dashed line to represent the middle of the chart.
    private lazy var middleLine: UIBezierPath = {
        let middleLine = UIBezierPath()
        middleLine.lineWidth = 1.0
        middleLine.lineCapStyle = .round
        return middleLine
    }()
    
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private let timeStampPadding: CGFloat = Space.margin10
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter
    }
    
    init(data: ChartData) {
        self.dataPoints = data
        super.init()
    }
    
    override func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(userDidPan(_:))))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(userDidLongPress(_:))))
    }
    
    override func setupSubviews() {
        addSubview(lineView)
        addSubview(timeStampLabel)
        addSubview(circularMarker)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            timeStampCenterConstraint,
            timeStampLabel.bottomAnchor.constraint(equalTo: lineView.topAnchor),
            lineViewLeadConstraint,
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1.0),
            lineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0),
            
            heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        height = rect.size.height
        width = rect.size.width
        
        drawChart()
        drawMiddleLine()
    }
    
    /// Draws a dashed line horizontally across the chart.
    private func drawMiddleLine() {
        middleLine.removeAllPoints()
        middleLine.move(to: CGPoint(x: 0, y: height / 2))
        middleLine.addLine(to: CGPoint(x: width, y: height / 2))
        middleLine.setLineDash([0, 5], count: 2, phase: 0)
        middleLine.stroke()
    }
    
    /// Draws the line chart from the provided data points.
    private func drawChart() {
        chartPath?.removeAllPoints()
        
        /// Set the initial point of the path to be the computed y-coordinate of the first data point price.
        let newPath = UIBezierPath()
        newPath.move(to: CGPoint(x: 0, y: CGFloat(dataPoints.data[0].price) * yStep))
        
        /// Calculate the y-coordinate for each data point.
        for (index, dataPoint) in dataPoints.data.enumerated() {
            /// Calculate the y-coordinate for each data point.
            let yPoint = convertToY(dataPoint: dataPoint)
            newPath.addLine(to: CGPoint(x: xCoordinates[index], y: yPoint))
        }
        
        UIColor.Chart.gainsColor.setFill()
        UIColor.Chart.gainsColor.setStroke()
        newPath.stroke()
        chartPath = newPath
    }
    
    /// LongPress reveals the line view indicator.
    @objc func userDidLongPress(_ gesture: UILongPressGestureRecognizer) {
        let x = convertTouchLocationToPointX(touchLocation: gesture.location(in: self))
        guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
        
        let dataPoint = dataPoints.data[xIndex]
        updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
        manageIndicatorAppearance(gesture: gesture)
        
        let y = convertToY(dataPoint: dataPoint)
        circularMarker.center = CGPoint(x: x, y: y)
    }
    
    /// PanGesture moves the line view indicator.
    @objc func userDidPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed, .began, .ended:
            let x = convertTouchLocationToPointX(touchLocation: gesture.location(in: self))
            guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
            let dataPoint = dataPoints.data[xIndex]
            
            updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
            manageIndicatorAppearance(gesture: gesture)
            
            let y = convertToY(dataPoint: dataPoint)
            circularMarker.center = CGPoint(x: x, y: y)
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let x = convertTouchLocationToPointX(touchLocation: touch.location(in: self))
            guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
            
            let dataPoint = dataPoints.data[xIndex]
            updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
            
            let y = convertToY(dataPoint: dataPoint)
            circularMarker.center = CGPoint(x: x, y: y)
            circularMarker.isHidden = false
            timeStampLabel.isHidden = false
            lineView.isHidden = false
            hapticFeedback()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            circularMarker.isHidden = true
            timeStampLabel.isHidden = true
            lineView.isHidden = true
            hapticFeedback()
        }
    }
    
    /// Moves the position of the line view and the time stamp label  based on the provided offset.
    private func updateIndicator(with offset: CGFloat, date: Date, price: Double) {
        timeStampLabel.text = dateFormatter.string(from: date).uppercased()
        if offset != lineViewLeadConstraint.constant {
            delegate?.didMoveToPrice(self, price: price)
        }
        
        lineViewLeadConstraint.constant = offset
        
        let timeStampWidth = timeStampLabel.frame.width / 2
        let timeStampLeadingAnchor = timeStampWidth + timeStampPadding
        let timeStampTrailingAnchor = width - timeStampWidth - timeStampPadding
        
        /// If the current x coordinate doesn't require the time stamp label to move from the center, set the time stamp constraint to 0.
        if offset > timeStampLeadingAnchor && offset < timeStampTrailingAnchor {
            timeStampCenterConstraint.constant = 0
            /// If the current x coordinate pushes the leading end of the time stamp label, set the time stamp constraint to the difference of the minimum offset and the x coordinate.
        } else if offset + timeStampLeadingAnchor  < timeStampTrailingAnchor {
            let minOffset = timeStampWidth + timeStampPadding
            timeStampCenterConstraint.constant = minOffset - offset
            /// If the current x coordinate pushes the trailing end of the time stamp label, set the time stamp constraint to the difference of the maximum offset and the x coordinate.
        } else {
            let maxOffset = width - timeStampPadding - timeStampWidth
            timeStampCenterConstraint.constant = maxOffset - offset
        }
    }
    
    /// Hides the line view and time stamp label when a gesture is ending and reveals them when a gesture is beginning.
    private func manageIndicatorAppearance(gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            circularMarker.isHidden = false
            timeStampLabel.isHidden = false
            lineView.isHidden = false
        case .ended:
            circularMarker.isHidden = true
            timeStampLabel.isHidden = true
            lineView.isHidden = true
        default:
            break
        }
    }
    
    /// Converts the x value of the touch location to an x coordinate on the chart.
    private func convertTouchLocationToPointX(touchLocation: CGPoint) -> CGFloat {
        let maxX: CGFloat = width
        let minX: CGFloat = 0
        
        var x = min(max(touchLocation.x, maxX), minX)
        
        xCoordinates.forEach { (xCoordinate) in
            let difference = abs(xCoordinate - touchLocation.x)
            if difference <= xStep {
                x = CGFloat(xCoordinate)
                return
            }
        }
        
        return x
    }
    
    /// Returns the Y Point on the `ChartView` of the provided `DataPoint`.
    private func convertToY(dataPoint: ChartPoint) -> CGFloat {
        guard let lowestPoint = lowPoint else { return 0.0 }
        
        /// Determine distance from the bottom by subtracting the price from the lowest price.
        let distanceFromBottom = CGFloat(dataPoint.price - lowestPoint.price) * yStep
        let midPoint = (heightRange / 2) * yStep
        
        /// The middle point of the y-axis.
        let chartMiddle = height / 2
        var yPoint: CGFloat = 0.0
        
        if distanceFromBottom > midPoint {
            yPoint = midPoint - (distanceFromBottom - midPoint)
        }
            /// If the y distance is less than the mid point, add the difference of the midpoint and the y distance.
        else if distanceFromBottom < midPoint {
            yPoint = midPoint + (midPoint - distanceFromBottom)
        }
            
            /// If the y distance is the same as the mid point, set the y coordinate to the mid point.
        else if distanceFromBottom == midPoint {
            yPoint = chartMiddle
        }
        
        return yPoint
    }
}
