//
//  GenericListView.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI

struct GenericListView: View {
    var cells : [GenericListViewData]

    var body: some View {
        List(cells, id: \.id) { cell in
            GenericListViewCell(data: cell)
                .listRowSeparator(.hidden)
        }
        .disabled(true)
        .listStyle(PlainListStyle())
        .clearListBackground()
    }
}

struct GenericListView_Previews: PreviewProvider {
    static var previews: some View {
        GenericListView(cells: GenericListViewData.preview())
    }
}

