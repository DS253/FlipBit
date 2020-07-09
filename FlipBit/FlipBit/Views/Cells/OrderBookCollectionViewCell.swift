//  Copyright © 2020 DS Studios. All rights reserved.

import UIKit

/// The OrderBookCollectionViewCell displays the `OrderBookPanel`.
class OrderBookCollectionViewCell: BaseCollectionViewCell {
    private lazy var stackView: UIStackView = {
        UIStackView(axis: .vertical, views: [orderbookPanel])
    }()
    
    private let orderbookPanel: OrderBookPanel = {
        OrderBookPanel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        contentView.addSubview(orderbookPanel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        orderbookPanel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
