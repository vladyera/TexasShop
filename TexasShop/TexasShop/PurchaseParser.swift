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
        print(content)
        //Step 2: get content from the document (String)
        //Step 3: divide content to make arrays
        //Step 4: convert each array to struct
        //Step 5: return
        return []
    }
}
