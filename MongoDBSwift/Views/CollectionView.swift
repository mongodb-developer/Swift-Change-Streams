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
    @State private var filterType = "String"
    @State private var filterStringValue = ""
    @State private var filterIntValue = 0
    @State private var filterDoubleValue: Double = 0.0
    @State private var filterValue = ""
    @State private var docCount: Int = 10
    @State private var changeStream: ChangeStream<ChangeStreamEvent<BSONDocument>>?
    @State private var latestChangeEvent: ChangeStreamEvent<BSONDocument>?
    @State private var showingChangeEvent = false
    @State private var enabledChangeStreams = false
    @State private var inProgress = false
    
    var body: some View {
        VStack {
            DataInputsView(
                sortField: $sortField,
                sortAscending: $sortAscending,
                filterKey: $filterKey,
                filterType: $filterType,
                filterStringValue: $filterStringValue,
                filterIntValue: $filterIntValue,
                filterDoubleValue: $filterDoubleValue,
                docCount: $docCount,
                enabledChangeStreams: $enabledChangeStreams,
                refreshData: {
                    Task {
                        await loadDocs()
                    }
                }
            )
            .padding()
            ZStack {
                List(docs, id: \.hashValue) { doc in
                    if path.dbName == "Single" && path.collectionName == "Collection" {
                        // This codepath is here to show how the Swift driver can be used with
                        // MongoDB's single collection pattern. With this pattern, documents with
                        // different shapes are stored in the same collection - each with a field
                        // named "type" which indicates what shape the structure should match. The
                        // pattern is also referred to as "polymorphic collections"
                        
                        if let docType = doc["docType"] {
                            switch docType {
                            case "basket":
                                if let basket = basket(doc: doc) {
                                    BasketView(basket: basket)
                                }
                            case "item":
                                if let item = item(doc: doc) {
                                    ItemView(item: item)
                                }
                            default:
                                Text("Unknown doc type")
                            }
                        }
                    } else {
                        JSONView(doc: doc)
                    }
                }
                if inProgress {
                    ProgressView()
                }
            }
            Spacer()
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red )
            }
        }
        .sheet(isPresented: $showingChangeEvent, content: {
            if let latestChangeEvent {
                ChangeEventView(event: latestChangeEvent)
            }
        })
        .onChange(of: path, perform: { path in
            Task {
                filterKey = ""
                filterValue = ""
                filterType = "String"
                sortField = "_id"
                sortAscending = false
                await loadDocs(path)
                await registerChangeStream()
            }
        })
        .onChange(of: enabledChangeStreams, perform: { _ in
            Task {
                await registerChangeStream()
            }
        })
        .task {
            await loadDocs()
            await registerChangeStream()
        }
    }
    
    private func basket(doc: BSONDocument) -> Basket? {
        do {
            return try BSONDecoder().decode(Basket.self, from: doc)
        } catch {
            print("Failed to convert BSON to a Basket: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func item(doc: BSONDocument) -> Item? {
        do {
            return try BSONDecoder().decode(Item.self, from: doc)
        } catch {
            print("Failed to convert BSON to a Item: \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadDocs(_ path: Path? = nil) async {
        inProgress = true
        docs = [BSONDocument]()
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        let db = client.db(path?.dbName ?? self.path.dbName)
        collection = db.collection(path?.collectionName ?? self.path.collectionName)
        var bsonFilterValue: BSON?
        if !filterKey.isEmpty {
            switch filterType {
            case "String":
                bsonFilterValue = BSON(stringLiteral: filterStringValue)
            case "Int":
                bsonFilterValue = BSON(integerLiteral: filterIntValue)
            case "Float":
                bsonFilterValue = BSON(floatLiteral: filterDoubleValue)
            default:
                print("Unknown filter type")
            }
        }
        var query: BSONDocument = [:]
        if let bsonFilterValue {
            query = [filterKey: bsonFilterValue]
        }
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
        inProgress = false
    }
    
    func registerChangeStream() async {
        if let changeStream = changeStream {
            _ = changeStream.kill()
            self.changeStream = nil
        }
        if enabledChangeStreams {
            do {
                let changeStreamOptions = ChangeStreamOptions(fullDocument: .updateLookup)
                changeStream = try await collection?.watch(options: changeStreamOptions)
                _ = changeStream?.forEach({ changeEvent in
                    withAnimation {
                        latestChangeEvent = changeEvent
                        showingChangeEvent = true
                        Task {
                            await loadDocs()
                        }
                    }
                })
            } catch {
                errorMessage = "Failed to register change stream: \(error.localizedDescription)"
            }
        }
    }
    
    let monoFont = Font
        .system(size: 12)
        .monospaced()
}

//struct CollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionView()
//    }
//}
