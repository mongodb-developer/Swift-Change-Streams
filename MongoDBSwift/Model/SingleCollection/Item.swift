//
//  Item.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 28/11/2022.
//

import Foundation

struct Item: Codable {
    let _id: String
    let docType: String
    let name: String
    let quantity: Int

    init(_id: String, name: String, quantity: Int) {
        self._id = _id
        docType = "item"
        self.name = name
        self.quantity = quantity
    }
}

