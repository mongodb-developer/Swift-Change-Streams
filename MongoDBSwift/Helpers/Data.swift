//
//  Data.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import Foundation

extension Data {
    var prettyString: NSString? {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) ?? nil
    }
}
