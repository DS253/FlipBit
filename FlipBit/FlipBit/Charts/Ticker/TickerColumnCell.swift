//
//  TickerColumnCell.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/1/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import Foundation
import UIKit

final class TickerColumnCell: UICollectionViewCell {
  static let identifier = "TickerColumnCell"
  
  enum Size {
    case mini, small, large
    
    var fontSize: CGFloat {
      switch self {
      case .small: return .smallFontSize
      case .large, .mini: return .largeFontSize
      }
    }
    
    var rectSize: CGSize {
      switch self {
      case .large:
        return CGSize(width: .largeWidth, height: .cellHeight)
      case .small:
        return CGSize(width: .smallWidth, height: .cellHeight)
      case .mini:
        return CGSize(width: .miniWidth, height: .cellHeight)
      }
    }
  }
  
  var tableView: UITableView = UITableView()
  var characters: [String] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  var size: Size = .large
  
  var isScrolling = false
  
  override init(frame: CGRect)  {
    super.init(frame: frame)
    setUpViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpViews() {
    tableView.isUserInteractionEnabled = false
    tableView.register(TickerCell.self, forCellReuseIdentifier: TickerCell.identifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.backgroundColor = .clear
    
    contentView.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addConstraints([
      NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),
      NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
      ])
  }
}

// MARK: UITableViewDataSource
extension TickerColumnCell: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let tickerCell = tableView.dequeueReusableCell(withIdentifier: TickerCell.identifier, for: indexPath) as! TickerCell
    
    let char = characters[indexPath.row]
    tickerCell.digit = "\(char)"
 //   tickerCell.fontSize = size.fontSize
    
    return tickerCell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return characters.count
  }
}

// MARK: UITableViewDelegate
extension TickerColumnCell: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    isScrolling = true
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    isScrolling = false
  }
}

