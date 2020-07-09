//
//  DynamicCollectionView.swift
//  FlipBit
//
//  Created by Daniel Stewart on 7/7/20.
//  Copyright © 2020 DS Studios. All rights reserved.
//

import UIKit

class DynamicCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
