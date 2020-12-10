//
//  IProcessStrategy.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 12/8/20.
//

import Foundation

protocol IProcessStrategy {
    func processToTerminal(purchases: [Purchase])
    func processToFile(purchases: [Purchase])
}
