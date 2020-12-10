//
//  CommandProcessStrategyFactory.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 12/8/20.
//

import Foundation

protocol ICommandProcessStrategyFactory {
    func buyersListStrategy() -> IProcessStrategy
    func buyersSummaryStrategy() -> IProcessStrategy
    func defaultStrategy() -> IProcessStrategy
}

final class CommandProcessStrategyFactory {
    
}

extension CommandProcessStrategyFactory: ICommandProcessStrategyFactory {
    func defaultStrategy() -> IProcessStrategy {
        return DefaultProcessStrategy()
    }
    func buyersListStrategy() -> IProcessStrategy {
        let url = URL(string: "/Users/vladyera/Documents/GitHub/TexasShop/123")!
        return BuyersListProcessStrategy(filePath: url)
    }
    
    func buyersSummaryStrategy() -> IProcessStrategy {
        return BuyersSummaryProcessStrategy()
    }
}
