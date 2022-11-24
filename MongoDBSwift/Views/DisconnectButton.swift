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
    
    @State private var inProgress = false
    
    var body: some View {
        if let client = client {
            Button("Disconnect \(client.name)") {
                inProgress = true
                let _ = client.client?.close()
                cleanupMongoSwift()
                self.client = nil
                inProgress = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(inProgress)
        }
    }
}

//struct DisconnectButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DisconnectButton()
//    }
//}
