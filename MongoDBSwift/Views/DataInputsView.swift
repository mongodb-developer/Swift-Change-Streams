//
//  DataInputsView.swift
//  MongoDBSwift
//
//  Created by Andrew Morgan on 24/11/2022.
//

import SwiftUI

struct DataInputsView: View {
    @Binding var sortField: String
    @Binding var sortAscending: Bool
    @Binding var filterKey: String
    @Binding var filterValue: String
    @Binding var docCount: Int
    let refreshData: () -> Void
    
    @State private var inProgress = false
    
    init(sortField: Binding<String>, sortAscending: Binding<Bool>, filterKey: Binding<String>, filterValue: Binding<String>, docCount: Binding<Int>, _ refreshData: @escaping () -> Void) {
        self._sortField = sortField
        self._sortAscending = sortAscending
        self._filterKey = filterKey
        self._filterValue = filterValue
        self._docCount = docCount
        self.refreshData = refreshData
    }
    
    var body: some View {
        Form {
            HStack {
                TextField("Filter key", text: $filterKey)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                Spacer()
            }
            HStack {
                TextField("Filter value", text: $filterValue)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            }
            HStack {
                TextField("Sort string", text: $sortField)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                Toggle(isOn: $sortAscending) {
                    Text("Sort ascending?")
                }
                .padding(4)
            }
            HStack {
                TextField("Number of documents", value: $docCount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
                Spacer()
                Button() {
                    inProgress = true
                    refreshData()
                    inProgress = false
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
                .disabled(inProgress)
                .buttonStyle(.borderedProminent)
                .padding(4)
            }
        }
    }
}

struct DataInputsView_Previews: PreviewProvider {
    static var previews: some View {
        DataInputsView(sortField: .constant("_id"), sortAscending: .constant(false), filterKey: .constant(""), filterValue: .constant(""), docCount: .constant(10)) {}
    }
}
