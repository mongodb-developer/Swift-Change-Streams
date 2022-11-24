//
//  MongoClientExt.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import Foundation
import MongoSwift
import NIOPosix

class  MongoClientExt {
    var name = ""
    var client: MongoClient?
    
    convenience init(name: String, uri: String) throws {
        self.init()
        let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
        let client = try MongoClient(uri, using: elg)
        self.client = client
        self.name = name
    }
    
}

extension CollectionSpecification: Identifiable {
    public var id: String { name }
}

extension DatabaseSpecification: Identifiable {
    public var id: String { name }
}
