//
//  CollectionView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import MongoSwift

struct CollectionView: View {
    let client: MongoClient
//    let dbName: String
    let path: Path
//    let collectionName: String
    
    @State private var collection: MongoCollection<BSONDocument>?
    @State private var errorMessage = ""
    @State private var docs = [BSONDocument]()
    
    var body: some View {
        VStack {
            // TODO: is hashValue unique?
            List(docs, id: \.hashValue) { doc in
                JSONView(doc: doc)
            }
            Spacer()
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red )
            }
        }
        .onChange(of: path, perform: { path in
            print("Collection name changed to \(path.dbName) - state collectionName = \(path.collectionName).")
            Task { await loadDocs(path: path) }
        })
//        .onChange(of: dbName, perform: { name in
//            print("Collection name changed to \(name) - state collectionName = \(collectionName). state dbName = \(dbName)")
//            Task { await loadDocs(dbName: name) }
//        })
        .task {
            print("Tasking")
            await loadDocs()
        }
    }
    
    func loadDocs(path: Path? = nil) async {
        docs = [BSONDocument]()
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        let db = client.db(path?.dbName ?? self.path.dbName)
        collection = db.collection(path?.collectionName ?? self.path.collectionName)
        let query: BSONDocument = [:]
        let options = FindOptions(limit: 10, sort: ["_id": -1])
        if let collection = collection {
            do {
                for try await doc in try await collection.find(query, options: options) {
                    docs.append(doc)
                }
            } catch {
                errorMessage = "Failed to read collection documents: \(error.localizedDescription)"
            }
        }
    }
    
    let monoFont = Font
        .system(size: 14)
        .monospaced()

}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
