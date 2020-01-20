//
//  BitService+BBPosition.swift
//  FlipBit
//
//  Created by Daniel Stewart on 11/13/19.
//  Copyright © 2019 DS Studios. All rights reserved.
//

import Foundation
import NetQuilt

public extension BitService {
    struct BybitPositionList {
        
        /// An array of current positions.
        let positions: [BitService.BybitPosition]
        
        /// Server data about the response.
        let metaData: BitService.BybitResponseMetaData
    }
}

extension BitService.BybitPositionList: Model {
    /// List of top level coding keys.
    private enum CodingKeys: String, CodingKey {
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.metaData = try BitService.BybitResponseMetaData(from: decoder)
        self.positions = try values.decode([BitService.BybitPosition].self, forKey: .result)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(positions, forKey: .result)
    }
}

public extension BitService {
    /// A type that represents a trading event.
    struct BybitPosition {
        
        /// The position ID.
        let positionID: Int
        
        /// The user's ID.
        let userID: Int
        
        /// The risk limit ID.
        let riskID: Int
        
        /// The contract type.
        let symbol: Bybit.Symbol
        
        /// The side of the order.
        let side: BitService.BybitOrderSide
        
        /// The position size.
        let size: Int
        
        /// The position value.
        let value: Double
        
        /// The entry price.
        let entryPrice: Double
        
        /// The user leverage.
        let leverage: Int
        
        /// The margin mode of the position.
        let marginMode: BybitMarginMode
        
        /// The position margin.
        let positionMargin: Double
        
        /// The liquidation price.
        let liquidationPrice: Double
        
        /// The bankrupcy price.
        let bustPrice: Double
        
        /// The position closing fee.
        let closingFee: Double
        
        /// The position funding fee.
        let fundingFee: Double
        
        /// The take profit price.
        let takeProfitPrice: Int
        
        /// The stop loss price.
        let stopLossPrice: Int
        
        /// The trailing stop point.
        let trailingStop: Int
        
        /// The current status of the position.
        let positionStatus: BybitPositionStatus
        
        /// The deleverage indicator.
        let deleverageIndicator: Int
        
        /// oc_calc_data?
        let calcData: String
        
        /// The used margin by order.
        let orderMargin: Int
        
        /// The wallet balance. When in Cross Margin mode, the number minus your unclosed loss is your real wallet balance.
        let walletBalance: Double
        
        /// The unrealised profit and loss.
        let unrealizedPNL: Double
        
        /// The daily realized profit and loss.
        let realizedPNL: Double
        
        /// Total realized profit and loss.
        let totalPNL: Double
        
        /// Total commissions.
        let totalCommissions: Double
        
        /// The Crossed Leverage?
        let crossSeq: Int
        
        /// The position sequence number.
        let positionSequence: Int
        
        /// The date the position was created.
        let dateCreated: String
        
        /// The date the position was last updated.
        let dateUpdated: String
    }
}

extension BitService.BybitPosition: Model {
    /// List of top level coding keys.
    enum CodingKeys: String, CodingKey {
        case positionID = "id"
        case userID = "user_id"
        case riskID = "risk_id"
        case symbol
        case side
        case size
        case value = "position_value"
        case entryPrice = "entry_price"
        case leverage
        case marginMode = "auto_add_margin"
        case positionMargin = "position_margin"
        case liquidationPrice = "liq_price"
        case bustPrice = "bust_price"
        case closingFee = "occ_closing_fee"
        case fundingFee = "occ_funding_fee"
        case takeProfit = "take_profit"
        case stopLoss = "stop_loss"
        case trailingStop = "trailing_stop"
        case positionStatus = "position_status"
        case deleverage = "deleverage_indicator"
        case calcData = "oc_calc_data"
        case orderMargin = "order_margin"
        case walletBalance = "wallet_balance"
        case unrealizedPNL = "unrealised_pnl"
        case realizedPNL = "realised_pnl"
        case totalPNL = "cum_realised_pnl"
        case totalCommissions = "cum_commission"
        case crossSeq = "cross_seq"
        case positionSequence = "position_seq"
        case dateCreated = "created_at"
        case dateUpdated = "updated_at"
    }
    
