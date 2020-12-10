//
//  BuyersSummaryProcessStrategy.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 12/8/20.
//

import Foundation

private typealias SingleItemSummary = [String: [String: Any]]

private enum Constants {
    static let kTotalAmountKey = "total_amount"
    static let kTotalPriceKey = "total_price"
}

final class BuyersSummaryProcessStrategy {
    
}

extension BuyersSummaryProcessStrategy: IProcessStrategy {
    
    func processToFile(purchases: [Purchase]) {
        let url = URL(string: "/Users/vladyera/Documents/GitHub/TexasShop/345")
        try? "werwerwergfdgdf".write(toFile: url!.absoluteString, atomically: true, encoding: .utf8)
    }
    
    func processToTerminal(purchases: [Purchase]) {
        let buyersSummaries: [String: [SingleItemSummary]] = purchases.reduce(into: [:]) { (accum, purchase) in
            if let buyerItemsList = accum[purchase.personName] { //here we check that we can create an object from already stored data
                purchase.itemRecords.forEach { (addedPurchase) in //for each line from added purchases, we do the following:
                    let addedPurchaseName = addedPurchase.itemKind.rawValue.lowercased()
                    var match = buyerItemsList.first { (singleItem) -> Bool in
                        return singleItem.keys.contains(addedPurchaseName)
                    }
                    if match != nil {
                        let oldValueAmount = match![addedPurchaseName]![Constants.kTotalAmountKey]!
                        let oldValueTotal = match![addedPurchaseName]![Constants.kTotalPriceKey]!
                        let newValueAmount = oldValueAmount as! Int + addedPurchase.amount
                        let newValueTotal = oldValueTotal as! Double + addedPurchase.totalPrice
                        match![addedPurchaseName]! = [Constants.kTotalPriceKey: newValueTotal, Constants.kTotalAmountKey: newValueAmount]
                        let targetIndex = accum[purchase.personName]!.firstIndex { (singleItem) -> Bool in
                            return singleItem.keys.first! == match!.keys.first!
                        }
                        accum[purchase.personName]?.remove(at: targetIndex!)
                        accum[purchase.personName]?.append(match!)
                    } else {
                        let oneMorePurchase: SingleItemSummary = [
                            addedPurchase.itemKind.rawValue.lowercased(): [
                                Constants.kTotalPriceKey: addedPurchase.totalPrice,
                                Constants.kTotalAmountKey: addedPurchase.amount
                            ]
                        ]
                        accum[purchase.personName]?.append(oneMorePurchase)
                    }
                }
            }
            else {
                let summaries: [SingleItemSummary] = purchase.itemRecords.reduce(into: []) { (tempSummary, record) in
                    let singleItemSummary: SingleItemSummary = [
                        record.itemKind.rawValue.lowercased(): [
                            Constants.kTotalAmountKey: record.amount,
                            Constants.kTotalPriceKey: record.totalPrice
                        ]
                    ]
                    tempSummary.append(singleItemSummary)
                }
                accum[purchase.personName] = summaries
            }
        }
        printBuyersSummaries(buyersSummaries)
    }
}

private extension BuyersSummaryProcessStrategy {
    func printBuyersSummaries(_ summaries: [String: [SingleItemSummary]]) {
        summaries.forEach { (name, purchases) in
            print(name)
            purchases.enumerated().forEach { (index, purchase) in
                if let key = purchase.keys.first {
                    print("\(index+1). \(key) (amount: \(purchase[key]![Constants.kTotalAmountKey]!), price: \(purchase[key]![Constants.kTotalPriceKey]!))")
                }

            }
            print("----------")
        }
    }
}
