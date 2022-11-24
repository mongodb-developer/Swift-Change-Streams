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
    let path: Path
    
    @State private var collection: MongoCollection<BSONDocument>?
    @State private var errorMessage = ""
    @State private var docs = [BSONDocument]()
    @State private var sortField = "_id"
    @State private var sortAscending = false
    @State private var filterKey = ""
    @State private var filterValue = ""
    @State private var docCount: Int = 10
    @State private var changeStream: ChangeStream<ChangeStreamEvent<BSONDocument>>?
    
    var body: some View {
        VStack {
            DataInputsView(sortField: $sortField, sortAscending: $sortAscending, filterKey: $filterKey, filterValue: $filterValue, docCount: $docCount) {
                Task {
                    await loadDocs()
                }
            }
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
            Task {
                await loadDocs(path)
                await registerChangeStream()
            }
        })
        .task {
            await loadDocs()
            await registerChangeStream()
        }
    }
    
    func loadDocs(_ path: Path? = nil) async {
        docs = [BSONDocument]()
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        let db = client.db(path?.dbName ?? self.path.dbName)
        collection = db.collection(path?.collectionName ?? self.path.collectionName)
        let query: BSONDocument = filterKey.isEmpty || filterValue.isEmpty ? [:] : [filterKey: BSON(stringLiteral: filterValue)]
        let options = FindOptions(limit: docCount, sort: [sortField: sortAscending ? 1 : -1])
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
    
    func registerChangeStream() async {
        // TODO: Clean up any existing change stream
        if let changeStream = changeStream {
            _ = changeStream.kill()
            self.changeStream = nil
        }
        do {
            changeStream = try await collection?.watch()
            _ = changeStream?.forEach({ changeEvent in
                print("Received event")
                print(changeEvent.operationType)
                print(changeEvent.fullDocument ?? "No fullDocument")
            })
        } catch {
            errorMessage = "Failed to register change stream: \(error.localizedDescription)"
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
