//
//  CommandArgument.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

import Foundation

enum CommandArgument: String, CaseIterable{
    
    static var debugDescription: String{
        let result = CommandArgument.allCases.reduce(into: "") { (tempResult, nextArgument) in
            tempResult = tempResult.appending("\(nextArgument.rawValue), ")
        }.dropLast(2)
        return String(result)
    }
    
    case buyersList = "BuyersList"
    case buyersSummary = "BuyersSummary"
    case itemsSummary = "ItemsSummary"
}
