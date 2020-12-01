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

let enteredValue = CommandLine.arguments[1]
if enteredValue == "--help" || enteredValue == "--h"{
    showManual()
    exit(0)
}
print(type(of: enteredValue))
guard let realValue = CommandArgument(rawValue: enteredValue) else {
    showManual()
    exit(-1)
}
print(type(of: realValue))

//let arg = CommandArgument.buyersList

//if enteredValue == arg.rawValue {
//    print("Success 1")
//} else if enteredValue == CommandArgument.buyersSummary.rawValue {
//    print("Success 2")
//} else if enteredValue == CommandArgument.itemsSummary.rawValue {
//    print("Success 3")
//}
//
//switch enteredValue {
//case arg.rawValue:
//    print("Success1")
//case CommandArgument.buyersSummary.rawValue:
//    print("Success 2")
//case CommandArgument.itemsSummary.rawValue:
//    print("Success 3")
//default:
//    print("Error")
//}

switch realValue {
case .buyersList:
    print("Success 1")
case .buyersSummary:
    print("Success 2")
case .itemsSummary:
    print("Success 3")
}

guard let url = URL(string: "file:///Users/vladyera/Documents/GitHub/TexasShop/story.money.md") else {
    print("Error")
    exit(-2)
}

let purchaseParser: IPurchaseParser = PurchaseParser()
let parsedData = purchaseParser.parseDocument(url)
print(parsedData)
