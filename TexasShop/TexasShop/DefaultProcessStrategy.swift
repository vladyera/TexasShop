//
//  DefaultProcessStrategy.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 12/8/20.
//

import Foundation

final class DefaultProcessStrategy {
    
}

extension DefaultProcessStrategy: IProcessStrategy {
    
    func processToFile(purchases: [Purchase]) {
    }
    
    func processToTerminal(purchases: [Purchase]) {
        print("This strategy has no implementation yet")
    }
}
