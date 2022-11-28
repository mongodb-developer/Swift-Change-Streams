//
//  BasketView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 28/11/2022.
//

import SwiftUI

struct BasketView: View {
    let basket: Basket
    
    var body: some View {
        VStack {
            Text("Basket")
                .font(.title)
            Text("Order number: \(basket._id)")
            Text("Customer: \(basket.customer)")
        }
        .padding()
        .background(.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
    }
}

struct BasketView_Previews: PreviewProvider {
    static var previews: some View {
        BasketView(basket: Basket(_id: "basket101", customer: "Fred"))
    }
}
