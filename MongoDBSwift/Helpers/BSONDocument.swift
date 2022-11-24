//
//  BSONDocument.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import Foundation
import SwiftUI
import MongoSwift

extension BSONDocument {
    public func toPrettyJSONString() -> String {
        let encoder = ExtendedJSONEncoder()
        guard let encoded = try? encoder.encode(self) else {
            return ""
        }
        let flatString = String(data: encoded, encoding: .utf8) ?? ""
        return String(flatString.data(using: .utf8)?.prettyPrintedJSONString ?? "")
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
