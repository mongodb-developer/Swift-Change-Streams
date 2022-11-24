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
    
//    @State private var dbName = ""
//    @State private var collectionName = ""
    
    var title: String {
        path.dbName.isEmpty ? "MongoDB Swift" : path.collectionName.isEmpty ? "\(path.dbName)" : "\(path.dbName).\(path.collectionName)"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let client {
                    if let mongoClient = client.client {
                        VStack {
                            Text("Connected to \(client.name)")
                            DisconnectButton(client: self.$client)
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
                    Text("Placeholder view")
                } else {
//                    CollectionView(client: mongoClient, dbName: dbName, collectionName: collectionName)
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
