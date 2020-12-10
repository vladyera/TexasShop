//
//  PurchaseRecord.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

enum ItemKind: String {
    case bread
    case milk
    case beer
    case shotgun
    case bullet
    case cow
    case cowboyHat
    case bible
}

struct PurchaseRecord {
    let itemKind: ItemKind
    let amount: Int
    let pricePerItem: Double
    
    var totalPrice: Double{
        return Double(amount) * pricePerItem
    }
}
