//
//  main.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/22/20.
//

import Foundation

guard CommandLine.arguments.count > 1 else {
    fatalError("There is no value")
}

func showManual() {
    print("You can enter only one of the following values: \(CommandArgument.debugDescription)")
}

guard let url = URL(string: "file:///Users/vladyera/Documents/GitHub/TexasShop/story.money.md") else {
    print("Error")
    exit(-2)
}

let purchases: [Purchase]

let purchaseParser: IPurchaseParser = PurchaseParser()
do {
    purchases = try purchaseParser.parseDocument(url)
} catch let error as ParsingError{
    fatalError(error.errorDescription)
}

let enteredValue = CommandLine.arguments[1]
if enteredValue == "--help" || enteredValue == "--h"{
    showManual()
    exit(0)
}

guard let realValue = CommandArgument(rawValue: enteredValue) else {
    showManual()
    exit(-1)
}

func processBuyerListCommand() {
    let lines: [String] = purchases.enumerated().map { (index, purchase) in
        return "\(index+1). \(purchase.personName)"
    }
    let result = lines.reduce(into: "") { (temp, line) in
        temp = "\(temp) \(line)\n"
    }
    print(result.dropLast())
}

let kTotalAmountKey = "total_amount"
let kTotalPriceKey = "total_price"

typealias SingleItemSummary = [String: [String: Any]]

func processBuyersSummaryCommand()
{
    let buyersSummaries: [String: [SingleItemSummary]] = purchases.reduce(into: [:]) { (accum, purchase) in
        if let buyerItemsList = accum[purchase.personName] { //here we check that we can create an object from already stored data
            print("This is not unique customer \(purchase.personName)")
            print(purchase)
            purchase.itemRecords.forEach { (addedPurchase) in //for each line from added purchases, we do the following:
                let addedPurchaseName = addedPurchase.itemKind.rawValue.lowercased()
                print(addedPurchaseName)
                print(buyerItemsList)
                var contains = buyerItemsList.first { (singleItem) -> Bool in
                    return singleItem.keys.contains(addedPurchaseName)
                }
                if contains != nil {
                    print(contains!)
                    let oldValueAmount = contains![addedPurchaseName]![kTotalAmountKey]!
                    let oldValueTotal = contains![addedPurchaseName]![kTotalPriceKey]!
                    print(oldValueAmount)
                    print(oldValueTotal)
                    let newValueAmount = oldValueAmount as! Int + addedPurchase.amount
                    let newValueTotal = oldValueTotal as! Double + addedPurchase.totalPrice
                    contains![addedPurchaseName]! = [kTotalPriceKey: newValueTotal, kTotalAmountKey: newValueAmount]
                    print(contains![addedPurchaseName]!)
                    print(contains!)
                    print(accum[purchase.personName]!)
                } else {
                    
                }
                var newArray = buyerItemsList.reduce(into: []) { (temp, singleLine) in
                    temp.append(singleLine.keys)
                }
//                print(contains![addedPurchaseName]![kTotalPriceKey]!)
//                contains![addedPurchaseName] = [kTotalPriceKey: 100, kTotalAmountKey: 5]
            }
        }
        else {
            print("This is the unique customer: \(purchase.personName)")
            let summaries: [SingleItemSummary] = purchase.itemRecords.reduce(into: []) { (tempSummary, record) in
                let singleItemSummary: SingleItemSummary = [
                    record.itemKind.rawValue.lowercased(): [
                        kTotalAmountKey: record.amount,
                        kTotalPriceKey: record.totalPrice
                    ]
                ]
                tempSummary.append(singleItemSummary)
            }
            accum[purchase.personName] = summaries
            print(accum)
        }
        
    }
}


switch realValue {
case .buyersList:
    processBuyerListCommand()
case .buyersSummary:
    processBuyersSummaryCommand()
case .itemsSummary:
    print("Success 3")
}



