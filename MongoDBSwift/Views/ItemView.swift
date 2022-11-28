//
//  ItemView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 28/11/2022.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    
    var body: some View {
        VStack {
            Text("Item")
                .font(.title)
            Text("Item name: \(item.name)")
            Text("Quantity: \(item.quantity)")
        }
        .padding()
        .background(.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(item: Item(_id: "item123", name: "Fish", quantity: 5))
    }
}
