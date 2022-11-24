//
//  DatabaseView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import MongoSwift

struct DatabaseView: View {
    let client: MongoClient
    let dbName: String
    @Binding var selectedDbName: String
    @Binding var selectedCollectioName: String
    
    @State private var showingCollections = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        showingCollections.toggle()
                    }
                } label: {
                    Image(systemName: "triangle.fill")
                        .rotationEffect(showingCollections ? .degrees(180) : .degrees(90))
                        .imageScale(.small)
                    Text(dbName)
                    Spacer()
                }
                .buttonStyle(.borderless)
            }
            if showingCollections {
                CollectionsView(
                    client: client,
                    dbName: dbName,
                    selectedDbName: $selectedDbName,
                    selectedCollectioName: $selectedCollectioName)
            }
        }
    }
}

//struct DatabaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        DatabaseView()
//    }
//}
