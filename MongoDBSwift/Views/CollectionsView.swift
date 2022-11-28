//
//  CollectionsView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import MongoSwift

struct CollectionsView: View {
    let client: MongoClient
    let dbName: String
    
    @Binding var selectedDbName: String
    @Binding var selectedCollectioName: String
    
    @State private var collections = [String]()
    @State private var inProgress = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(collections, id: \.self) { collection in
                    HStack {
                        Button {
                            selectedDbName = dbName
                            selectedCollectioName = collection
                        } label: {
                            Text(collection)
                                .fontWeight(selectedDbName == dbName && selectedCollectioName == collection ? .bold : .light)
                                .foregroundColor(selectedDbName == dbName && selectedCollectioName == collection ? .primary : .secondary)
                        }
                        .buttonStyle(.borderless)
                        Spacer()
                    }
                }
            }
            if inProgress {
                ProgressView()
            }
        }
        .padding(.leading, 20)
        .task {
            await listCollections()
        }
    }
    
    private func listCollections() async {
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        inProgress = true
        let db = client.db(dbName)
        do {
            let collections = try await db.listCollections()
            // TODO: Use map?
            let collectionsArray = try await collections.toArray()
            self.collections = [String]()
            collectionsArray.forEach { collection in
                self.collections.append(collection.name)
            }
        } catch {
            errorMessage = "Failed to list collections: \(error.localizedDescription)"
        }
        inProgress = false
    }
}

//struct CollectionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionsView()
//    }
//}
