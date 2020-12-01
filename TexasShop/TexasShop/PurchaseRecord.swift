//
//  PurchaseRecord.swift
//  TexasShop
//
//  Created by Uladzislau Yerashevich on 11/23/20.
//

enum ItemKind: String {
    case bread = "Bread"
    case milk = "Milk"
    case beer = "Beer"
    case shotgun = "Shotgun"
    case bullet = "Bullet"
    case cow = "Cow"
    case cowboyHat = "CowboyHat"
    case bible = "Bible"
}

struct PurchaseRecord {
    let itemKind: ItemKind
    let amount: Int
    let pricePerItem: Double
    
    var totalPrice: Double{
        return Double(amount) * pricePerItem
    }
}
