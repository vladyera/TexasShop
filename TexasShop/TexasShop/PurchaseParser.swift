//
//  PurchaseParser.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

import Foundation

enum ParsingError: Error {
    case noDataFound
    case notPossibleToConvert(String)
    
    var errorDescription: String {
        switch self{
        case .noDataFound:
            return "There is no data in the file"
        case .notPossibleToConvert(let context):
            return context
        }
    }
    var errorCode: Int {
        switch self {
        case .noDataFound:
            return 1
        case .notPossibleToConvert:
            return 2
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
            throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – personRanged can't be created")
        }
        let personStartIndex = personRanged.upperBound
        guard let personEndIndex = element.firstIndex(of: "\n") else {
            throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – personEndIndex can't be created")
        }
        let personName = String(element[personStartIndex..<personEndIndex])
        return personName
    }
    
    func dateWithEndIndex(from element: String) throws -> (date: Date, endIndex: String.Index) {
        guard let dateRanged = element.range(of: "Date: ") else {
            throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – dateRanged can't be created")
        }
        let dateStartIndex = dateRanged.upperBound
        guard let dateEndIndex = element[dateStartIndex..<element.endIndex].firstIndex(of: "\n") else {
            throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – dateEndIndex can't be created")
        }
        let dateString = String(element[dateStartIndex..<dateEndIndex])
        guard let date = dateFormatter.date(from: dateString) else {
            throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – date can't be created")
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
                throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – itemKind can't be created")
            }
            guard let amount = Int(lineComponents[1]) else {
                throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – amount can't be created")
            }
            guard let price = Double(lineComponents[2].dropFirst()) else {
                throw ParsingError.notPossibleToConvert("\(#file):\(#function):\(#line) – price can't be created")
            }
            return PurchaseRecord(itemKind: itemKind, amount: amount, pricePerItem: price)
        }
        
        return result
    }
}