    public init(from decoder: Decoder) throws {
        let results = try decoder.container(keyedBy: CodingKeys.self)
        self.positionID = try results.decode(Int.self, forKey: .positionID)
        self.userID = try results.decode(Int.self, forKey: .userID)
        self.riskID = try results.decode(Int.self, forKey: .riskID)
        self.symbol = try results.decode(Bybit.Symbol.self, forKey: .symbol)
        self.side = try results.decode(BitService.BybitOrderSide.self, forKey: .side)
        self.size = try results.decode(Int.self, forKey: .size)
        self.value = try results.decode(Double.self, forKey: .value)
        self.entryPrice = try results.decode(Double.self, forKey: .entryPrice)
        self.leverage = try results.decode(Int.self, forKey: .leverage)
        self.marginMode = try results.decode(BitService.BybitMarginMode.self, forKey: .marginMode)
        self.positionMargin = try results.decode(Double.self, forKey: .positionMargin)
        self.liquidationPrice = try results.decode(Double.self, forKey: .liquidationPrice)
        self.bustPrice = try results.decode(Double.self, forKey: .bustPrice)
        self.closingFee = try results.decode(Double.self, forKey: .closingFee)
        self.fundingFee = try results.decode(Double.self, forKey: .fundingFee)
        self.takeProfitPrice = try results.decode(Int.self, forKey: .takeProfit)
        self.stopLossPrice = try results.decode(Int.self, forKey: .stopLoss)
        self.trailingStop = try results.decode(Int.self, forKey: .trailingStop)
        self.positionStatus = try results.decode(BitService.BybitPositionStatus.self, forKey: .positionStatus)
        self.deleverageIndicator = try results.decode(Int.self, forKey: .deleverage)
        self.calcData = try results.decode(String.self, forKey: .calcData)
        self.orderMargin = try results.decode(Int.self, forKey: .orderMargin)
        self.walletBalance = try results.decode(Double.self, forKey: .walletBalance)
        self.unrealizedPNL = try results.decode(Double.self, forKey: .unrealizedPNL)
        self.realizedPNL = try results.decode(Double.self, forKey: .realizedPNL)
        self.totalPNL = try results.decode(Double.self, forKey: .totalPNL)
        self.totalCommissions = try results.decode(Double.self, forKey: .totalCommissions)
        self.crossSeq = try results.decode(Int.self, forKey: .crossSeq)
        self.positionSequence = try results.decode(Int.self, forKey: .positionSequence)
        self.dateCreated = try results.decode(String.self, forKey: .dateCreated)
        self.dateUpdated = try results.decode(String.self, forKey: .dateUpdated)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(positionID, forKey: .positionID)
        try container.encode(userID, forKey: .userID)
        try container.encode(riskID, forKey: .riskID)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(side, forKey: .side)
        try container.encode(size, forKey: .size)
        try container.encode(value, forKey: .value)
        try container.encode(entryPrice, forKey: .entryPrice)
        try container.encode(leverage, forKey: .leverage)
        try container.encode(marginMode, forKey: .marginMode)
        try container.encode(positionMargin, forKey: .positionMargin)
        try container.encode(liquidationPrice, forKey: .liquidationPrice)
        try container.encode(bustPrice, forKey: .bustPrice)
        try container.encode(closingFee, forKey: .closingFee)
        try container.encode(fundingFee, forKey: .fundingFee)
        try container.encode(takeProfitPrice, forKey: .takeProfit)
        try container.encode(stopLossPrice, forKey: .stopLoss)
        try container.encode(trailingStop, forKey: .trailingStop)
        try container.encode(positionStatus, forKey: .positionStatus)
        try container.encode(deleverageIndicator, forKey: .deleverage)
        try container.encode(calcData, forKey: .calcData)
        try container.encode(orderMargin, forKey: .orderMargin)
        try container.encode(walletBalance, forKey: .walletBalance)
        try container.encode(unrealizedPNL, forKey: .unrealizedPNL)
        try container.encode(realizedPNL, forKey: .realizedPNL)
        try container.encode(totalPNL, forKey: .totalPNL)
        try container.encode(totalCommissions, forKey: .totalCommissions)
        try container.encode(crossSeq, forKey: .crossSeq)
        try container.encode(positionSequence, forKey: .positionSequence)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateUpdated, forKey: .dateUpdated)
    }
}
