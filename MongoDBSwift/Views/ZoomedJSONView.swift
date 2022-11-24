//
//  ZoomedJSONView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import SwiftBSON

struct ZoomedJSONView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let doc: BSONDocument
    
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
                Text(doc.toPrettyJSONString())
                    .font(monoFont)
            }
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .background(.secondary)
    }
    
    let monoFont = Font
        .system(size: 24)
        .monospaced()
}

//struct ZoomedJSONView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZoomedJSONView()
//    }
//}
