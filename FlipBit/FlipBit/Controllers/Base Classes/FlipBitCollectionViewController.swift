//
//  FlipBitCollectionViewController.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/14/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

/// Provides logic for shared implementation used across all `FlipBitViewController`s.
/// This class provides a custom `collectionView` to be configured and used as needed.
/// This class **is** intended to be subclassed.
///
///   Overrides the following methods:
///   - `setup()`
///   - `setupSubviews()`
///   - `setupConstraints()`
class FlipBitCollectionViewController: FlipBitViewController {
    /// The primary collectionView for displaying information relating
    /// to this controller.
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = themeManager.themeBackgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    public lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    override func setup() {
        super.setup()
        view.backgroundColor = themeManager.themeBackgroundColor
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
