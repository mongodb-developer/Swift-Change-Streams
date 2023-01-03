//
//  String.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 30/11/2022.
//

import Foundation

extension String {
    func maskPassword() -> String {
        // Expect string to be of this form: "mongodb+srv://username:password@cluster-address" or
        // mongodb://localhost
        let stringRange = NSRange(
            self.startIndex..<self.endIndex,
            in: self
        )
        let capturePattern = #"([^:]+:[^:]+:)([^@]+)(.*)"#
        let captureRegex = try! NSRegularExpression(
            pattern: capturePattern,
            options: []
        )
        let matches = captureRegex.matches(
            in: self,
            options: [],
            range: stringRange
        )
        guard let match = matches.first else {
            return self
        }
        var components = [String]()
        for rangeIndex in 0..<match.numberOfRanges {
            let matchRange = match.range(at: rangeIndex)
            if matchRange == stringRange { continue }
            if let substringRange = Range(matchRange, in: self) {
                let capture = String(self[substringRange])
                components.append(capture)
            }
        }
        guard components.count >= 3 else {
            return "Couldn't find all elements in the URI"
        }
        return "\(components[0])********\(components[2])"
    }
}
