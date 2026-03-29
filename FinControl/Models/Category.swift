//
//  Category.swift
//  FinControl
//
//  Created by Camila Vincensi on 06/01/26.
//

import Foundation

enum CategoryType: String {
    case income
    case expense
}

struct Category: Identifiable {

    let id: String
    let name: String
    let type: CategoryType
}

