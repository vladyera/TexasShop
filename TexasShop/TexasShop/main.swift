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

guard let url = URL(string: "file:///Users/vladyera/Documents/GitHub/TexasShop/ThreePersons_Correct") else {
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

let processor = CommandProcessor()
let processStrategyFactory: ICommandProcessStrategyFactory = CommandProcessStrategyFactory()

let strategy: IProcessStrategy

switch realValue {
case .buyersList:
    strategy = processStrategyFactory.buyersListStrategy()
case .buyersSummary:
    strategy = processStrategyFactory.buyersSummaryStrategy()
case .itemsSummary:
    strategy = processStrategyFactory.defaultStrategy()
}

processor.startProcessing(strategy, purchases: purchases)



