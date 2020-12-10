//
//  CommandProcessor.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 12/8/20.
//

import Foundation

final class CommandProcessor {
    func startProcessing(_ strategy: IProcessStrategy, purchases: [Purchase]){
        strategy.processToFile(purchases: purchases)
    }
}
