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

/// Renders an interactive Line Chart with a time label and line marker to track the user's position.
final class ChartView: BaseView {

    /// The data to be rendered in the Line Chart.
    private var dataPoints: ChartData

    /// The data point with the largest value. This should be the maximum y position on the chart.
    private lazy var highPoint: ChartPoint? = {
        return dataPoints.data.max { return $0.price < $1.price }
    }()

    /// The data point with the smallest value. This should be the minimum y position on the chart.
    private lazy var lowPoint: ChartPoint? = {
        return dataPoints.data.min { return $0.price < $1.price }
    }()

    /// The difference between the high and low data points. This will determine the value of each y point.
    private lazy var heightRange: CGFloat = {
        guard
            let high = highPoint?.price,
            let low = lowPoint?.price
            else { return 0.0 }
        return CGFloat(high - low)
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter
    }()

    /// The value for each point increase on the x-axis.
    private lazy var xStep: CGFloat = {
        return width / CGFloat(dataPoints.data.count)
    }()

    /// The value for each point increase on the y-axis.
    private lazy var yStep: CGFloat = {
        return height / heightRange
    }()

    /// The marker to show the user the position of their touch.
    private var lineView: View = {
        let line = View(backgroundColor: .gray)
        line.isHidden = true
        return line
    }()

    /// Displays the date/time of the selected data point.
    private let timeStampLabel: UILabel = {
        let label = UILabel(text: "", font: UIFont.body.bold)
        label.lineBreakMode = .byTruncatingTail
        label.isHidden = true
        return label
    }()

    private var lineViewLeading = NSLayoutConstraint()
    private var timeStampLeading = NSLayoutConstraint()
    
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let longPressGestureRecognizer = UILongPressGestureRecognizer()
    
    private var height: CGFloat = 0
    private var width: CGFloat = 0
    private let timeStampPadding: CGFloat = Space.margin10
    
    private var xCoordinates: [CGFloat] = []
    
    weak var delegate: ChartViewDelegate?
    private var feedbackGenerator = UISelectionFeedbackGenerator()
    
    init(data: ChartData) {
        self.dataPoints = data
        super.init()
    }
    
    override func setup() {
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func setupSubviews() {
        addSubview(lineView)
        addSubview(timeStampLabel)
    }
    
    override func setupConstraints() {
        lineViewLeading = NSLayoutConstraint(item: lineView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        timeStampLeading = NSLayoutConstraint(item: timeStampLabel, attribute: .leading, relatedBy: .equal, toItem: lineView, attribute: .leading, multiplier: 1.0, constant: timeStampPadding)
        
        NSLayoutConstraint.activate([
            timeStampLeading,
            timeStampLabel.bottomAnchor.constraint(equalTo: lineView.topAnchor),
            lineViewLeading,
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 1.5),
            lineView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        height = rect.size.height
        width = rect.size.width
        
        drawGraph()
        drawMiddleLine()

        panGestureRecognizer.addTarget(self, action: #selector(userDidPan(_:)))
        
        
        longPressGestureRecognizer.addTarget(self, action: #selector(userDidLongPress(_:)))
        timeStampLabel.center = lineView.center
    }
    
    private func drawGraph() {
        
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: 0, y: CGFloat(dataPoints.data[0].price) * yStep))
        for i in stride(from: 0, to: width, by: xStep) { xCoordinates.append(i) }
        
        for (index, dataPoint) in dataPoints.data.enumerated() {
            let midPoint = (heightRange / 2) * yStep
            let graphMiddle = height / 2
            let point = CGFloat(dataPoint.price - lowPoint!.price) * yStep
            
            if point > midPoint {
                let difference = point - midPoint
                let test = midPoint - difference
                
                
                let newPoint = CGPoint(x: xCoordinates[index], y: test)
                graphPath.addLine(to: newPoint)
            }
            else if point < midPoint {
                let difference = midPoint - point
                let test = midPoint + difference
                let newPoint = CGPoint(x: xCoordinates[index], y: test)
                graphPath.addLine(to: newPoint)
            }
            else if point == midPoint {
                let newPoint = CGPoint(x: xCoordinates[index], y: graphMiddle)
                graphPath.addLine(to: newPoint)
            }
        }
        
        UIColor.upAccentColor.setFill()
        UIColor.upAccentColor.setStroke()
        graphPath.lineWidth = 1.5
        graphPath.stroke()
    }
    
    private func drawMiddleLine() {
        let middleLine = UIBezierPath()
        
        let startingPoint = CGPoint(x: 0, y: height / 2)
        let endingPoint = CGPoint(x: width, y: height / 2)
        
        middleLine.move(to: startingPoint)
        middleLine.addLine(to: endingPoint)
        middleLine.setLineDash([0, xStep], count: 2, phase: 0)
        
        middleLine.lineWidth = 1.0
        middleLine.lineCapStyle = .round
        middleLine.stroke()
    }

    @objc func userDidLongPress(_ gesture: UILongPressGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        let x = convertTouchLocationToPointX(touchLocation: touchLocation)
        
        guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
        
        let dataPoint = dataPoints.data[xIndex]
        updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
        
        if gesture.state == .began {
            timeStampLabel.isHidden = false
            lineView.isHidden = false
        }
        else if gesture.state == .ended {
            timeStampLabel.isHidden = true
            lineView.isHidden = true
        }
    }
    
    @objc func userDidPan(_ gesture: UIPanGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        
        switch gesture.state {
        case .changed, .began, .ended:
            
            if gesture.state == .began {
                timeStampLabel.isHidden = false
                lineView.isHidden = false
            }
            else if gesture.state == .ended {
                timeStampLabel.isHidden = true
                lineView.isHidden = true
            }
            let x = convertTouchLocationToPointX(touchLocation: touchLocation)
            
            guard let xIndex = xCoordinates.firstIndex(of: x) else {return }
            let dataPoint = dataPoints.data[xIndex]
            
            updateIndicator(with: x, date: dataPoint.date, price: dataPoint.price)
            
        default: break
        }
    }
    
    private func updateIndicator(with offset: CGFloat, date: Date, price: Double) {
        timeStampLabel.text = dateFormatter.string(from: date).uppercased()
        if offset != lineViewLeading.constant {
            feedbackGenerator.prepare()
            feedbackGenerator.selectionChanged()
            delegate?.didMoveToPrice(self, price: price)
        }
        
        lineViewLeading.constant = offset
        
        let timeStampStartAnchor = timeStampLabel.frame.width/2 + timeStampPadding
        let timeStampEndAnchor = width - timeStampLabel.frame.width/2 - timeStampPadding
        
        if offset > timeStampStartAnchor && offset < timeStampEndAnchor {
            timeStampLeading.constant = -timeStampLabel.frame.width/2
        } else if offset + timeStampStartAnchor  < timeStampEndAnchor {
            timeStampLeading.constant = -timeStampLabel.frame.width/2 + (timeStampLabel.frame.width/2 - offset) + timeStampPadding
        } else {
            timeStampLeading.constant = -timeStampLabel.frame.width + (width - offset) - timeStampPadding
        }
    }
    
    // Check if touchLocation.x is in the bounds of the width of the view, and converts it to a graph value
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
}
