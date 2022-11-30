//
//  QueryValue.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 30/11/2022.
//

import Foundation

enum QueryValue: CaseIterable {
    case string(String)
    case int(Int)
    case float(Float)
    
    static var allCases: [QueryValue] {
        return [.string(""), .int(0), .float(0.0)]
    }
}

extension QueryValue {
    static var allTypes: [String] {
        return Self.allCases.map {
            $0.toString()
        }
    }
}

extension QueryValue: Identifiable {
    var id: String { self.toString() }
}

extension QueryValue {
    var string: String {
        get {
            switch self {
            case let .string(string):
                return string
            default:
                return "Not a string"
            }
        }
        set {
            switch self {
            case .string:
                self = .string(newValue)
            default:
                print("Not a string")
            }
        }
    }
    
    var int: Int {
        get {
            switch self {
            case let .int(int):
                return int
            default:
                print("Not an int")
                return 0
            }
        }
        set {
            switch self {
            case .int:
                self = .int(newValue)
            default:
                print("Not an int")
            }
        }
    }
    
    var float: Float {
        get {
            switch self {
            case let .float(float):
                return float
            default:
                print("Not a float")
                return 0.0
            }
        }
        set {
            switch self {
            case .float:
                self = .float(newValue)
            default:
                print("Not a float")
            }
        }
    }
}

extension QueryValue {
    func toString() -> String {
        switch self {
        case .float:
            return "Float"
        case .int:
            return "Int"
        case .string:
            return "String"
        }
    }
}

//extension QueryValue {
//    init (_ name: String) {
//        var queryValue: QueryValue
//        switch name {
//        case "String":
//            self = QueryValue.string
//        }
//    }
//}

//extension QueryValue {
//    var isEmpty: Bool {
//        switch self {
//        case let .string(string):
//            return string.isEmpty
//        case let .int(int):
//            return int == 0
//        case let .float(float):
//            return float == 0.0
//        }
//    }
//}
