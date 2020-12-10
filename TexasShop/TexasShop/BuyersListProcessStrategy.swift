//
//  BuyersListProcessStrategy.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 12/8/20.
//

import Foundation

final class BuyersListProcessStrategy {
    private var fileHandle: FileHandle?
    private let filePath: URL
    
    init(filePath: URL) {
        self.filePath = filePath
    }
    
    deinit {
        try? fileHandle?.close()
    }
    
}

extension BuyersListProcessStrategy: IProcessStrategy {
    
    func processToFile(purchases: [Purchase]) {
        if fileHandle == nil {
            do {
                self.fileHandle = try FileHandle(forWritingTo: filePath)
            }
            catch {
                print(error)
            }
        }
        print(fileHandle)
        self.filePath.check
        fileHandle?.seekToEndOfFile()
        let testString = "werwe"
        fileHandle?.write(testString.data(using: .utf8)!)
        fileHandle?.synchronizeFile()
    }
    
    func processToTerminal(purchases: [Purchase]) {
        let lines: [String] = purchases.enumerated().map { (index, purchase) in
            return "\(index+1). \(purchase.personName)"
        }
        let result = lines.reduce(into: "") { (temp, line) in
            temp = "\(temp) \(line)\n"
        }
        print(result.dropLast())
    }
    
}
