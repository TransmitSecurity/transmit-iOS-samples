//
//  GenericListViewCell.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import SwiftUI


struct GenericListViewCell: View {
    let data: GenericListViewData
    
    var body: some View {
        HStack(spacing: 18) {
            Image(data.icon)
            Text(data.title).font(Font.custom(Constants.Fonts.Inter.regular, size: 14)).foregroundColor(Color.black).multilineTextAlignment(.leading)
        }.listRowBackground(Color.white)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

    }
}

struct GenericListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        GenericListViewCell(data: GenericListViewData.preview().first!)
    }
}
