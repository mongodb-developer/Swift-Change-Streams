//
//  DatabasesView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import MongoSwift

struct DatabasesView: View {
    let client: MongoClient
    @Binding var dbName: String
    @Binding var collectionName: String
    
    @State private var inProgress = false
    @State private var errorMessage = ""
    @State private var dbs: [DatabaseSpecification]?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            await listDBs()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                    .disabled(inProgress)
                }
                if let dbs = dbs {
                    List(dbs) { db in
                        DatabaseView(
                            client: client,
                            dbName: db.name,
                            selectedDbName: $dbName,
                            selectedCollectioName: $collectionName
                        )
//                        Text(db.name)
//                        CollectionsView(client: client, dbName: db.name)
                    }
                    .listStyle(.sidebar)
                }
                Spacer()
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
            if inProgress {
                ProgressView()
            }
        }
        .task() {
            await listDBs()
        }
    }
    
    private func listDBs() async {
        inProgress = true
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        do {
            dbs = try await client.listDatabases()
        } catch {
            errorMessage = "Failed to list databases: \(error.localizedDescription)"
        }
        inProgress = false
    }
}

//struct DatabasesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatabasesView()
//    }
//}
