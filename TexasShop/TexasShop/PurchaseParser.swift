//
//  PurchaseParser.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

import Foundation

protocol IPurchaseParser {
    func parseDocument(_ url: URL) -> [Purchase]
}

class PurchaseParser{
    private var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter
    }
}

extension PurchaseParser: IPurchaseParser {
    func parseDocument(_ url: URL) -> [Purchase] {
        //Step 1: open file via provided URL
        let content: String
        do {
            try content = String(contentsOf: url)
        } catch let error {
            assertionFailure("Error: \(error.localizedDescription)")
            return []
        }
        //Step 2: get content from the document (String)
        //Step 3: divide content to make arrays
        let arrayFromFile = content.components(separatedBy: "#####\n").dropFirst()
        print(arrayFromFile)
        arrayFromFile.forEach { (element) in
            let personName = self.personName(from: element)
            let dateWithEndIndex = self.dateWithEndIndex(from: element)
            let date = dateWithEndIndex.date
            let dateEndIndex = dateWithEndIndex.endIndex
            
            let purchasesStartIndex = element.index(after: dateEndIndex)
            let purchases = String(element[purchasesStartIndex..<element.endIndex])
            let arrayOfPurchases = purchases
                .components(separatedBy: "\n")
                .filter{ !$0.isEmpty }
            
            arrayOfPurchases.forEach { (singleLine) in
                let lineComponents = singleLine.components(separatedBy: ";")
                let itemName = lineComponents[0]
                let amount = Int(lineComponents[1])
                let price = lineComponents[2]
            }
        }
        //Step 4: convert each array to struct
        //Step 5: return
        return []
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
}
