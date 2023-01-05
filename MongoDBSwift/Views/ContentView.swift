//
//  ContentView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var client: MongoClientExt?
    @State private var path = Path()
    
    var title: String {
        path.dbName.isEmpty ? "MongoDB Swift" : path.collectionName.isEmpty ? "\(path.dbName)" : "\(path.dbName).\(path.collectionName)"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let client {
                    if let mongoClient = client.client {
                        VStack {
                            DisconnectButton(client: self.$client, path: self.$path)
                            DatabasesView(client: mongoClient, dbName: $path.dbName, collectionName: $path.collectionName)
                            Spacer()
                        }
                    } else {
                        Text("Connecting...")
                    }
                } else {
                    Text("Need to connect to a cluster")
                }
            }
            .frame(minWidth: 250)
            if let mongoClient = client?.client {
                if path.dbName.isEmpty || path.collectionName.isEmpty {
                    Text("Select a database and collection")
                } else {
                    CollectionView(client: mongoClient, path: path)
                }
            } else {
                ConnectView(client: $client)
            }
        }
        .frame(minWidth: 600, minHeight: 600)
        .navigationTitle(title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
