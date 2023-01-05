//
//  Item.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 28/11/2022.
//

import Foundation
import SwiftBSON

struct Item: Codable {
    let _id: String
    let docType: String
    let name: String
    let quantity: Int
    
    init(doc: BSONDocument) {
        do {
            self = try BSONDecoder().decode(Item.self, from: doc)
        } catch {
            _id = "n/a"
            docType = "item"
            name = "n/a"
            quantity = 0
            print("Failed to convert BSON to a Item: \(error.localizedDescription)")
        }
    }
}

// For previews
extension Item {
    init(_id: String, name: String, quantity: Int) {
        self._id = _id
        docType = "item"
        self.name = name
        self.quantity = quantity
    }
}
