//
//  DisconnectButton.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import MongoSwiftSync

struct DisconnectButton: View {
    @Binding var client: MongoClientExt?
    @Binding var path: Path
    
    @State private var inProgress = false
    
    var body: some View {
        if let client = client {
            Button("Disconnect \(client.name)") {
                inProgress = true
                let _ = client.client?.close()
                path.dbName = ""
                path.collectionName = ""
                cleanupMongoSwift()
                self.client = nil
                inProgress = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(inProgress)
        }
    }
}

struct DisconnectButton_Previews: PreviewProvider {
    static var previews: some View {
        DisconnectButton(client: .constant(nil), path: .constant(Path()))
    }
}
