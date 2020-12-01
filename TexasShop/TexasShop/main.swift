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

switch realValue {
case .buyersList:
    processBuyerListCommand()
case .buyersSummary:
    print("Success 2")
case .itemsSummary:
    print("Success 3")
}



