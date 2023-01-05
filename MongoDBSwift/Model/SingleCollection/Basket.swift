//
//  Basket.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 28/11/2022.
//

import Foundation
import SwiftBSON

struct Basket: Codable {
    let _id: String
    let docType: String
    let customer: String
    
    init(doc: BSONDocument) {
        do {
            self = try BSONDecoder().decode(Basket.self, from: doc)
        } catch {
            _id = "n/a"
            docType = "basket"
            customer = "n/a"
            print("Failed to convert BSON to a Basket: \(error.localizedDescription)")
        }
    }
}

// For previews
extension Basket {
    init(_id: String, customer: String) {
        self._id = _id
        docType = "basket"
        self.customer = customer
    }
}
