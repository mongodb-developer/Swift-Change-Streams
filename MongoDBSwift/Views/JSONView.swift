//
//  JSONView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 23/11/2022.
//

import SwiftUI
import SwiftBSON

struct JSONView: View {
    let doc: BSONDocument
    
    @State private var isZoomed = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(doc.toPrettyJSONString())
                .font(monoFont)
                .padding()
                .background(.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isZoomed.toggle()
                    } label: {
                        Image(systemName: "text.magnifyingglass")
                            .imageScale(.large)
                    }
                    .buttonStyle(.borderless)
                    .sheet(isPresented: $isZoomed) {
                        ZoomedJSONView(doc: doc)
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    
    let monoFont = Font
        .system(size: 14)
        .monospaced()
}

//struct JSONView_Previews: PreviewProvider {
//    static var previews: some View {
//        JSONView()
//    }
//}
