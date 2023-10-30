//
//  GenericListViewData.swift
//  IdentityVerificationSwiftUIExample
//
//  Created by Tomer Picker on 22/06/2023.
//

import Foundation

struct GenericListViewData: Identifiable {
    var title: String
    var icon: String
    let key = UUID()
    
    var id: UUID {
        return key
    }
    
    static func preview() -> [GenericListViewData] {
        [GenericListViewData(title: "first", icon: "ic_document"),
         GenericListViewData(title: "second", icon: "ic_document"),
         GenericListViewData(title: "third", icon: "ic_document")]
    }
}

