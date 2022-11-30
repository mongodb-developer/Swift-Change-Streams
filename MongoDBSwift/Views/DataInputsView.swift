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
//    @Binding var queryValue: QueryValue
    @Binding var filterKey: String
    @Binding var filterType: String
//    @Binding var filterValue: String
    @Binding var filterStringValue: String
    @Binding var filterIntValue: Int
    @Binding var filterDoubleValue: Double
    @Binding var docCount: Int
    let refreshData: () -> Void
    
    let inputTypeOptions = ["String", "Int", "Float"]
    
    @State private var inProgress = false
    @State private var inputType = ""
    
    var body: some View {
        Form {
            TextField("Filter key", text: $filterKey)
                .textFieldStyle(.roundedBorder)
                .padding(4)
            Picker("Filter value type", selection: $filterType) {
                ForEach(inputTypeOptions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(4)
            switch filterType {
            case "String":
                TextField("Field value", text: $filterStringValue)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            case "Int":
                TextField("Field value", value: $filterIntValue, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            case "Float":
                TextField("Field value", value: $filterDoubleValue, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            default:
                TextField("Field value", text: $filterStringValue)
                    .textFieldStyle(.roundedBorder)
                    .padding(4)
            }
//            switch queryValue {
//            case .string:
//                TextField("Field value", text: $queryValue.string)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(4)
//            case .int:
//                TextField("Field value", value: $queryValue.int, format: .number)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(4)
//            case .float:
//                TextField("Field value", value: $queryValue.float, format: .number)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(4)
//            }
//            HStack {
//                TextField("Filter value", text: $filterValue)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(4)
//            }
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

//extension DataInputsView {
//    init(sortField: Binding<String>, sortAscending: Binding<Bool>, queryValue: Binding<QueryValue>, filterKey: Binding<String>, filterValue: Binding<String>, docCount: Binding<Int>, _ refreshData: @escaping () -> Void) {
//        self._sortField = sortField
//        self._sortAscending = sortAscending
//        self._queryValue = queryValue
//        self._filterKey = filterKey
//        self._filterValue = filterValue
//        self._docCount = docCount
//        self.refreshData = refreshData
//    }
//}

//struct DataInputsView_Previews: PreviewProvider {
//    static var previews: some View {
//        DataInputsView(
//            sortField: .constant("_id"),
//            sortAscending: .constant(false),
//            queryValue: .constant(QueryValue.string("")),
//            filterKey: .constant(""),
//            filterValue: .constant(""),
//            docCount: .constant(10),
//            refreshData: {})
//    }
//}
