//
//  PurchaseParser.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

import Foundation

protocol IPurchaseParser: AnyObject{
    func parseDocument(_ url: URL) -> [Purchase]
}

final class PurchaseParser{
    private var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter
    }
}

extension PurchaseParser: IPurchaseParser {
    func parseDocument(_ url: URL) -> [Purchase] {
        let content: String
        do {
            try content = String(contentsOf: url)
        } catch let error {
            assertionFailure("Error: \(error.localizedDescription)")
            return []
        }
        let arrayFromFile = content.components(separatedBy: "#####\n").dropFirst()
        return arrayFromFile.map { (purchaseString) in
            let personName = self.personName(from: purchaseString)
            let dateWithEndIndex = self.dateWithEndIndex(from: purchaseString)
            let date = dateWithEndIndex.date
            let dateEndIndex = dateWithEndIndex.endIndex
            let purchaseRecords = self.purchaseRecords(dateEndIndex: dateEndIndex, element: purchaseString)
            return Purchase(date: date, personName: personName, itemRecords: purchaseRecords)
        }
    }
}

private extension PurchaseParser{
    func personName(from element: String) -> String {
        let personRanged = element.range(of: "Person: ")!
        let personStartIndex = personRanged.upperBound
        let personEndIndex = element.firstIndex(of: "\n")!
        let personName = String(element[personStartIndex..<personEndIndex])
        return personName
    }
    
    func dateWithEndIndex(from element: String) -> (date: Date, endIndex: String.Index) {
        let dateRanged = element.range(of: "Date: ")!
        let dateStartIndex = dateRanged.upperBound
        let dateEndIndex = element[dateStartIndex..<element.endIndex].firstIndex(of: "\n")!
        let dateString = String(element[dateStartIndex..<dateEndIndex])
        let date = dateFormatter.date(from: dateString)!
        return (date, dateEndIndex)
    }
    
    func purchaseRecords(dateEndIndex: String.Index, element: String) -> [PurchaseRecord] {
        let purchasesStartIndex = element.index(after: dateEndIndex)
        let purchases = String(element[purchasesStartIndex..<element.endIndex])
        let arrayOfPurchases = purchases
            .components(separatedBy: "\n")
            .filter{ !$0.isEmpty }
        
        return arrayOfPurchases.map { (singleLine) in
            let lineComponents = singleLine.components(separatedBy: ";")
            let itemName = lineComponents[0]
            let itemKind = ItemKind(rawValue: itemName)!
            let amount = Int(lineComponents[1])!
            let price = Double(lineComponents[2].dropFirst())!
            return PurchaseRecord(itemKind: itemKind, amount: amount, pricePerItem: price)
        }
    }
}
