//
//  ChangeEventView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 24/11/2022.
//

import SwiftUI
import MongoSwift

struct ChangeEventView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let event: ChangeStreamEvent<BSONDocument>
    var color: Color {
        switch event.operationType {
            
        case .insert:
            return .green
        case .update:
            return .yellow
        case .replace:
            return .orange
        case .delete:
            return .red
        default:
            return .teal
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.square")
                        .imageScale(.large)
                }
                .buttonStyle(.borderless)
            }
            ScrollView {
                HStack {
                    Text("Operation type")
                        .font(.largeTitle)
                    Spacer()
                }
                HStack {
                    Text(event.operationType.rawValue)
                        .font(monoFont)
                        .padding()
                    Spacer()
                }
                if let documentKey = event.documentKey {
                    HStack {
                        Text("Document key")
                            .font(.largeTitle)
                        Spacer()
                    }
                    HStack {
                        Text(documentKey.toPrettyJSONString())
                            .font(monoFont)
                            .padding()
                        Spacer()
                    }
                }
                if let updateDescription = event.updateDescription {
                    HStack {
                        Text("Update description")
                            .font(.largeTitle)
                        Spacer()
                    }
                    HStack {
                        Text(updateDescription.updatedFields.toPrettyJSONString())
                            .font(monoFont)
                            .padding()
                        Spacer()
                    }
                }
                if let fullDocument = event.fullDocument {
                    HStack {
                        Text("Full document")
                            .font(.largeTitle)
                        Spacer()
                    }
                    HStack {
                        Text(fullDocument.toPrettyJSONString())
                            .font(monoFont)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .background(color)
    }
    
    let monoFont = Font
        .system(size: 18)
        .monospaced()
}

//struct ChangeEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeEventView()
//    }
//}
