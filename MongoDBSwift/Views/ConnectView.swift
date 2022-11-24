//
//  ConnectView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI

struct ConnectView: View {
    @Binding var client: MongoClientExt?
    
    @AppStorage("name") var name = ""
    @AppStorage("uri") var uri = ""
    
    @State private var errorMessage = ""
    @State private var inProgress = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Spacer()
                TextField("Nickname", text: $name)
                    .textFieldStyle(.roundedBorder)
                TextField("URI", text: $uri)
                    .textFieldStyle(.roundedBorder)
                Button(action: connect) {
                    Text("Connect")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(name.isEmpty || uri.isEmpty || inProgress)
                Spacer()
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            if inProgress {
                ProgressView()
            }
        }
        .padding()
    }
    
    private func connect() {
        inProgress = true
        if !errorMessage.isEmpty {
            errorMessage = ""
        }
        do {
            client = try MongoClientExt(name: name, uri: uri)
            inProgress = false
            print("Connected to \(uri)")
        } catch {
            inProgress = false
            errorMessage = "Failed to connect to \(name): \(error.localizedDescription)"
        }
    }
    
}

//struct ConnectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectView()
//    }
//}
