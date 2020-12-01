//
//  PurchaseParser.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

import Foundation

enum ParsingError: Error {
    case noDataFound
    case notPossibleToConvert
    
    var errorDescription: String {
        switch self{
        case .noDataFound:
            return "There is no data in the file"
        case .notPossibleToConvert:
            return "This type can't be converted"
        }
    }
}

protocol IPurchaseParser: AnyObject{
    func parseDocument(_ url: URL) throws -> [Purchase]
}

final class PurchaseParser{
    private var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter
    }
}

extension PurchaseParser: IPurchaseParser {
    func parseDocument(_ url: URL) throws -> [Purchase] {
        let content: String
        do {
            try content = String(contentsOf: url)
        } catch {
            throw ParsingError.noDataFound
        }
        let arrayFromFile = content.components(separatedBy: "#####\n").dropFirst()
        return try arrayFromFile.map { (purchaseString) in
            let personName = try self.personName(from: purchaseString)
            let dateWithEndIndex = try self.dateWithEndIndex(from: purchaseString)
            let date = dateWithEndIndex.date
            let dateEndIndex = dateWithEndIndex.endIndex
            let purchaseRecords = try self.purchaseRecords(dateEndIndex: dateEndIndex, element: purchaseString)
            return Purchase(date: date, personName: personName, itemRecords: purchaseRecords)
        }
    }
}

private extension PurchaseParser{
    func personName(from element: String) throws -> String {
        guard let personRanged = element.range(of: "Person: ") else {
            throw ParsingError.notPossibleToConvert
        }
        let personStartIndex = personRanged.upperBound
        guard let personEndIndex = element.firstIndex(of: "\n") else {
            throw ParsingError.notPossibleToConvert
        }
        let personName = String(element[personStartIndex..<personEndIndex])
        return personName
    }
    
    func dateWithEndIndex(from element: String) throws -> (date: Date, endIndex: String.Index) {
        guard let dateRanged = element.range(of: "Date: ") else {
            throw ParsingError.notPossibleToConvert
        }
        let dateStartIndex = dateRanged.upperBound
        guard let dateEndIndex = element[dateStartIndex..<element.endIndex].firstIndex(of: "\n") else {
            throw ParsingError.notPossibleToConvert
        }
        let dateString = String(element[dateStartIndex..<dateEndIndex])
        guard let date = dateFormatter.date(from: dateString) else {
            throw ParsingError.notPossibleToConvert
        }
        return (date, dateEndIndex)
    }
    
    func purchaseRecords(dateEndIndex: String.Index, element: String) throws -> [PurchaseRecord] {
        let purchasesStartIndex = element.index(after: dateEndIndex)
        let purchases = String(element[purchasesStartIndex..<element.endIndex])
        let arrayOfPurchases = purchases
            .components(separatedBy: "\n")
            .filter{ !$0.isEmpty }
        
        let result = try arrayOfPurchases.map { (singleLine) -> PurchaseRecord in
            let lineComponents = singleLine.components(separatedBy: ";")
            let itemName = lineComponents[0]
            guard let itemKind = ItemKind(rawValue: itemName) else {
                throw ParsingError.notPossibleToConvert
            }
            guard let amount = Int(lineComponents[1]) else {
                throw ParsingError.notPossibleToConvert
            }
            guard let price = Double(lineComponents[2].dropFirst()) else {
                throw ParsingError.notPossibleToConvert
            }
            return PurchaseRecord(itemKind: itemKind, amount: amount, pricePerItem: price)
        }
        
        return result
    }
}
