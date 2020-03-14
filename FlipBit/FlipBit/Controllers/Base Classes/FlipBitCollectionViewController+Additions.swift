//
//  FlipBitCollectionViewController+Additions.swift
//  FlipBit
//
//  Created by Daniel Stewart on 3/14/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension FlipBitCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fatalError("\(String(describing: self)) - \(#function) must be overriden by a subclass.")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("\(String(describing: self)) - \(#function) must be overriden by a subclass.")
    }
}

// MARK: - UICollectionViewDelegate

extension FlipBitCollectionViewController: UICollectionViewDelegate { }

