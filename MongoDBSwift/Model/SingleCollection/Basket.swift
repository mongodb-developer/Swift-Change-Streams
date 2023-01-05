//
//  Basket.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 28/11/2022.
//

import Foundation

struct Basket: Codable {
    let _id: String
    let docType: String
    let customer: String
    
    init(_id: String, customer: String) {
        self._id = _id
        docType = "basket"
        self.customer = customer
    }
}
